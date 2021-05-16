//
//  CategoryListVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 16/05/2021.
//

import Foundation

class CategoryListVm {

    private let apiService: ApiServiceProtocol
    var categories : Observable<[Category]>

    init(apiService: ApiServiceProtocol = ApiService(), categoryList : [Category]) {
        self.apiService = apiService
        self.categories = Observable<[Category]>(initialValue: [])
        self.processFetchedCategories(downloadedCategories: categoryList)
    }
    
    func processFetchedCategories(downloadedCategories: [Category]) {
        self.categories.value = downloadedCategories
    }
}
