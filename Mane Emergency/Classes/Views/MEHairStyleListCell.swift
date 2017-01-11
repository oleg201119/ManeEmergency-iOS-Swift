//
//  MEHairStyleListCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/12/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import ParseUI

class MEHairStyleListCell: METableViewCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var imageView1: PFImageView!
    
    class func cellIdentifier() -> String {
        return "MEHairStyleListCell"
    }
    
    
}
