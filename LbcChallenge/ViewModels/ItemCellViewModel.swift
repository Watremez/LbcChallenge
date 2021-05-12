//
//  ItemCellViewModel.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation
import UIKit

protocol ItemCellViewModelProtocolDelegate : class {
    func imageReady(imageDownloaded : UIImage)
}

class ItemCellViewModel {
    
    var picture : UIImage
    var category : ItemCategory
    var title : String
    var price : Double
    var urgent : Bool
    
    weak var delegate : ItemCellViewModelProtocolDelegate? = nil
    
    init(pictureUrl : String?, category : ItemCategory, title : String, price : Double, urgent : Bool = false, delegate : ItemCellViewModelProtocolDelegate) {
        self.picture = PictureCache.defaultImage
        self.category = category
        self.title = title
        self.price = price
        self.urgent = urgent
        self.delegate = delegate
        
        self.picture = PictureCache.library.get(pictureUrl, updateImage: { imageDownloaded in
            if let myDelegate = self.delegate {
                myDelegate.imageReady(imageDownloaded: imageDownloaded)
            }
        })
    }
    
}
