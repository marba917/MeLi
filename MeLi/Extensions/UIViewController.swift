//
//  UIView.swift
//  MeLi
//
//  Created by Mario Jaramillo on 4/13/21.
//

import UIKit

extension UIViewController {
    
    func getBottomUnsafeAreaHeight() -> CGFloat {
        
        var bottomSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
            return bottomSafeAreaHeight
        }
        
        var bottomSafeArea: CGFloat
        
        if #available(iOS 11.0, *) {
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            bottomSafeArea = bottomLayoutGuide.length
        }
        
        return bottomSafeArea
    }
    
    func getTopUnsafeAreaHeight() -> CGFloat {
        
        var topSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            topSafeAreaHeight = safeFrame.minY
            return topSafeAreaHeight
        }
        
        var topSafeArea: CGFloat
        
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
        } else {
            topSafeArea = topLayoutGuide.length
        }
        
        return topSafeArea
    }

}
