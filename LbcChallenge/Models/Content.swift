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
                self.ads.append(contentsOf: ads.sorted(by: { ad1, ad2 in
                    if ad1.is_urgent == ad2.is_urgent {
                        return ad1.creation_date >= ad2.creation_date
                    } else if ad1.is_urgent {
                        return true
                    } else {
                        return false
                    }
                }))
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
