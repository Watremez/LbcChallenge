//
//  CategoriesVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 14/05/2021.
//

import Foundation


class CategoriesVm {
    
    private var categoriesUpdated : (() -> ()) = { }
    
    private(set) var categories : [Category]! {
        didSet {
            self.categoriesUpdated()
        }
    }
    
    init(onCategoriesUpdate : (() -> ())?) {
        
        onCategoriesUpdate.map { callBack in
            self.categoriesUpdated = callBack
        }

        self.loadData()
        Notification.Name.CategoriesDownloaded.onNotified { [weak self] note in
            guard let `self` = self else { return }
            self.loadData()
        }
        
    }
    
    private func loadData() {
        self.categories = Content.shared.categories
    }
}

