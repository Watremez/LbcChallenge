//
//  CategoryListVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 16/05/2021.
//

import Foundation

protocol CategoryFilterVmProtocol : AnyObject {
    var categories : Observable<[Category]> { get }
    var selectedCategory : Observable<Category?> { get }

    func selectCategory(at row: Int)
}

class CategoryFilterVm : CategoryFilterVmProtocol {

    private let apiService: ApiServiceProtocol
    private(set) var categories : Observable<[Category]>
    private(set) var selectedCategory : Observable<Category?>

    init(apiService: ApiServiceProtocol = ApiService(), categoryList : [Category]) {
        self.apiService = apiService
        self.categories = Observable<[Category]>(initialValue: [])
        self.selectedCategory = Observable<Category?>(initialValue: nil)
        self.processFetchedCategories(downloadedCategories: categoryList)
    }
    
    private func processFetchedCategories(downloadedCategories: [Category]) {
        self.categories.value = downloadedCategories
    }
    
    func selectCategory(at row: Int){
        if row == 0 {
            self.selectedCategory.value = nil
        } else {
            self.selectedCategory.value = self.categories.value[row-1]
        }
        Notification.Name.SelectedCategory.post(object: self.selectedCategory.value)
    }
}
