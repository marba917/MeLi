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
    
    var productDetailsViewModel = ProductDetailsViewModel()
    private var fullscreenImage = FullScreenSlideshowViewController()
    private var pageIndicator = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        productDetailsViewModel.delegate = self
        
        setupUI()
        productDetailsViewModel.getProductInfo()
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
        
        productNameLb.text = productDetailsViewModel.productName ?? ""
        
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
        
        animationView.alpha = 1 //shows the loading animation when the view is loaded
        mainVerticalSv.alpha = 0 
    }
    
    
    /**
         Shows the image in full screen mode
    */
    
    @objc private func didTapImage() {
        
        fullscreenImage.initialPage = 0
        self.present(fullscreenImage, animated: true, completion: nil)
    }
    
    
    
    /**
         Updates the UI with the information from the product object
    */
    
    private func setProductInfo(product: Product) {
        
        self.mainVerticalSv.alpha = 1
        priceLb.text = product.price.formattedMoney
        conditionLb.text = "\(product.getCondition()) | \(product.sold_quantity) vendidos"
        stockLb.text = "Stock disponible: \(product.available_quantity)"
        
        //adds subviews with the attributes information
        product.attributes?.forEach({ (attribute) in

            let attView = AttributeView.fromNib()
            attView.frame.size = CGSize(width: self.view.frame.width, height: 50)
            attView.attribute = attribute
            self.mainVerticalSv.addArrangedSubview(attView)
        })
        
        
        //if the product has images, adds them to the image rotator
        guard let pictures = product.pictures else { return }
        
        for picture in pictures {
            
            if let source = KingfisherSource(urlString: picture.url) {
                productDetailsViewModel.mediaArray.append(source)
            }
        }
        
        imageRotator.setImageInputs(productDetailsViewModel.mediaArray)
        fullscreenImage.inputs = productDetailsViewModel.mediaArray
    }
    

}



//MARK: - ProductDetailsViewModelDelegate methods

extension ProductDetailsViewController: ProductDetailsViewModelDelegate {
    
    func didFinishLoadingProductInfo(product: Product?) {
        
        DispatchQueue.main.async {
            
            self.animationView.alpha = 0
            
            guard let product = product else {
                
                self.showAlertDefault(title: "Error", message: "Tuvimos un problema cargando la información del producto. Por favor intenta nuevamente.")
                self.mainVerticalSv.alpha = 0
                return
            }
            
            self.setProductInfo(product: product)
        }
    }
    
}
