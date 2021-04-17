//
//  HomeViewController.swift
//  MeLi
//
//  Created by Mario Jaramillo on 4/11/21.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class HomeViewController: UIViewController {

    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var findLabel: UILabel!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var searchTfWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTfCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTfTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: AnimationView! 
    @IBOutlet weak var noResultsLb: UILabel!
    @IBOutlet weak var resultCountLb: UILabel!
    
    private let rxBag = DisposeBag()
    private var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeViewModel.delegate = self
        
        setupUI()
        subscribeRxElements()
        showInitilAnimations()
    }
    
    
    
    //MARK: - Functions
    
    /**
         Initializes the UI elements to the initial state, before any animation occurs
    */
    
    private func setupUI() {
        
        //Register the Product Cell within the tableView so it can be used as a custom cell
        tableView.register(nibName: "ProductCell")
        
        //hide the labels so they can be shown later with an animation
        findLabel.alpha = 0
        searchLabel.alpha = 0
        buyLabel.alpha = 0
        
        noResultsLb.alpha = 0
        resultCountLb.alpha = 0
        
        //Adjusts constraints for the search textfield, so they can be changes later by an animation
        searchTfWidthConstraint.constant = 0
        searchTfCenterYConstraint.priority = UILayoutPriority(1000)
        searchTfTopConstraint.constant = Constants.margins * 2
        searchTfTopConstraint.priority = UILayoutPriority(500)
        
        //setups the lottie animation
        animationView.animation = Animation.named("lottie-loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.alpha = 0
    }
    
    
    /**
         Subscribe UI elements to RX in order to start listening for state changes
    */
    
    private func subscribeRxElements() {
        
        //Listens to taps on the keyboard's search button and calls the search function
        searchTf.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] () in
                
                guard let self = self, let text = self.searchTf.text, !text.isEmpty else { return }
                self.showEndAnimation()
                self.animationView.alpha = 1 //show loading animation
                self.noResultsLb.alpha = 0
                self.homeViewModel.searchProducts(searchText: text)
                
            }).disposed(by: rxBag)
        
        
        //Binds the tableView to the items array, so averytime the array changes, the tableView reloads the cells
        homeViewModel.items.bind(to: tableView.rx.items(cellIdentifier: "ProductCell")) { [weak self] row, model, cell in
            
            guard let self = self, let cell = cell as? ProductCell else { return }
            cell.selectionStyle = .none
            cell.product = model //assign the Product model to the cell, so it can set the cell's UI elements
            
            //Reached the bottom of the table, check if pagination available to show more rows
            if row == self.homeViewModel.items.value.count - 1 {
                
                self.homeViewModel.searchMoreProducts()
            }
                           
        }.disposed(by: rxBag)
        
        
        //Cell selection delegate
        tableView.rx.modelSelected(Product.self)
            .subscribe(onNext: { [weak self] product in
                
                guard let self = self else { return }
                self.goToProductDetails(productId: product.id, productName: product.title)

            }).disposed(by: rxBag)
        
        
        //listens to changes on the product array to show the count label
        _ = homeViewModel.items.asObservable().subscribe(onNext:{
            
            print("new changes to the product array \($0.count)")
            
            DispatchQueue.main.async {
                self.setResultCountLabel()
            }
        })
    }
    
    
    /**
         Sets the text and alpha of the quantity label according to the value of the products array
    */
    
    private func setResultCountLabel() {
        
        resultCountLb.text = homeViewModel.getProductShowingString()
        resultCountLb.alpha = homeViewModel.getProductShowingAlpha()
    }
    
}



//MARK: - Animations

extension HomeViewController {
    
    
    /**
         Chain of animations that are shown once the app loads
    */
    
    private func showInitilAnimations() {
        
        UIView.animate(withDuration: 0.4) {
            
            self.searchLabel.alpha = 1
            
        } completion: { (_) in
            
            UIView.animate(withDuration: 0.4) {
                
                self.findLabel.alpha = 1
                
            } completion: { (_) in
                
                UIView.animate(withDuration: 0.4) {
                    
                    self.buyLabel.alpha = 1
                    
                } completion: { (_) in
                    
                    self.logoImageVerticalConstraint.constant = -120
                    self.searchLabel.alpha = 0
                    self.findLabel.alpha = 0
                    self.buyLabel.alpha = 0
                
                    UIView.animate(withDuration: 0.4) {
                        
                        //self.logoImageView.alpha = 0
                        self.view.layoutIfNeeded()
                        
                    } completion: { (_) in
                        
                        self.searchTfWidthConstraint.constant = 260
                        
                        UIView.animate(withDuration: 0.4) {
                            
                            self.view.layoutIfNeeded()
                            
                        } completion: { (_) in
                            
                            self.searchTf.becomeFirstResponder()
                        }
                    }
                }
            }
        }

    }
    
    
    /**
         Animation that positions the UI elements in the final state after the user makes the first search
    */
    
    private func showEndAnimation() {
        
        searchTfCenterYConstraint.priority = UILayoutPriority(500)
        searchTfTopConstraint.priority = UILayoutPriority(1000)
        
        logoImageVerticalConstraint.priority = UILayoutPriority(500)
        logoTopConstraint.priority = UILayoutPriority(1000)
        logoWidthConstraint.constant = 100
        logoHeightConstraint.constant = 40
        logoTopConstraint.constant = 0
        
        UIView.animate(withDuration: 0.4) {
            
            self.logoImageView.alpha = 1
            self.searchLabel.alpha = 0
            self.findLabel.alpha = 0
            self.buyLabel.alpha = 0
            self.view.backgroundColor = .white
            self.view.layoutIfNeeded()
        }
    }
}




//MARK: - HomeViewModelDelegate methods

extension HomeViewController: HomeViewModelDelegate {
    
    func didFinishSearching(error: Bool) {
        
        DispatchQueue.main.async {
            
            self.animationView.alpha = 0  //hide loading animation after getting the api response
            
            if error {
                
                self.showAlertDefault(title: "ERROR", message: "Lo sentimos, tuvimos un problema con tu búsqueda. Por favor intenta nuevamente")
                
            } else {
                
                self.tableView.alpha = 1
                self.noResultsLb.alpha = self.homeViewModel.areProductsAvailable() ? 0 : 1
            }
        }
    }
    
    func didFinishLoadingMoreProducts(error: Bool) {
        
        
    }
    
}
