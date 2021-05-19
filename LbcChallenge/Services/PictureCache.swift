//
//  PictureCache.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 12/05/2021.
//

import Foundation
import UIKit


enum PictureCacheStatus {
    case downloaded(UIImage)
    case error // Defined as it is right now, "error" is not really necessary. Could be upgraded to embed another enum that would describe the specific error so when we'll try to get this same image again, we will be able to decide if we try another download or if we stop trying... depending on the previous error we got.
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
    private let concurrentQueue : DispatchQueue = DispatchQueue(label: "com.jbw.LbcChallenge.concurrentQueue", attributes: .concurrent)

    private init(){
        
    }
    
    func get(withApi apiService: ApiServiceProtocol? = nil, atUrlString pictureUrl : String?, updateImage: @escaping (UIImage) -> ()) {

        guard let urlString = pictureUrl else {
            // If no pictureUrl has been provided,
            // then return default noImage and save nothing.
            updateImage(Self.noImage)
            return 
        }
        
        // We have now a picture url (supposedly a valid one until now).
        // Let's check if it has already been requested before.
        var st : PictureCacheStatus? = nil
        concurrentQueue.sync(flags: .barrier) {[weak self] in
            guard let self = self else { return }
            st = self.pictures[urlString]
        }
        if let status = st {
            // The picture has already been requested before.
            if case .downloaded(let previouslyDownloadedImage) = status {
                // The previous download was successful.
                updateImage(previouslyDownloadedImage)
                return
            }
        }
        
        
        // The picture has never been requested before.
        // or
        // The previous picture download failed.
        // Anyway, let's try to download this image (maybe again).
        let api = apiService ?? ApiService()
        api.downloadImage(from: urlString) { downloadImageResult in
            var res : PictureCacheStatus = .error
            switch downloadImageResult {
            case .success(let successfullyDownloadedImage) :
                res = .downloaded(successfullyDownloadedImage)
                updateImage(successfullyDownloadedImage)
            case .wrongImageFormat:
                updateImage(Self.brokenImage)
            case .wrongUrlFormat:
                updateImage(Self.badUrl)
            case .wrongDownload:
                updateImage(Self.downloadError)
            default:
                // All cases for downloadImage have been treated.
                // Something might be improved here since we must detect by ourselves which status can be returned...
                updateImage(Self.defaultImage)
            }
            self.concurrentQueue.sync(flags: .barrier) {[weak self] in
                guard let self = self else { return }
                self.pictures[urlString] = res
            }
        }
    }
    
}
