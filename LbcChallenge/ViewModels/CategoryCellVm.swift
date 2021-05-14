//
//  CategoryCellVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 14/05/2021.
//

import Foundation
import UIKit


class CategoryCellVm {
    var name : String
    var activated : Bool
    
    init(name:  String, activated : Bool) {
        self.name = name
        self.activated = activated
    }
}
