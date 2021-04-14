//
//  ProductCell.swift
//  MeLi
//
//  Created by Mario Jaramillo on 14/04/21.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    
    var product = Product() {
        
        didSet {
            
            nameLabel.text = product.title
            priceLabel.text = "\(product.price.formattedMoney) \(product.currency_id)"
            let shipping = product.shipping.free_shipping ? "Gratis" : "a cargo del comprador"
            shippingLabel.text = "Envío \(shipping)"
            shippingLabel.textColor = product.shipping.free_shipping ? .systemGreen : .systemRed
            
            let urlPic = URL(string: product.thumbnail)
            thumbnail.kf.indicatorType = .activity
            (thumbnail.kf.indicator?.view as? UIActivityIndicatorView)?.color = .darkGray
            thumbnail.kf.setImage(with: urlPic, placeholder: nil)
        }
    }
}
