//
//  UIButton+ME.swift
//  Mane Emergency
//
//  Created by Oleg on 9/1/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

extension UIButton {
    func setEnable(enable: Bool = true) -> Void {
        enabled = enable
        if enable == true {
            alpha = 1
        } else {
            alpha = 0.5
        }
    }
}
