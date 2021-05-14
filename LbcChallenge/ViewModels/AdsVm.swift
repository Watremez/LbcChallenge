//
//  AdsVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 14/05/2021.
//

import Foundation


class AdsVm {
    
    private var adsUpdated : (() -> ()) = { }
    
    private(set) var ads : [Ad]! {
        didSet {
            self.adsUpdated()
        }
    }
    
    init(onAdsUpdate : (() -> ())?) {
        
        onAdsUpdate.map { callBack in
            self.adsUpdated = callBack
        }

        self.loadData()
        Notification.Name.AdsDownloaded.onNotified { [weak self] note in
            guard let `self` = self else { return }
            self.loadData()
        }
        
        Notification.Name.SelectedCategory.onNotified { [weak self] note in
            guard let `self` = self else { return }
            if let obj = note.object {
                if obj is Category? {
                    let selectedCategory = obj as! Category?
                    self.loadData(filterOnCategory: selectedCategory)
                    return
                }
            }
            self.loadData()
        }

    }
    
    private func loadData(filterOnCategory : Category? = nil) {
        if let category = filterOnCategory {
            self.ads = Content.shared.ads.filter({ oneAd in
                oneAd.category_id == category.id
            })
        } else {
            self.ads = Content.shared.ads
        }
    }
}
