//
//  ImageUrls.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation
import UIKit

class ImageUrls : Codable {
    private enum CodingKeys : String, CodingKey {
        case small = "small" // dans swift = dans json
        case thumb = "thumb"
    }
    
    var small : String?
    var thumb : String?
    
    required init(from decoder : Decoder)throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.small) {
            self.small = try container.decode(String.self, forKey: .small)
        } else {
            self.small = nil
        }
        if container.contains(.thumb) {
            self.thumb = try container.decode(String.self, forKey: .thumb)
        } else {
            self.thumb = nil
        }
    }
    
    init(small : String?, thumb : String?) {
        self.small = small
        self.thumb = thumb
    }
    
}
