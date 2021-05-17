//
//  AdCellVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 15/05/2021.
//

import Foundation
import UIKit


protocol AdCellVmProtocol {
    var thumbPicture : Observable<UIImage> { get }
    var category : String { get }
    var title : String { get }
    var price : String { get }
    var urgent : Bool { get }
    var depositDate : String { get }
    
    func cancelObservers()
}

class AdCellVm : AdCellVmProtocol {

    let apiService: ApiServiceProtocol

    private var thumbPictureUrl : String?
    let thumbPicture : Observable<UIImage>
    let category : String
    let title : String
    let price : String
    let urgent : Bool
    let depositDate : String

    
    init(apiService: ApiServiceProtocol = ApiService(), title: String, category: String, price: String, depositeDate: String, urgent: Bool, pictureUrl: String?) {
        self.apiService = apiService
        self.title = title
        self.category = category
        self.price = price
        self.urgent = urgent
        self.depositDate = depositeDate
        self.thumbPictureUrl = pictureUrl
        self.thumbPicture = Observable<UIImage>(initialValue: PictureCache.defaultImage)
        self.thumbPicture.value = PictureCache.library.get(withApi: self.apiService, atUrlString: self.thumbPictureUrl, updateImage: { image in
            self.thumbPicture.value = image
        })
    }
    
    func cancelObservers(){
        thumbPicture.valueChanged = nil
    }

}
