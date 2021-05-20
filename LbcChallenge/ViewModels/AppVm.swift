//
//  ContentsVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 15/05/2021.
//

import Foundation

protocol AppVmProtocol {
    var appIsLoading: Observable<Bool> { get }
    var alertMessage : Observable<String?> { get }
    var adListViewModel : AdListVmProtocol? { get }
    var categoryFilterViewModel : CategoryFilterVmProtocol? { get }
    
    func initFetch()
    func selectedCategoryChanged(newSelectedCategory : Category?)
    func getSelectedCategoryViewModel() -> SelectedCategoryVmProtocol?
}

class AppVm : AppVmProtocol {
    private var baseUrl : String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/"
    private let apiService: ApiServiceProtocol
    let appIsLoading: Observable<Bool>
    let alertMessage : Observable<String?>
    var adListViewModel : AdListVmProtocol? = nil
    var categoryFilterViewModel : CategoryFilterVmProtocol? = nil

    init(apiService: ApiServiceProtocol = ApiService(), domainUrlString: String? = nil) {
        self.apiService = apiService
        if let domain = domainUrlString {
            self.baseUrl = domain
        }
        self.appIsLoading = Observable<Bool>(initialValue: false)
        self.alertMessage = Observable<String?>(initialValue: nil)
//        Notification.Name.SelectedCategory.onNotified { [weak self] note in
//            guard let `self` = self else { return }
//            if let obj = note.object {
//                if obj is Category? {
//                    let selectedCategory = obj as! Category?
//                    self.selecteCategoryChanged(newSelectedCategory: selectedCategory)
//                    return
//                }
//            }
//            self.selecteCategoryChanged(newSelectedCategory: nil)
//        }

    }
    
    func initFetch() {
        self.appIsLoading.value = true
        self.apiService.getDecodedDataFromUrl([Category].self, from: baseUrl + "categories.json") { [weak self] (result : ApiStatus<[Category]>) in
            guard let `self` = self else { return }
            switch result {
            case .success(let downloadedCategories):
                Content.shared.categories = downloadedCategories
                self.categoryFilterViewModel = CategoryFilterVm(categoryList: Content.shared.categories)
                self.categoryFilterViewModel!.onSelectedCategoryChangedClosure = self.selectedCategoryChanged
                self.fetchAds()
            case .wrongDownload :
                self.alertMessage.value = "Erreur pendant le téléchargement des catégories d'annonce. \nVérifiez votre connexion à Internet."
            case .wrongJsonDecoding(let message):
                self.alertMessage.value = "Erreur de décodage des catégories reçues : \n\(message)"
            case .wrongUrlFormat(let message):
                self.alertMessage.value = "L'adresse internet où récupérer les catégories d'annonce est incorrecte. : \n\(message)"
            default:
                self.alertMessage.value = "Erreur de chargement des catégories."
            }
        }
    }
    
    private func fetchAds(){
        self.apiService.getDecodedDataFromUrl([Ad].self, from: baseUrl + "listing.json") { [weak self] (result : ApiStatus<[Ad]>) in
            guard let `self` = self else { return }
            switch result {
            case .success(let downloadedAds):
                Content.shared.ads = downloadedAds
                self.adListViewModel = AdListVm(apiService: self.apiService, adList: Content.shared.ads)
                self.appIsLoading.value = false
            case .wrongDownload :
                self.alertMessage.value = "Erreur pendant le téléchargement des annonces. \nVérifiez votre connexion à Internet."
            case .wrongJsonDecoding(let message):
                self.alertMessage.value = "Erreur de décodage des annonces reçues : \n\(message)"
            case .wrongUrlFormat(let message):
                self.alertMessage.value = "L'adresse internet où récupérer les annonces est incorrecte. : \n\(message)"
            default:
                self.alertMessage.value = "Erreur de chargement des annonces."
            }
        }
    }

    func selectedCategoryChanged(newSelectedCategory : Category?){
        self.adListViewModel?.processFetchedAds(downloadedAds: Content.shared.ads, filterOnCategory: newSelectedCategory)
    }
    
    func getSelectedCategoryViewModel() -> SelectedCategoryVmProtocol? {
        guard
            let catFilterVm = self.categoryFilterViewModel,
            let selCat = catFilterVm.selectedCategory.value
        else { return nil }

        return SelectedCategoryVm(selectedCategory: selCat, onRemoveTouchUp: {
            catFilterVm.setSelectedCategory(nil)
        })
    }

}
