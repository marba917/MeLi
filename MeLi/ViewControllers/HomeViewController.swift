//
//  HomeViewController.swift
//  MeLi
//
//  Created by Mario Jaramillo on 4/11/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var findLabel: UILabel!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var buyLabel: UILabel!
    @IBOutlet weak var searchTfWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageVerticalConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showInitilAnimations()
    }
    
    private func setupUI() {
        
        findLabel.alpha = 0
        searchLabel.alpha = 0
        buyLabel.alpha = 0
        searchTfWidthConstraint.constant = 0
    }
    
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
    

}
