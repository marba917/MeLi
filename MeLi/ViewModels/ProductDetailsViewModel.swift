//
//  ProductDetailsViewModel.swift
//  MeLi
//
//  Created by Mario Jaramillo on 17/04/21.
//

import Foundation
import ImageSlideshow

class ProductDetailsViewModel {
    
    var productId: String?
    var productName: String?
    var mediaArray = [InputSource]()
    var delegate: ProductDetailsViewModelDelegate?
    
    
    //MARK: - Functions
    
    /**
         Calls the network helpoer to get the details about specific product
    */
    
    func getProductInfo() {
        
        guard let productId = productId else { return }
        
        NetworkingHelper.getProductDetails(productId: productId) { [weak self] (response, product) in
            
            guard let self = self else { return }
            
            if response  == .ok {
                
                guard let product = product else { return }
                self.delegate?.didFinishLoadingProductInfo(product: product)
                
            } else {
                
                self.delegate?.didFinishLoadingProductInfo(product: nil)
            }
        }
    }
    
    
    func getAvailableStockText(product: Product) -> String {
        
        return "Stock disponible: \(product.available_quantity)"
    }
    
    func getConditionLabelText(product: Product) -> String {
        
        return "\(product.getConditionName()) | \(product.sold_quantity) vendidos"
    }
    
}




//MARK: - ProductDetailsViewModel delegate protocol

protocol ProductDetailsViewModelDelegate {
    
    func didFinishLoadingProductInfo(product: Product?)
}
