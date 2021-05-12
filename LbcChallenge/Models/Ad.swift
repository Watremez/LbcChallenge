//
//  Item.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation
import UIKit

class Ad : Codable {
    private enum CodingKeys : String, CodingKey {
        case id = "id" // dans swift = dans json
        case category_id = "category_id"
        case title = "title"
        case description = "description"
        case price = "price"
        case images_url = "images_url"
        case creation_date = "creation_date"
        case is_urgent = "is_urgent"
    }
    
    var id : Int
    var category_id : Int
    var title : String
    var description : String
    var price : Double
    var images_url : ImageUrls
    var creation_date : Date
    var is_urgent : Bool
    
    var category : Category? {
        Content.shared.categoryFor(id: self.category_id)
    }

    required init(from decoder : Decoder)throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.category_id = try container.decode(Int.self, forKey: .category_id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.price = try container.decode(Double.self, forKey: .price)
        self.images_url = try container.decode(ImageUrls.self, forKey: .images_url)

        let someStringDateTime = try container.decode(String.self, forKey: .creation_date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.creation_date = formatter.date(from: someStringDateTime) ?? Date()
        
        self.is_urgent = try container.decode(Bool.self, forKey: .is_urgent)
    }
    
    init(id: Int, category_id : Int, title : String, description : String, price : Double, images_url : ImageUrls, creation_date : Date, is_urgent : Bool) {
        self.id = id
        self.category_id = category_id
        self.title = title
        self.description = description
        self.price = price
        self.images_url = images_url
        self.creation_date = creation_date
        self.is_urgent = is_urgent
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.category_id, forKey: .category_id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.price, forKey: .price)
        try container.encode(self.images_url, forKey: .images_url)
        try container.encode(self.creation_date, forKey: .creation_date)
        try container.encode(self.is_urgent, forKey: .is_urgent)
    }
    
}
