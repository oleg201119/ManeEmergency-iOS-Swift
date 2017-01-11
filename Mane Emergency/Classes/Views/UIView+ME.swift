//
//  UIView+UMO.swift
//  UMO
//
//  Created by Oleg on 9/10/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeRoundView() -> Void {
        self.makeRoundView(radius: 5.0)
    }
    
    func makeRoundView(radius r : CGFloat) -> Void {
        self.layer.cornerRadius = r
        self.clipsToBounds = true
    }
    
    func makeBorder(color: UIColor, borderWidth: CGFloat = 1) -> Void {
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = borderWidth
    }
}