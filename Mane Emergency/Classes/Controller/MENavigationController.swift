//
//  MENavigationController.swift
//  Mane Emergency
//
//  Created by Oleg on 8/28/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MENavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : APPCOLOR.Default_YELLOW,
            NSFontAttributeName: UIFont(name: APPFONTNAME.Default500, size: 18)!
        ]
        
        self.navigationBar.barTintColor = APPCOLOR.Default_LIGHT_BLACK
    }

}
