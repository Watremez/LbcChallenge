//
//  CategoryListVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 16/05/2021.
//

import Foundation

protocol CategoryFilterVmProtocol : AnyObject {
    var choices : Observable<[String]> { get }
    var selectedCategory : Observable<Category?> { get }
    var onSelectedCategoryChangedClosure : ((Category?)->())? { get set }
    
    func selectCategory(at row: Int)
    func getSelectedCategoryIndex() -> Int
    func setSelectedCategory(_ newSelectedCategory : Category?)
}

class CategoryFilterVm : CategoryFilterVmProtocol {
    private var categories : [Category]
    private(set) var choices : Observable<[String]>
    private(set) var selectedCategory : Observable<Category?>
    var onSelectedCategoryChangedClosure : ((Category?)->())? = nil

    init(categoryList : [Category]) {
        self.categories = []
        self.choices = Observable<[String]>(initialValue: [])
        self.selectedCategory = Observable<Category?>(initialValue: nil)
        self.processFetchedCategories(downloadedCategories: categoryList)
    }
    
    private func processFetchedCategories(downloadedCategories: [Category]) {
        self.categories = downloadedCategories
        var theChoices = [String]()
        theChoices.removeAll()
        theChoices.append("Toutes les catégories")
        for category in downloadedCategories {
            theChoices.append(category.name)
        }
        self.choices.value = theChoices
    }
    
    func selectCategory(at row: Int){
        if row == 0 {
            self.setSelectedCategory(nil)
        } else {
            self.setSelectedCategory(self.categories[row - 1])
        }
    }
    
    func getSelectedCategoryIndex() -> Int {
        if let sc = self.selectedCategory.value {
            if let index = self.categories.firstIndex(where: { oneCategory in
                oneCategory.id == sc.id
            }){
                return index + 1
            } else {
                return 0
            }
        } else {
            return 0
        }
    }

    func setSelectedCategory(_ newSelectedCategory : Category? = nil) {
        self.selectedCategory.value = newSelectedCategory
        self.onSelectedCategoryChangedClosure?(self.selectedCategory.value)
    }
}
