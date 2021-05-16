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

// This class is for being used with the singleton "library". (and also for some default images)
class PictureCache {
    
    static let library = PictureCache()
    static var badUrl = UIImage(named: "BadUrl")!
    static var defaultImage = UIImage(named: "DefaultPicture")!
    static var noImage = UIImage(named: "NoPicture")!
    static var brokenImage = UIImage(named: "BrokenPicture")!
    static var downloadError = UIImage(named: "DownloadError")!

    private var pictures = [String : PictureCacheStatus]()
    
    private init(){
        
    }
    
    func get(withApi apiService: ApiServiceProtocol? = nil, atUrlString pictureUrl : String?, updateImage: @escaping (UIImage) -> ()) -> UIImage {

        guard let urlString = pictureUrl else {
            // If no pictureUrl has been provided,
            // then return default image and save nothing.
            return Self.noImage
        }
        
        // We have now a valid picture URL.
// It sometimes crashes here. I guess it is something related to multitasking shared resource access (pictures dictionary).
// I hadn't enought time to investigate the problem so I simply skipped the caching part itself. The PictureCache class still provide images on demand. It simply re-download them everytime.
        // Let's check if it has already been requested before.
//        if let status = pictures[urlString] {
//            // The picture has already been requested before.
//            switch status {
//            case .downloaded(let image):
//                return image
//            case .error:
//                return Self.defaultImage
//            // Pas de cas default: de sorte que si dans le futur je rajoute un cas, je ne puisse pas oublier de le traiter ici.
//            }
//        }
        
        
        // The picture has never been requested before.
        let api = apiService ?? ApiService()
        api.downloadImage(from: urlString) { result in
            switch result {
            case .success(let image) :
                updateImage(image)
            case .wrongImageFormat:
                updateImage(Self.brokenImage)
            case .wrongUrlFormat:
                updateImage(Self.badUrl)
            case .wrongDownload:
                updateImage(Self.downloadError)
            default:
                // All cases for downloadImage have been treated.
                // Something might be improved here since we must detect by ourselves which status can be returned...
                break
            }
        }
        
        return Self.defaultImage
    }
    
}
