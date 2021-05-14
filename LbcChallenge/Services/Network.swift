//
//  Network.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation
import UIKit


func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}


func downloadData(from url: URL, completion: @escaping (Data) -> ()) {
    getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return }

        completion(data)
    }
}



