//
//  HomeViewController.swift
//  MeLi
//
//  Created by Mario Jaramillo on 4/11/21.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    private let rxBag = DisposeBag()
    private var items : BehaviorRelay<[Product]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        subscribeRxElements()
        showInitilAnimations()
    }
    
    private func setupUI() {
        
        tableView.register(nibName: "ProductCell")
        
        findLabel.alpha = 0
        searchLabel.alpha = 0
        buyLabel.alpha = 0
        searchTfWidthConstraint.constant = 0
        
        searchTfCenterYConstraint.priority = UILayoutPriority(1000)
        searchTfTopConstraint.constant = Constants.margins * 2
        searchTfTopConstraint.priority = UILayoutPriority(500)
    }
    
    private func subscribeRxElements() {
        
        searchTf.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] () in
                
                guard let self = self, let text = self.searchTf.text, !text.isEmpty else { return }
                self.showEndAnimation()
                self.searchProducts(searchText: text)
                
            }).disposed(by: rxBag)
        
        items.bind(to: tableView.rx.items(cellIdentifier: "ProductCell")) { [weak self] row, model, cell in
            
            guard let self = self, let cell = cell as? ProductCell else { return }
            self.tableView.rowHeight =  120
            cell.selectionStyle = .none
            cell.product = model
                           
        }.disposed(by: rxBag)
    }
    
    private func searchProducts(searchText: String) {
        
        Api.searchProducts(searchText: searchText) { (response, products) in
            
            switch response {
            
            case .ok:
                print("ok")
                self.items.accept(products)
                self.tableView.alpha = 1
            case .error:
                print("error")
            }
        }
    }
}



//MARK: - Animations

extension HomeViewController {
    
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
