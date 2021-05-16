//
//  ContentsVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 15/05/2021.
//

import Foundation

class AppVm {
    private var baseUrl : String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/"
    private let apiService: ApiServiceProtocol
    let appIsLoading: Observable<Bool>
    let alertMessage : Observable<String?>
    var adListViewModel : AdListVm? = nil
    var categoryFilterViewModel : CategoryFilterVm? = nil

    init(apiService: ApiServiceProtocol = ApiService(), domainUrlString: String? = nil) {
        self.apiService = apiService
        if let domain = domainUrlString {
            self.baseUrl = domain
        }
        self.appIsLoading = Observable<Bool>(initialValue: false)
        self.alertMessage = Observable<String?>(initialValue: nil)
        
        Notification.Name.SelectedCategory.onNotified { [weak self] note in
            guard let `self` = self else { return }
            if let obj = note.object {
                if obj is Category? {
                    let selectedCategory = obj as! Category?
                    self.adListViewModel?.processFetchedAds(downloadedAds: Content.shared.ads, filterOnCategory: selectedCategory)
                    return
                }
            }
            self.adListViewModel?.processFetchedAds(downloadedAds: Content.shared.ads)
        }

    }
    
    func initFetch() {
        self.appIsLoading.value = true
        self.apiService.getDecodedDataFromUrl([Category].self, from: baseUrl + "categories.json") { [weak self] (result : ApiStatus<[Category]>) in
            guard let `self` = self else { return }
            switch result {
            case .success(let downloadedCategories):
                Content.shared.categories = downloadedCategories
                Notification.Name.CategoriesDownloaded.post()
                self.categoryFilterViewModel = CategoryFilterVm(apiService: self.apiService, categoryList: Content.shared.categories)
                self.fetchAds()
            default:
                self.alertMessage.value = "error loading categories"
            }
        }
    }
    
    private func fetchAds(){
        self.apiService.getDecodedDataFromUrl([Ad].self, from: baseUrl + "listing.json") { [weak self] (result : ApiStatus<[Ad]>) in
            guard let `self` = self else { return }
            switch result {
            case .success(let downloadedAds):
                Content.shared.ads = downloadedAds
                Notification.Name.AdsDownloaded.post()
                self.adListViewModel = AdListVm(apiService: self.apiService, adList: Content.shared.ads)
                self.appIsLoading.value = false
            default:
                self.alertMessage.value = "error loading listing"
            }
        }
    }

}
