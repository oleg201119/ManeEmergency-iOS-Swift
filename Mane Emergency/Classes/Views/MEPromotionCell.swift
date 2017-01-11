//
//  MEPromotionCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/14/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import ParseUI


class MEPromotionCell: METableViewCell {

    class func cellIdentifier() -> String {
        return "MEPromotionCell"
    }
    
    @IBOutlet weak var imgviewUserAvatar: PFImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgviewPromotion: PFImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    private var _promotion: MEParsePromotions!
    var promotion: MEParsePromotions {
        set {
            _promotion = newValue
            imgviewPromotion.image = nil
            imgviewPromotion.file = newValue.photo
            imgviewPromotion.loadInBackground()
            
            lblUsername.text = newValue.userId.firstName + " " + newValue.userId.lastName
            
            imgviewUserAvatar.image = PLACEHOLDER.avatarUser
            imgviewUserAvatar.file = newValue.userId.profile
            imgviewUserAvatar.loadInBackground()

            lblDescription.text = newValue.objectForKey(FIELDNAME.Promotitons_description) as? String
            
            if newValue.createdAt != nil {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                self.lblTime.text = dateFormatter.stringFromDate(newValue.createdAt!)
            } else {
                self.lblTime.text = nil
            }
        }
        get {
            return _promotion
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgviewUserAvatar.makeRoundView(radius: self.imgviewUserAvatar.frame.size.width * 0.5)
    }
}
