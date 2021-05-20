//
//  UIImageView+Ext.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 20/05/2021.
//

import Foundation
import UIKit


extension UIImageView {
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
}
