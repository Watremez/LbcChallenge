//
//  CategoryCellVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 14/05/2021.
//

import Foundation
import UIKit


class CategoryCellVm {
    
    private var categoryUpdated : (() -> ()) = { }
    
    private(set) var category : Category! {
        didSet {
            self.categoryUpdated()
        }
    }
    
    init(categoryAtIndex index:Int, onCategoryUpdate : (() -> ())?) {
        
        onCategoryUpdate.map { callBack in
            self.categoryUpdated = callBack
        }
        
        self.loadData(index: index)
        
    }
    
    private func loadData(index: Int) {
        if index >= 0 {
            self.category = Content.shared.categories[index]
        }
    }
    
}
