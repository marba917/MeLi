//
//  Double.swift
//  MeLi
//
//  Created by Mario Jaramillo on 14/04/21.
//

import Foundation

extension Double {
    
    var formattedMoney: String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber) ?? "0"
    }
}
