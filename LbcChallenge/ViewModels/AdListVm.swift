//
//  AdListVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 15/05/2021.
//

import Foundation

class AdListVm {

    private let apiService: ApiServiceProtocol
    private var ads = [Ad]()
    private var adCellViewModels : [AdCellVm] {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    private var adDetailViewModel : AdDetailVm? = nil

    var reloadTableViewClosure: (()->())?
    var numberOfCells: Int {
         return adCellViewModels.count
     }

    init(apiService: ApiServiceProtocol = ApiService(), adList : [Ad]) {
        self.apiService = apiService
        self.adCellViewModels = []
        self.processFetchedAds(downloadedAds: adList)
    }
    
    func processFetchedAds(downloadedAds: [Ad], filterOnCategory : Category? = nil) {
        self.ads = []
        var myFilteredAds = downloadedAds
        filterOnCategory.map { oneCat in
            myFilteredAds = downloadedAds.filter({ anAd in
                anAd.category_id == oneCat.id
            })
        }
        self.ads.append(contentsOf: myFilteredAds.sorted(by: { ad1, ad2 in
            if ad1.is_urgent == ad2.is_urgent {
                return ad1.creation_date >= ad2.creation_date
            } else if ad1.is_urgent {
                return true
            } else {
                return false
            }
        }))
        var cellVms = [AdCellVm]()
        for ad in self.ads {
            cellVms.append(createAdCellViewModel(accordingTo: ad))
        }
        self.adCellViewModels = cellVms
    }

    private func createAdCellViewModel(accordingTo ad: Ad) -> AdCellVm {
        let locale = Locale(identifier: "fr-FR")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "EUR"
        numberFormatter.locale = locale

        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium

        return AdCellVm(
            apiService: self.apiService,
            title: ad.title,
            category: ad.category?.name ?? "",
            price: numberFormatter.string(from: NSNumber(value: ad.price)) ?? "n/a",
            depositeDate: dateFormatter.string(from: ad.creation_date),
            urgent: ad.is_urgent,
            pictureUrl: ad.images_url.thumb
        )
    }

    private func createAdDetailViewModel(accordingTo ad: Ad) -> AdDetailVm {
        let locale = Locale(identifier: "fr-FR")
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "EUR"
        numberFormatter.locale = locale

        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium

        return AdDetailVm(
            apiService: self.apiService,
            title: ad.title,
            category: ad.category?.name ?? "",
            price: numberFormatter.string(from: NSNumber(value: ad.price)) ?? "n/a",
            depositeDate: dateFormatter.string(from: ad.creation_date),
            urgent: ad.is_urgent,
            description: ad.description,
            thumbPictureUrl: ad.images_url.thumb,
            smallPictureUrl: ad.images_url.small
        )
    }

    func getCellViewModel(at indexPath: IndexPath) -> AdCellVm {
        return adCellViewModels[indexPath.row]
    }
    
    func getDetailViewModel(at indexPath: IndexPath) -> AdDetailVm {
        self.adDetailViewModel = createAdDetailViewModel(accordingTo: self.ads[indexPath.row])
        return self.adDetailViewModel!
    }

}
