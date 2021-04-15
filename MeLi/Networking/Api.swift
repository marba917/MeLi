//
//  Api.swift
//  MeLi
//
//  Created by Mario Jaramillo on 13/04/21.
//

import Foundation

class Api {
    
    
    /**
         Definition of the endpoints used in the networking layer
    */
    
    class Endpoints {
        
        static let HOST = "https://api.mercadolibre.com/sites/MLA/"
        static let search = HOST + "search?q="
    }
    
    
    /**
         Enumerator used to handle the different api responsesi
    */
    
    enum ResponseType {
        
        case ok
        case error
        //TODO: Handle more status codes
    }
    
    
    /**
         Api function in charge of making an api call to the search endpoint, and parsing the results as an array of Products

         - Parameters:
            - searchText: The string query for the search
            - completionBlock: Code block in charge of handling the responses
    */
    
    static func searchProducts(searchText: String, completionBlock: @escaping (ResponseType,[Product]) -> Void) {
        
        let string = searchText.replacingOccurrences(of: " ", with: "+") //replaces spaces for + sign in order to allow multiple keywords
        
        //ensures the URL is correct
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
                let search = try? JSONDecoder().decode(SearchResult.self, from: data) { //maps the data to a SearchResult object
                completionBlock(.ok,search.results)
            }
        }
        
        task.resume()
    }
    
}
