//
//  UITextField+ME.swift
//  Mane Emergency
//
//  Created by Oleg on 9/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

extension UITextField {
    func addLeftPadding(padding : CGFloat = 10.0) -> Void {
        let viewLeftPadding : UIView = UIView(frame: CGRect.init(x: 0, y: 0, width: padding, height: (frame.size.height)))
        leftViewMode = .Always
        leftView = viewLeftPadding
    }
    
    func addRightView(view: UIView) -> Void {
        rightViewMode = .Always
        rightView = view
    }

}
