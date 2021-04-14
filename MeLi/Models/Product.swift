//
//  Product.swift
//  MeLi
//
//  Created by Mario Jaramillo on 13/04/21.
//

import Foundation

//struct Product {
//
//    var id = ""
//    var title = ""
//    var price = 0.0
//
//    init(withDictionary dictionary: NSDictionary) {
//
//        id = dictionary["id"] as? String ?? ""
//        title = dictionary["title"] as? String ?? ""
//        price = dictionary["price"] as? Double ?? 0.0
//    }
//}

struct Product: Codable {
    
    var id = ""
    var title = ""
    var price = 0.0
    var currency_id = ""
    var available_quantity = 0
    var thumbnail = ""
}
