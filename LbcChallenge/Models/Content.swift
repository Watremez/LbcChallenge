//
//  Content.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 12/05/2021.
//

import Foundation
import UIKit

class Content {
    static let shared = Content(from: "https://raw.githubusercontent.com/leboncoin/paperclip/master/")
    
    var categories = [Category]()
    var ads = [Ad]()
    
    private init(from url : String) {
        Bundle.main.decodeJsonFromUrl([Category].self, from: url + "categories.json") { categories in
            self.categories.append(contentsOf: categories)
            Bundle.main.decodeJsonFromUrl([Ad].self, from: url + "listing.json") { ads in
                self.ads.append(contentsOf: ads)
                Notification.Name.AdsDownloaded.post()                
            }
        }
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
