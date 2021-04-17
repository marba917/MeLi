//
//  ProductDetailsViewController.swift
//  MeLi
//
//  Created by Mario Jaramillo on 16/04/21.
//

import UIKit
import ImageSlideshow
import Kingfisher
import Lottie

class ProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var productNameLb: UILabel!
    @IBOutlet weak var imageRotator: ImageSlideshow!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var conditionLb: UILabel!
    @IBOutlet weak var mainVerticalSv: UIStackView!
    @IBOutlet weak var stockLb: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    var productId: String?
    var productName: String?
    private var fullscreenImage = FullScreenSlideshowViewController()
    private var mediaArray = [InputSource]()
    private var pageIndicator = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getProductInfo()
    }
    

    //MARK: - IBActions
    
    @IBAction func backBtnCTA(_ sender: Any) {
        
        back()
    }
    
    
    //MARK: - Functions
    
    /**
         Initializes the UI elements to the initial state,
    */
    
    private func setupUI() {
        
        productNameLb.text = productName ?? ""
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapImage))
        imageRotator.addGestureRecognizer(gestureRecognizer)
        imageRotator.contentScaleMode = .scaleAspectFit
        
        pageIndicator.currentPageIndicatorTintColor = .darkGray
        pageIndicator.pageIndicatorTintColor = .lightGray
        imageRotator.pageIndicator = pageIndicator
        imageRotator.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .under)
        
        //fullscreenImage.slideshow.pageIndicator?.view.alpha = 0
        fullscreenImage.closeButton.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        fullscreenImage.closeButton.layer.cornerRadius = 20
        
        //setups the lottie animation
        animationView.animation = Animation.named("lottie-loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
    
    
    @objc private func didTapImage() {
        
        fullscreenImage.initialPage = 0
        self.present(fullscreenImage, animated: true, completion: nil)
    }
    
    
    /**
         Calls the network helpoer to get the details about specific product
    */
    
    private func getProductInfo() {
        
        guard let productId = productId else { return }
        
        NetworkingHelper.getProductDetails(productId: productId) { [weak self] (response, product) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.animationView.alpha = 0
            }
            
            if response  == .ok {
                
                guard let product = product else { return }
                
                DispatchQueue.main.async {
                    self.setProductInfo(product: product)
                }
                
            } else {
                
                self.showAlertDefault(title: "Error", message: "Tuvimos un problema cargando la información del producto. Por favor intenta nuevamente.")
            }
        }
    }
    
    
    /**
         Updates the UI with the information from the product object
    */
    
    private func setProductInfo(product: Product) {
        
        priceLb.text = product.price.formattedMoney
        conditionLb.text = "\(product.getCondition()) | \(product.sold_quantity) vendidos"
        stockLb.text = "Stock disponible: \(product.available_quantity)"
        
        product.attributes?.forEach({ (attribute) in

            let attView = AttributeView.fromNib()
            attView.frame.size = CGSize(width: self.view.frame.width, height: 50)
            attView.attribute = attribute
            self.mainVerticalSv.addArrangedSubview(attView)
        })
        
        guard let pictures = product.pictures else { return }
        
        for picture in pictures {
            
            if let source = KingfisherSource(urlString: picture.url) {
                mediaArray.append(source)
            }
        }
        
        imageRotator.setImageInputs(mediaArray)
        fullscreenImage.inputs = mediaArray
    }
    

}
