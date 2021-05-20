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
    func getCategoryFilterCellViewModel(at row : Int) -> CategoryFilterCellVmProtocol
}

class CategoryFilterVm : CategoryFilterVmProtocol {
    private var categories : [Category]
    private var categoryFilterCellViewModels : [CategoryFilterCell]
    private(set) var choices : Observable<[String]>
    private(set) var selectedCategory : Observable<Category?>
    var onSelectedCategoryChangedClosure : ((Category?)->())? = nil

    init(categoryList : [Category]) {
        self.categories = []
        self.categoryFilterCellViewModels = []
        self.choices = Observable<[String]>(initialValue: [])
        self.selectedCategory = Observable<Category?>(initialValue: nil)
        self.processFetchedCategories(downloadedCategories: categoryList)
    }
    
    private func processFetchedCategories(downloadedCategories: [Category]) {
        self.categories = downloadedCategories
        var theChoices = [String]()
        self.categoryFilterCellViewModels.removeAll()
        theChoices.removeAll()
        theChoices.append("Toutes les catégories")
        self.categoryFilterCellViewModels.append(
            CategoryFilterCell(
                id: -1,
                name: theChoices.last!,
                selected: self.selectedCategory.value == nil ? true : false
            )
        )
        for category in downloadedCategories {
            theChoices.append(category.name)
            self.categoryFilterCellViewModels.append(
                CategoryFilterCell(
                    id: category.id,
                    name: category.name,
                    selected: self.selectedCategory.value == nil ? false : (self.selectedCategory.value!.id == category.id)
                )
            )
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
        for catFilterCellVm in self.categoryFilterCellViewModels {
            if catFilterCellVm.id == -1 {
                catFilterCellVm.select(newSelectedCategory == nil)
            } else {
                if let currentSelCat = self.selectedCategory.value, currentSelCat.id == catFilterCellVm.id {
                    catFilterCellVm.select(true)
                } else {
                    catFilterCellVm.select(false)
                }
            }
        }
        self.onSelectedCategoryChangedClosure?(self.selectedCategory.value)
    }
    
    func getCategoryFilterCellViewModel(at row : Int) -> CategoryFilterCellVmProtocol {
        return self.categoryFilterCellViewModels[row]
    }

}
