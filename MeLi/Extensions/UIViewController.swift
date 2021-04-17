//
//  UIViewController.swift
//  MeLi
//
//  Created by Mario Jaramillo on 4/13/21.
//

import UIKit

extension UIViewController {
    
    /**
         Calculates the height of the unsafe are at the bottom of the screen

         - Returns: The unsafe height as a CGFloat
    */
    
    func getBottomUnsafeAreaHeight() -> CGFloat {
        
        var bottomSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
            return bottomSafeAreaHeight
        } else {
            return bottomLayoutGuide.length
        }
    }
    
    
    /**
         Calculates the height of the unsafe are at the top of the screen

         - Returns: The unsafe height as a CGFloat
    */
    
    func getTopUnsafeAreaHeight() -> CGFloat {
        
        var topSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            topSafeAreaHeight = safeFrame.minY
            return topSafeAreaHeight
        } else {
            return topLayoutGuide.length
        }
    }
    
    
    /**
         Shows an alert with the default OS design
    */
    
    func showAlertDefault (title: String?, message: String) {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message:  message, preferredStyle: .alert)
            alertController.view.tintColor = .black
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    
    /**
         Allows you to obtain a view controller instance

         - Parameters:
            - from: The name of the Storyboard where the VC's UI is located
            - id: VC's storyboard ID
    */
    
    func getVC (from: String, withId id: String) -> UIViewController {
        
        return UIStoryboard(name: from, bundle: nil).instantiateViewController(withIdentifier: id)
    }

}
