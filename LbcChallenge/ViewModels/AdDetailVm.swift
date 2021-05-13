//
//  AdDetailVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 13/05/2021.
//

import Foundation
import UIKit


class AdDetailVm {
    
    var picture : UIImage
    var category : Category?
    var title : String
    var price : String
    var urgent : Bool
    var depositDate : String
    var description : String
    var navBarHeight : Int?
    var empty : Bool
    
    
    weak var oneViewThatUsesThisViewModel : AsynchronousImageDisplayer? = nil
    
    private init(){
        self.picture = PictureCache.defaultImage
        self.category = nil
        self.title = ""
        self.price = ""
        self.urgent = false
        self.empty = true
        self.depositDate = ""
        self.description = ""
        self.oneViewThatUsesThisViewModel = nil
    }
    static let empty = AdDetailVm()
    
    init(pictureUrl : String?, category : Category?, title : String, price : Double, urgent : Bool, depositDate : Date, description : String, viewThatUsesThisViewModel : AsynchronousImageDisplayer) {
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
        self.empty = false

        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        self.depositDate = dateFormatter.string(from: depositDate)
        
        self.description = description
        
        self.oneViewThatUsesThisViewModel = viewThatUsesThisViewModel

        self.picture = PictureCache.library.get(pictureUrl, updateImage: { imageDownloaded in
            if let myDelegate = self.oneViewThatUsesThisViewModel {
                DispatchQueue.main.async {
                    myDelegate.imageReady(imageDownloaded: imageDownloaded)
                }
            }
        })
    }
    
}
