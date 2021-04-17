//
//  UIView.swift
//  MeLi
//
//  Created by Mario Jaramillo on 4/13/21.
//

import UIKit

extension UIView {
    
    func hideKeyboard () {
        endEditing(true)
    }
    
    public class func fromNib(nibName: String?, withOwner owner: Any? = nil) -> Self {
        return fromNibHelper(nibName: nibName, withOwner: owner)
    }
    
    public class func fromNib(withOwner owner: Any? = nil) -> Self {
        return fromNib(nibName: nil, withOwner: owner)
    }
    
    public class func fromNibHelper<T>(nibName: String?, withOwner owner: Any? = nil) -> T where T : UIView {
        let bundle = Bundle(for: T.self)
        let name = nibName ?? String(describing: T.self)
        return bundle.loadNibNamed(name, owner: owner, options: nil)?.first as? T ?? T()
    }
}

