//
//  SearchResult.swift
//  MeLi
//
//  Created by Mario Jaramillo on 14/04/21.
//

import Foundation

struct SearchResultResponse: Codable {
    
    var query = ""
    var results = [Product]()
    var paging = Paging()
}
