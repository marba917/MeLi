//
//  UITableView.swift
//  MeLi
//
//  Created by Mario Jaramillo on 4/13/21.
//

import UIKit

extension UITableView {

    
    /**
         Registers a custom cell on the tableView

         - Parameters:
            - nibName: The name of the custom cell
    */
    
    func register(nibName: String) {
        
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}
