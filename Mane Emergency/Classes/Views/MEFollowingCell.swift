//
//  MEFollowingCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/12/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import ParseUI
import HCSStarRatingView

class MEFollowingCell: METableViewCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    class func cellIdentifer() -> String {
        return "MEFollowingCell"
    }
    
    @IBOutlet weak var imgviewUserAvatar: PFImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
//    @IBOutlet weak var imgviewRateStar: UIImageView!
//    @IBOutlet weak var imgviewTopSeperatorLine: UIImageView!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var rateView: HCSStarRatingView!

    var delegate: MEFollowingCellDelegate?
    
    private var _user: MEParseUser!
    
    var followingUser: MEParseUser {
        get {
            return _user
        }
        set {
            _user = newValue
//            self.imgviewTopSeperatorLine.hidden = true
            imgviewUserAvatar.image = PLACEHOLDER.avatarUser
            imgviewUserAvatar.file = newValue.profile
            imgviewUserAvatar.loadInBackground()
            
            lblUsername.text = newValue.firstName + " " + newValue.lastName
            
            lblPrice.text = MEAppManager.sharedManager.getPriceString(newValue.price)
            
//            let starFileName = MEAppManager.sharedManager.getStarFileName(newValue.rate)
//            imgviewRateStar.image = UIImage(named: starFileName)
            self.btnFollow.selected = true

            self.rateView.value = CGFloat(newValue.rate)
        }
    }
    
    func showTopSeparatorLine() -> Void {
//        self.imgviewTopSeperatorLine.hidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgviewUserAvatar.makeRoundView(radius: self.imgviewUserAvatar.frame.size.width * 0.5)
        self.btnFollow.makeRoundView()
    }
    
    @IBAction func onPressFollowing(sender: AnyObject) {
        self.btnFollow.selected = !self.btnFollow.selected
        self.delegate?.followingCellPressFollow(self)
    }
}

protocol MEFollowingCellDelegate {
    func followingCellPressFollow(cell: MEFollowingCell) -> Void
}
