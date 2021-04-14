//
//  Api.swift
//  MeLi
//
//  Created by Mario Jaramillo on 13/04/21.
//

import Foundation

class Api {
    
    class Endpoints {
        
        static let HOST = "https://api.mercadolibre.com/sites/MLA/"
        static let search = HOST + "search?q="
    }
    
    enum ResponseType {
        
        case ok
        case error
    }
    
    
    
    static func searchProducts(searchText: String, completionBlock: @escaping (ResponseType,[Product]) -> Void) {
        
        let string = searchText.replacingOccurrences(of: " ", with: "+")
        
        guard let url = URL(string: "\(Endpoints.search)\(string)") else {
            
            completionBlock(.error,[])
            return
        }
        print("Searching products for: \(searchText) URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error searching for products: \(error)")
                completionBlock(.error,[])
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code")
                completionBlock(.error,[])
                return
            }
            
            //TODO: Handle other status codes

            if let data = data,
                let search = try? JSONDecoder().decode(SearchResult.self, from: data) {
                completionBlock(.ok,search.results)
            }
        }
        
        task.resume()
    }
    
}
