//
//  MEStylistCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/12/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import ParseUI
import HCSStarRatingView

class MEStylistCell: METableViewCell {

    class func cellIdentifer() -> String {
        return "MEStylistCell"
    }
    
    @IBOutlet weak var imgviewUserAvatar: PFImageView!
    @IBOutlet weak var lblUsername: UILabel!
//    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
//    @IBOutlet weak var imgviewRateStar: UIImageView!
    @IBOutlet weak var imgviewTopSeperatorLine: UIImageView!
    @IBOutlet weak var rateView: HCSStarRatingView!
    
    private var _stylist: MEParseUser!
    
    var stylist: MEParseUser {
        set {
            _stylist = newValue
            self.imgviewTopSeperatorLine.hidden = true
            imgviewUserAvatar.image = PLACEHOLDER.avatarUser
            imgviewUserAvatar.file = newValue.profile
            imgviewUserAvatar.loadInBackground()
            
            lblUsername.text = newValue.firstName + " " + newValue.lastName
            
            lblPrice.text = MEAppManager.sharedManager.getPriceString(newValue.price)
            
//            let starFileName = MEAppManager.sharedManager.getStarFileName(newValue.rate)
//            imgviewRateStar.image = UIImage(named: starFileName)
            self.rateView.value = CGFloat(newValue.rate)
        }
        get {
            return _stylist
        }
    }
    
    func showTopSeparatorLine() -> Void {
        self.imgviewTopSeperatorLine.hidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgviewUserAvatar.makeRoundView(radius: self.imgviewUserAvatar.frame.size.width * 0.5)
        
    }
    
}
