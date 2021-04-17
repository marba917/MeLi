//
//  AttributeView.swift
//  MeLi
//
//  Created by Mario Jaramillo on 17/04/21.
//

import UIKit

class AttributeView: UIView {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var valueLb: UILabel!
    
    var attribute: Attribute? {
        
        didSet {
            
            self.nameLb.text = "\(attribute?.name ?? ""):"
            self.valueLb.text = attribute?.value_name
        }
    }
}
