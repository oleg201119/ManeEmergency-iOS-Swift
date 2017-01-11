//
//  MEHairStyleCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/16/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import ParseUI

class MEHairStyleCell: MECollectionViewCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var imgviewPicture: PFImageView!
    
    private var _hairStyle: MEParseHairStyle!
    
    var hairStyle: MEParseHairStyle {
        set {
            _hairStyle = newValue
            imgviewPicture.image = PLACEHOLDER.hairStyle
            imgviewPicture.file = newValue.photo
            imgviewPicture.loadInBackground()
        }
        get {
            return _hairStyle
        }
    }
    
    class func cellIdentifier() -> String {
        return "MEHairStyleCell"
    }

}
