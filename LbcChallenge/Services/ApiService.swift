//
//  Network.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation
import UIKit




enum ApiStatus<T> {
    case wrongUrlFormat(String)
    case wrongDownload
    case wrongJsonDecoding(String)
    case wrongImageFormat
    case success(T)
}

protocol ApiServiceProtocol {
    func getDecodedDataFromUrl<T : Decodable>(_ type : T.Type, from urlString : String, completion: @escaping (_ result : ApiStatus<T>) -> ())
    func downloadImage(from urlString: String, completion: @escaping(_ result : ApiStatus<UIImage>) -> ())
}










class ApiService: ApiServiceProtocol {
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    private enum DownloadStatus {
        case success(Data)
        case error // On pourrait donner plus de détail dans ce cas ou ajouter des cases dans cet énum... Je manque de temps.
    }
    private func downloadData(from url: URL, completion: @escaping (DownloadStatus) -> ()) {
        getData(from: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                response != nil,
                let statusCode = (response as? HTTPURLResponse)?.statusCode,
                statusCode == 200
            else {
                completion(.error)
                return
            }
            // Idéalement, il faudrait aussi contrôler la réponse (qui doit être 200) dans le guard ci-dessus.
            completion(.success(data))
        }
    }

    func getDecodedDataFromUrl<T : Decodable>(_ type : T.Type, from urlString : String, completion: @escaping (_ result : ApiStatus<T>) -> ()) {
        DispatchQueue.global().async {
            guard let url = URL(string: urlString) else {
                completion(.wrongUrlFormat(urlString))
                return
            }
            
            self.downloadData(from: url) { downloadStatus in
                switch downloadStatus {
                case .error:
                    completion(.wrongDownload)
                case .success(let data):
                    let decoder = JSONDecoder()
                    do {
                        let loaded = try decoder.decode(T.self, from: data)
                        completion(.success(loaded))
                    } catch {
                        completion(.wrongJsonDecoding(error.localizedDescription))
                        return
                    }
                }
            }
        }
    }
       
    func downloadImage(from urlString: String, completion: @escaping(_ result : ApiStatus<UIImage>) -> ()){
        DispatchQueue.global().async {
            guard let url = URL(string: urlString) else {
                completion(.wrongUrlFormat(urlString))
                return
            }
            
            self.downloadData(from: url) { downloadStatus in
                switch downloadStatus {
                case .error:
                    completion(.wrongDownload)
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        completion(.wrongImageFormat)
                        return
                    }
                    completion(.success(image))
                }
            }
        }
    }

}




