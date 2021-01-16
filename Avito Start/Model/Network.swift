//
//  Network.swift
//  avito1
//
//  Created by Mikhail Sergeev on 15.01.2021.
//

import Foundation

struct Network {
    
    // MARK: - Structure Methods
    static func loadImageFrom(address: SpecialService, completionHandler: @escaping (Data?) -> ()) {
        if let address = address.icon.values.first, let url = URL(string: address) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("Cannot download image, error: \(error.localizedDescription), url: \(url.absoluteString)")
                    completionHandler(nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil)
                    return
                }
                
                completionHandler(data)
            }.resume()
        }
    }
}
