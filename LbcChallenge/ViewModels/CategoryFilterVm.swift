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

    func selectCategory(at row: Int)
    func getSelectedCategoryIndex() -> Int
}

class CategoryFilterVm : CategoryFilterVmProtocol {

    private let apiService: ApiServiceProtocol
    private var categories : [Category]
    private(set) var choices : Observable<[String]>
    private(set) var selectedCategory : Observable<Category?>

    init(apiService: ApiServiceProtocol = ApiService(), categoryList : [Category]) {
        self.apiService = apiService
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
            self.selectedCategory.value = nil
        } else {
            self.selectedCategory.value = self.categories[row-1]
        }
        Notification.Name.SelectedCategory.post(object: self.selectedCategory.value)
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

}
