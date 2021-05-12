//
//  Helper.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation


enum DecodeJsonError {
    case wrongUrlFormat
}

extension Bundle {
    
    func decodeJsonFromUrl<T : Decodable>(_ type : T.Type, from urlString : String, completion: @escaping (T) -> ()) {
        guard let url = URL(string: urlString) else {
            fatalError(String("\(DecodeJsonError.wrongUrlFormat) for \(urlString)"))
        }
        
        downloadData(from: url) { data in
            let decoder = JSONDecoder()

            var loaded : T
            do {
                loaded = try decoder.decode(T.self, from: data)
                completion(loaded)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

}
