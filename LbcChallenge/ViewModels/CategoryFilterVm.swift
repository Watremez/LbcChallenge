//
//  CategoryFilterVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 14/05/2021.
//

import Foundation


class CategoryFilterVm {
    
    var categoriesUpdated : (() -> ()) = { }
    var categorySelectionUpdated : ((Category?) -> ()) = {maybeNewSelectedCategory in }
    
    private(set) var categories : [Category]! {
        didSet {
            self.categoriesUpdated()
        }
    }
    var categorySelected : Category? = nil {
        didSet {
            Notification.Name.SelectedCategory.post(object: self.categorySelected)
            self.categorySelectionUpdated(self.categorySelected)
        }
    }
    
    init(onCategoriesUpdate : (() -> ())? = nil, onCategorySelectionUpdate : ((Category?) -> ())? = nil) {
        onCategoriesUpdate.map { callBack in
            self.categoriesUpdated = callBack
        }
        onCategorySelectionUpdate.map { callBack in
            self.categorySelectionUpdated = callBack
        }

        self.loadData()
        Notification.Name.CategoriesDownloaded.onNotified { [weak self] note in
            guard let `self` = self else { return }
            self.loadData()
        }
        
    }
    
    private func loadData() {
        self.categories = Content.shared.categories
        self.categorySelected = nil
    }
    
    
}

