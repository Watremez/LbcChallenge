//
//  Helper.swift
//  LbcChallenge
//
//  Created by Jean-baptiste Watremez on 11/05/2021.
//

import Foundation


extension Bundle {
    
    func decodeJsonFile<T : Decodable>(_ type : T.Type, from file : String) -> T {
        guard let fileUrl = Bundle.main.url(forResource: file, withExtension: "json") else {
            fatalError("Failed to locate \(file + ".json") in bundle.")
        }
        if FileManager.default.fileExists(atPath: fileUrl.path) == false {
            fatalError("File \(fileUrl.absoluteString) doesn't exists in Bundle.")
        }
        guard let data = try? Data(contentsOf: fileUrl) else {
            fatalError("Failed to load \(fileUrl.absoluteString).")
        }

        let decoder = JSONDecoder()

        var loaded : T
        do {
            loaded = try decoder.decode(T.self, from: data)
            return loaded
        } catch {
            fatalError(error.localizedDescription)
        }

        return loaded
    }

    
    func encodeToJsonFile<T : Encodable>(_ codables : T, into file : String) {
        do {
            let fileUrlForSaving = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(file + ".json")
            
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            do {
                let jsonData = try encoder.encode(codables)

                try jsonData.write(to: fileUrlForSaving)
                
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
