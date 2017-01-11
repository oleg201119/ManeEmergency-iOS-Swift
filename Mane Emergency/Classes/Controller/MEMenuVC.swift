//
//  MEMenuVC.swift
//  Mane Emergency
//
//  Created by Oleg on 8/27/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import SVProgressHUD
import Parse

struct MenuItem {
    static let MyProfile        = "MY PROFILE"
    static let Promotions       = "PROMOTIONS"
    static let Stylist          = "STYLIST"
    static let Following        = "FOLLOWING"
    static let Notifications    = "NOTIFICATIONS"
    static let ManeEmergency    = "MANE EMERGERNCY"
    static let Availability     = "AVAILABILITY"
    static let Pictures         = "PICTURES"
    static let Subscription     = "SUBSCRIPTION"
    static let Logout           = "LOG OUT"
    static let GoHome           = "GO HOME"
}

class MEMenuVC: METableViewController {

    private var menuList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshMenu(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshMenu(_:)), name: APPNOTIFICATION.Login, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: APPNOTIFICATION.Login, object: nil)
    }
    
    func refreshMenu(sender: AnyObject) -> Void {
        menuList.removeAll()
        if let currentUser = MEParseUser.currentUser() {
            menuList.append(MenuItem.MyProfile)
            if currentUser.isStylist == true {
                if currentUser.purchase > 0 && NSDate().timeIntervalSince1970 * 1000 < currentUser.expired_date {
                    menuList.appendContentsOf(
                        [
                            MenuItem.ManeEmergency,
                            MenuItem.Availability
                        ]
                    )
                }
                menuList.appendContentsOf(
                    [
                        MenuItem.Pictures,
                        MenuItem.Promotions,
                        MenuItem.Subscription,
                        MenuItem.Logout
                    ]
                )
            }
            else {
                menuList.appendContentsOf(
                    [
                        MenuItem.Promotions,
                        MenuItem.Stylist,
                        MenuItem.Following,
                        MenuItem.Notifications,
                        MenuItem.Logout
                    ]
                )
            }
        } else {
            menuList.appendContentsOf(
                [
                    MenuItem.Promotions,
                    MenuItem.Stylist,
                    MenuItem.GoHome
                ]
            )
        }
        self.tableView.reloadData()
    }
    
    // MARK - UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < menuList.count - 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(MEMenuCell.cellIdentifier()) as! MEMenuCell
            cell.lblTitle.text = menuList[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(MELogoutCell.cellIdentifier()) as! MELogoutCell
            cell.lblTitle.text = menuList.last
            return cell
        }
    }
    
    // MARK delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == menuList.count - 1 {
            
            if let _ = MEParseUser.currentUser() {
                SVProgressHUD.show()
                MEParseUser.logOutInBackgroundWithBlock({ (error: NSError?) in
                    if error == nil {
                        self.sideMenuController?.performSegueWithIdentifier(APPSEGUE.gotoLogin, sender: self)
                        
                        let installation = PFInstallation.currentInstallation()
                        installation?.removeObjectForKey(FIELDNAME.Installation_userID)
                        installation?.removeObjectForKey(FIELDNAME.Installation_user)
                        installation?.saveInBackground()

                    }
                    SVProgressHUD.dismiss()
                })
            } else {
                appManager().zipcodeForSearch = nil
                sideMenuController?.performSegueWithIdentifier(APPSEGUE.gotoLogin, sender: self)
            }
        } else {
            var segueName: String!
            switch menuList[indexPath.row] {
            case MenuItem.Availability:
                segueName = APPSEGUE.gotoSetAvailabilityVC
                break
            case MenuItem.Following:
                segueName = APPSEGUE.gotoFollowingVC
                break
            case MenuItem.ManeEmergency:
                segueName = APPSEGUE.gotoManeEmergencyVC
                break
            case MenuItem.MyProfile:
                segueName = APPSEGUE.gotoStylistMyProfile
                break
            case MenuItem.Notifications:
                segueName = APPSEGUE.gotoNotificationVC
                break
            case MenuItem.Pictures:
                segueName = APPSEGUE.gotoStylistPictureVC
                break
            case MenuItem.Promotions:
                segueName = APPSEGUE.gotoPromotionVC
                break
            case MenuItem.Stylist:
                segueName = APPSEGUE.gotoSelectStylist
                break
            case MenuItem.Subscription:
                segueName = APPSEGUE.gotoSubscriptionVC
                break
            default:
                segueName = APPSEGUE.gotoPromotionVC
                break
            }
            sideMenuController?.performSegueWithIdentifier(segueName, sender: self)
        }
    }
}
