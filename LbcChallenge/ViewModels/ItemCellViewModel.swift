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
        self.picture = UIImage(named: "DefaultPicture")!
        self.category = category
        self.title = title
        self.price = price
        self.urgent = urgent
        self.delegate = delegate
        
        guard let urlString = pictureUrl,
              let url = URL(string: urlString) else {
            return
        }
        downloadImage(from: url) { pictureData in
            guard let image = UIImage(data: pictureData) else {
                return
            }
            self.picture = image
            if let myDelegate = self.delegate {
                myDelegate.imageReady(imageDownloaded: self.picture)
            }
        }
    }
    
}
