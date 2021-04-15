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

}
