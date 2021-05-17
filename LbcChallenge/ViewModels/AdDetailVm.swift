//
//  AdDetailVm.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 16/05/2021.
//

import Foundation
import UIKit

protocol AdDetailVmProtocol {
    var thumbPicture : Observable<UIImage> { get }
    var smallPicture : Observable<UIImage> { get }
    var category : String { get }
    var title : String { get }
    var price : String { get }
    var urgent : Bool { get }
    var depositDate : String { get }
    var description : String { get }
    
    func cancelObservers()
}

class AdDetailVm : AdDetailVmProtocol {

    let apiService: ApiServiceProtocol

    private var thumbPictureUrl : String?
    private var smallPictureUrl : String?
    let thumbPicture : Observable<UIImage>
    let smallPicture : Observable<UIImage>
    let category : String
    let title : String
    let price : String
    let urgent : Bool
    let depositDate : String
    let description : String

    
    init(apiService: ApiServiceProtocol = ApiService(), title: String, category: String, price: String, depositeDate: String, urgent: Bool, description: String, thumbPictureUrl: String?, smallPictureUrl: String?) {
        self.apiService = apiService
        self.title = title
        self.category = category
        self.price = price
        self.urgent = urgent
        self.depositDate = depositeDate
        self.description = description
        self.thumbPictureUrl = thumbPictureUrl
        self.thumbPicture = Observable<UIImage>(initialValue: PictureCache.defaultImage)
        self.smallPictureUrl = smallPictureUrl
        self.smallPicture = Observable<UIImage>(initialValue: PictureCache.defaultImage)
        self.thumbPicture.value = PictureCache.library.get(withApi: self.apiService, atUrlString: self.thumbPictureUrl, updateImage: { image in
            self.thumbPicture.value = image
        })
        self.smallPicture.value = PictureCache.library.get(withApi: self.apiService, atUrlString: self.smallPictureUrl, updateImage: { image in
            self.smallPicture.value = image
        })
    }
    
    func cancelObservers(){
        thumbPicture.valueChanged = nil
        smallPicture.valueChanged = nil
    }

}
