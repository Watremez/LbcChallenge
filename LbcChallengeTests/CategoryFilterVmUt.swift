//
//  CategoryFilterVmUt.swift
//  LbcChallenge_Tests
//
//  Created by Jean-baptiste Watremez on 18/05/2021.
//

import XCTest

@testable import LbcChallenge


class CategoryFilterVmUt: XCTestCase {
    var sut : CategoryFilterVm!
    let categories : [Category] = [
        Category(id: 10, name: "Automobile"),
        Category(id: 20, name: "Immobilier"),
        Category(id: 30, name: "Services")
    ]

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CategoryFilterVm(categoryList: categories)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testFilterAllCategories() throws {
        // Given

        // When
        sut.selectedCategory.value = nil

        // Then
        XCTAssert(sut.getSelectedCategoryIndex() == 0)
        XCTAssert(sut.selectedCategory.value == nil)
    }
    
    func testFilterFirstCategory() throws {
        // Given

        // When
        sut.selectedCategory.value = categories[0]

        // Then
        XCTAssert(sut.getSelectedCategoryIndex() == 1)
        XCTAssert(sut.selectedCategory.value != nil)
        XCTAssert(sut.selectedCategory.value!.id == 10)
    }
    
    func testFilterSecondCategoryByRowIndex() throws {
        // Given

        // When
        sut.selectCategory(at: 2)

        // Then
        XCTAssert(sut.getSelectedCategoryIndex() == 2)
        XCTAssert(sut.selectedCategory.value != nil)
        XCTAssert(sut.selectedCategory.value!.id == 20)
    }
    
    func testFilterAllCategoryByRowIndex() throws {
        // Given

        // When
        sut.selectCategory(at: 0)

        // Then
        XCTAssert(sut.getSelectedCategoryIndex() == 0)
        XCTAssert(sut.selectedCategory.value == nil)
    }

}

