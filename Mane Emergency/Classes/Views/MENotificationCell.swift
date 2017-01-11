//
//  MENotificationCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/12/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import ParseUI

class MENotificationCell: METableViewCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    class func cellIdentifer() -> String {
        return "MENotificationCell"
    }
    
    @IBOutlet weak var imgviewUserAvatar: PFImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblNotification: UILabel!
    
    private var _notification: MEParseNotifications!
    
    var notification: MEParseNotifications {
        get {
            return _notification
        }
        set {
            _notification = newValue

            imgviewUserAvatar.image = PLACEHOLDER.avatarUser
            imgviewUserAvatar.file = newValue.fromUser.profile
            imgviewUserAvatar.loadInBackground()
            
            lblUsername.text = newValue.fromUser.firstName + " " + newValue.fromUser.lastName
            
            if newValue.date_time > 0 {
                var timeInterval = newValue.date_time
                if String(timeInterval).characters.count > 10 {
                    timeInterval = timeInterval / 1000
                }
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "h:mm a MMM.d.yyyy"
                self.lblNotification.text = "Availability on " + dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: NSTimeInterval(timeInterval)))
                } else {
                    if newValue.date != nil {
                        self.lblNotification.text = "Availability on " + newValue.date!
                }
            }
        }
    }
    
    func showTopSeparatorLine() -> Void {
        //        self.imgviewTopSeperatorLine.hidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgviewUserAvatar.makeRoundView(radius: self.imgviewUserAvatar.frame.size.width * 0.5)
    }

}
