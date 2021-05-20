//
//  SelectdCategoryVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 19/05/2021.
//

import Foundation

protocol SelectedCategoryVmProtocol : AnyObject {
    var selectedCategoryName : String { get }
    
    func onRemoveTouchUp()
}

class SelectedCategoryVm : SelectedCategoryVmProtocol {
    private var onRemoveTouchUpCallBack : () -> ()
    private(set) var selectedCategoryName: String
    private var category : Category
    
    init(selectedCategory : Category, onRemoveTouchUp: @escaping () -> ()) {
        self.category = selectedCategory
        self.selectedCategoryName = self.category.name
        self.onRemoveTouchUpCallBack = onRemoveTouchUp
    }
    
    func onRemoveTouchUp() {
        onRemoveTouchUpCallBack()
    }
}
