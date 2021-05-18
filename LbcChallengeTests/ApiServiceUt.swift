//
//  ApiServiceUt.swift
//  LbcChallengeTests
//
//  Created by Jean-baptiste Watremez on 18/05/2021.
//

import XCTest


@testable import LbcChallenge


class ApiServiceUt: XCTestCase {
    var sut : ApiService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ApiService()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testGetDecodedDataFromUrl() throws {
        // Given
        let baseUrl : String = "https://raw.githubusercontent.com/leboncoin/paperclip/master/"
        let file : String = "categories.json"
        
        let promise = expectation(description: "Completion handler invoked")
        var status : ApiStatus<[Category]>?
        
        
        // When
        sut.getDecodedDataFromUrl([Category].self, from: baseUrl + file) { (result : ApiStatus<[Category]>) in
            status = result
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssert((status != nil))
    }
    
    func testDownloadImage() throws {
        // Given
        let imageUrl : String = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png"
        
        let promise = expectation(description: "Completion handler invoked")
        var status : ApiStatus<UIImage>?
        
        
        // When
        sut.downloadImage(from: imageUrl) { result in
            status = result
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssert((status != nil))
        if case let .success(img) = status! {
            print(img)
        } else {
            print(status!)
        }
    }

}
