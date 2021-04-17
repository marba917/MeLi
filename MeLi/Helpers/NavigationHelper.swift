//
//  NavigationHelper.swift
//  MeLi
//
//  Created by Mario Jaramillo on 16/04/21.
//

import UIKit

extension UIViewController {
    
    
    
    func dismiss() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func back() {
        
        guard let nav = navigationController else {
            self.dismiss()
            return
        }
        nav.popViewController(animated: true)
    }
    
    
    /**
         Allows you to navigate to the product details view

         - Parameters:
            - productId: The product id of the desired product to display
            - productName: The name to display
    */
    
    func goToProductDetails(productId: String, productName: String) {
        
        let vc = getVC(from: "ProductDetails", withId: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.productDetailsViewModel.productId = productId
        vc.productDetailsViewModel.productName = productName
        show(vc, sender: self)
    }
    
}

