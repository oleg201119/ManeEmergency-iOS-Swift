//
//  MEAppManager.swift
//  Mane Emergency
//
//  Created by Oleg on 8/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import Parse

class MEAppManager: NSObject {

    class var sharedManager: MEAppManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: MEAppManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = MEAppManager()
        }
        return Static.instance!
    }
    
//    var isSearchingZipCode : Bool = false
    var isLoadingFromLogin : Bool = true
    var zipcodeForSearch: String?
    
    func getStarFileName(rate: Float) -> String {
        if rate < 0.5 {
            return "iconStar0"
        } else if 0.5 <= rate && rate < 1.5 {
            return "iconStar1"
        } else if 1.5 <= rate && rate < 2.5 {
            return "iconStar2"
        } else if 2.5 <= rate && rate < 3.5 {
            return "iconStar3"
        } else if 3.5 <= rate && rate < 4.5 {
            return "iconStar4"
        } else {
            return "iconStar5"
        }
    }
    
    func getPriceString(type: Int) -> String {
        switch type {
        case 0:
            return "$100-$150"
        case 1:
            return "$150-$200"
        case 2:
            return "$200+"
        default:
            return "$200+"
        }
    }
    
    func getRateValueOfUser(user: MEParseUser, complete:((CGFloat) -> Void)?) {
        let query = MEParseRating.query()!
        query.whereKey(FIELDNAME.Rating_toUser, equalTo: user)
        query.limit = 200
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
            if error == nil {
                var sum: Float = 0
                for rate in result as! [MEParseRating] {
                    sum += rate.rate
                }
                var rate: CGFloat = 0;
                if result!.count > 0 {
                    rate = CGFloat(sum) / CGFloat(result!.count)
                }
                
                if complete != nil {
                    complete!(rate)
                }
            }
        }
    }
}

let SUBSCRIPTION_INAPP_ID                   = "com.maneemergency.renew.subscription"

struct TABLENAME {
    static let Availability                 = "Availability"
    static let Follow                       = "Follow"
    static let HairStyle                    = "HairStyle"
    static let Notifications                = "Notifications"
    static let Promotions                   = "Promotions"
    static let Rating                       = "Rating"
}

struct FIELDNAME {
    
    static let ObjectId                     = "objecctId"
    static let createdAt                    = "createdAt"
    static let updatedAt                    = "updatedAt"
    
    static let User_rate                    = "rate"
    static let User_purchase                = "purchase"
    static let User_firstName               = "firstName"
    static let User_lastName                = "lastName"
    static let User_expired_date            = "expired_date"
    static let User_bio                     = "bio"
    static let User_price                   = "price"
    static let User_profile                 = "profile"
    static let User_isStylist               = "isStylist"
    static let User_zipCode                 = "zipCode"
    static let User_phoneNumber             = "phoneNumber"
    static let User_availability_date_time  = "availability_date_time"
    
    static let Availability_time            = "time"
    static let Availability_date            = "date"
    static let Availability_userId          = "userId"
    
    static let Follow_toUser                = "toUser"
    static let Follow_fromUser              = "fromUser"
    
    static let HairStyle_userId             = "userId"
    static let HairStyle_photo              = "photo"
    
    static let Notifications_date           = "date"
    static let Notifications_toUser         = "toUser"
    static let Notifications_fromUser       = "fromUser"
    static let Notifications_date_time      = "date_time"
    
    static let Promotitons_userId           = "userId"
    static let Promotitons_photo            = "photo"
    static let Promotitons_description      = "description"
    
    static let Rating_rate                  = "rate"
    static let Rating_toUser                = "toUser"
    static let Rating_fromUser              = "fromUser"
    static let Rating_review                = "review"
    
    static let Installation_user            = "user"
    static let Installation_userID          = "userID"
}

struct APPCOLOR {
    static let Default_YELLOW               = UIColor(rgba: "#be962a")
    static let Default_YELLOW_TRANS         = UIColor(rgba: "#be962a88")
    static let Default_LIGHT_GRAY           = UIColor(rgba: "#cdcdcd")
    static let Default_LIGHT_BLACK          = UIColor(rgba: "#1d1d1d")
    static let Default_BLACK                = UIColor(rgba: "#040404")
    static let TextField_Border             = UIColor(rgba: "#252525")
    static let TextField_Background         = UIColor(rgba: "#090909")
}

struct APPFONTNAME {
    static let Default100                   = "MuseoSansCyrl-100"
    static let Default300                   = "MuseoSansCyrl-300"
    static let Default500                   = "MuseoSansCyrl-500"
    static let Default700                   = "MuseoSansCyrl-700"
    static let Default900                   = "MuseoSansCyrl-900"
}

struct APPSEGUE {
    static let gotoLoginWithStylist     = "gotoLoginWithStylist"
    static let gotoLoginWithCustomer    = "gotoLoginWithCustomer"
    static let gotoSelectStylist        = "gotoSelectStylist"
    static let sideMenu                 = "sideMenu"
    static let gotoLogin                = "gotoLogin"
    static let gotoStylistMyProfile     = "gotoStylistMyProfile"
    static let gotoStylistPictureVC     = "gotoStylistPictureVC"
    static let gotoPromotionVC          = "gotoPromotionVC"
    static let gotoSubscriptionVC       = "gotoSubscriptionVC"
    static let gotoSetAvailabilityVC    = "gotoSetAvailabilityVC"
    static let gotoManeEmergencyVC      = "gotoManeEmergencyVC"
    static let gotoFollowingVC          = "gotoFollowingVC"
    static let gotoNotificationVC       = "gotoNotificationVC"
    static let gotoProfileEditVC        = "gotoProfileEditVC"
    static let gotoProfileVC            = "gotoProfileVC"
    static let gotoRateVC               = "gotoRateVC"
    static let gotoPostPromotionVC      = "gotoPostPromotionVC"
}

struct APPNOTIFICATION {
    static let Login                    = "com.me.notification.login"
    static let UpdateProfile            = "com.me.notification.update.profile"
    static let UpdateReview             = "com.me.notification.update.review"
}

struct PLACEHOLDER {
    static let avatarUser               = UIImage(named: "iconUserAvatar")
    static let hairStyle                = UIImage(named: "iconHairPlaceholder")
}