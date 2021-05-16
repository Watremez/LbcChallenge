//
//  Content.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 12/05/2021.
//

import Foundation
import UIKit

class Content {
    static let shared = Content()
    
    var categories = [Category]()
    var ads = [Ad]()
    
    private init() {
    }
    
    func adFor(id : Int) -> Ad? {
        return self.ads.first { oneAd in
            oneAd.id == id
        }
    }
    
    func categoryFor(id: Int) -> Category? {
        return self.categories.first { oneCategory in
            oneCategory.id == id
        }
    }
    
}
