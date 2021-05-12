//
//  Category.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 12/05/2021.
//

import Foundation
import UIKit

class Category : Codable {
    private enum CodingKeys : String, CodingKey {
        case id = "id" // dans swift = dans json
        case name = "name"
    }
    
    var id : Int
    var name : String

    required init(from decoder : Decoder)throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    init(id: Int, name : String) {
        self.id = id
        self.name = name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
    }
    
}
