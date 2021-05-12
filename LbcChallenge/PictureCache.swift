//
//  PictureCache.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 12/05/2021.
//

import Foundation
import UIKit


enum PictureDownloadError : Error {
    case pictureUrlNotCorrectlyConstructed
    case receivedImageNotValid
}

enum PictureCacheStatus {
    case downloaded(UIImage)
    case error(PictureDownloadError)
}

class PictureCache {
    
    static let library = PictureCache()
    static var defaultImage = UIImage(named: "DefaultPicture")!

    private var pictures = [String : PictureCacheStatus]()
    
    private init(){
        
    }
    
    func get(_ pictureUrl : String?, updateImage: @escaping (UIImage) -> ()) -> UIImage {

        guard let urlString = pictureUrl else {
            // If no pictureUrl has been provided,
            // then return default image and save nothing.
            return Self.defaultImage
        }
        
        // We have now a valid picture URL.
        // Let's check if it has already been requested before.
        if let status = pictures[urlString] {
            // The picture has already been requested before.
            switch status {
            case .downloaded(let image):
                return image
            case .error:
                return Self.defaultImage
            // Pas de cas default: de sorte que si dans le futur je rajoute un cas, je ne puisse pas oublier de le traiter ici.
            }
        }
        
        
        // The picture has never beel requested before.
        guard let url = URL(string: urlString) else {
            // If urlString wasn't constructed correctly,
            // then save the error and return default image.
            self.pictures[urlString] = .error(.pictureUrlNotCorrectlyConstructed) // No more further try to download this picture.
            return Self.defaultImage
        }
        downloadData(from: url) { pictureData in
            guard let image = UIImage(data: pictureData) else {
                // Image received isn't valid.
                // Save the error and no update.
                self.pictures[urlString] = .error(.receivedImageNotValid) // No more further try to download this picture.
                return
            }
            // Save the valid UIImage and update with it.
            self.pictures[urlString] = .downloaded(image)
            updateImage(image)
        }
        return Self.defaultImage
    }
    
}
