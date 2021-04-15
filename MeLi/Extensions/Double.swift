//
//  Double.swift
//  MeLi
//
//  Created by Mario Jaramillo on 14/04/21.
//

import Foundation

extension Double {
    
    
    /**
         Formats the Double number as currency

         - Returns: a String with the given number formatted as currency.
    */
    
    var formattedMoney: String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber) ?? "0"
    }
}
