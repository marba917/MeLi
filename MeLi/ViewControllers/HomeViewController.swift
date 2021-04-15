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
    
    private let rxBag = DisposeBag()
    private var items : BehaviorRelay<[Product]> = BehaviorRelay(value: [])
    private var searchResult: SearchResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        subscribeRxElements()
        showInitilAnimations()
    }
    
    
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
                self.searchProducts(searchText: text)
                
            }).disposed(by: rxBag)
        
        //Binds the tableView to the items array, so averytime the array changes, the tableView reloads the cells
        items.bind(to: tableView.rx.items(cellIdentifier: "ProductCell")) { [weak self] row, model, cell in
            
            guard let self = self, let cell = cell as? ProductCell else { return }
            self.tableView.rowHeight =  120
            cell.selectionStyle = .none
            cell.product = model //assign the Product model to the cell, so it can set the cell's UI elements
            
            //Reached the bottom of the table, check if pagination available to show more rows
            if row == self.items.value.count - 1 {
                
                self.searchMoreResults()
            }
                           
        }.disposed(by: rxBag)
    }
    
    
    /**
         Calls the search API with the entered search string. Handles the completion block and updates the UI accordingly

         - Parameters:
            - searchText: The text query to be searched
    */
    
    private func searchProducts(searchText: String) {
        
        animationView.alpha = 1 //show loading animation
        items.accept([]) //clear previous search results
        
        Api.searchProducts(searchText: searchText) { [weak self] (response, searchResult) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.animationView.alpha = 0  //hide loading animation after getting the api response
            }
            
            switch response {
            
            case .ok:
                
                self.searchResult = searchResult  //saves the searchResult globally in order to allow pagination
                let products = searchResult?.results ?? []
                self.items.accept(products)
                
                DispatchQueue.main.async {
                    self.tableView.alpha = 1
                    self.noResultsLb.alpha = products.isEmpty ? 1 : 0
                }
                
            case .error:
                
                self.showAlertDefault(title: "ERROR", message: "Lo sentimos, tuvimos un problema con tu búsqueda. Por favor intenta nuevamente")
            }
        }
    }
    
    
    /**
         Checks if there are more available results. Calls the search API with the last saved query, and set the offset to the current amount of results. Handles the completion block and updates the UI accordingly
    */
    
    private func searchMoreResults() {
        
        //Checks if the product count is lesser than the total amount of results for the query
        guard let currentSearchResult = self.searchResult, items.value.count < currentSearchResult.paging.total else { return }
        
        Api.searchProducts(searchText: currentSearchResult.query, offset: items.value.count) { [weak self] (response, searchResult) in
            
            guard let self = self else { return }
            
            switch response {
            
            case .ok:
                
                var products = self.items.value
                products.append(contentsOf: searchResult?.results ?? []) //merge current products with the new results
                self.items.accept(products)
                
            case .error:
                
                print("Error loading more results...")
            }
        }
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
                    
                    UIView.animate(withDuration: 0.4) {
                        
                        self.logoImageView.alpha = 0
                        
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




//MARK: - Scrolling

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("scrolling")
    }
}
