//
//  ItemCellViewModel.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation
import UIKit

protocol ItemCellViewModelProtocolDelegate : AnyObject {
    func imageReady(imageDownloaded : UIImage)
}

class ItemCellViewModel {
    
    var picture : UIImage
    var category : Category?
    var title : String
    var price : String
    var urgent : Bool
    var depositDate : String
    
    weak var delegate : ItemCellViewModelProtocolDelegate? = nil
    
    init(pictureUrl : String?, category : Category?, title : String, price : Double, urgent : Bool = false, depositDate : Date, delegate : ItemCellViewModelProtocolDelegate) {
        let locale = Locale(identifier: "fr-FR")
        
        self.picture = PictureCache.defaultImage
        self.category = category
        self.title = title
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "EUR"
        numberFormatter.locale = locale
        self.price = numberFormatter.string(from: NSNumber(value: price)) ?? "n/a"
        
        self.urgent = urgent

        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        self.depositDate = dateFormatter.string(from: depositDate)
        
        self.delegate = delegate

        self.picture = PictureCache.library.get(pictureUrl, updateImage: { imageDownloaded in
            if let myDelegate = self.delegate {
                DispatchQueue.main.async {
                    myDelegate.imageReady(imageDownloaded: imageDownloaded)
                }
            }
        })
    }
    
}
