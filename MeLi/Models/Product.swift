//
//  Product.swift
//  MeLi
//
//  Created by Mario Jaramillo on 13/04/21.
//

import Foundation

struct Product: Codable {
    
    var id = ""
    var title = ""
    var price = 0.0
    var currency_id = ""
    var available_quantity = 0
    var thumbnail = ""
    var shipping = Shipping()
    var pictures: [Picture]? = nil
    var sold_quantity = 0
    var condition = ""
    var attributes: [Attribute]? = nil
    
    func getConditionName() -> String {
        
        return condition == "new" ? "Nuevo" : "Usado"
    }
}
