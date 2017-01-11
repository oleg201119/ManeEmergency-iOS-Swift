//
//  MENotificationVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import Parse

class MENotificationVC: METableViewController {

    private var notifications: [MEParseNotifications] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getNotification()
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getNotification() {
        if self.isLoading == false {
            self.isLoading = true
            let query = MEParseNotifications.query()!
            query.whereKey(FIELDNAME.Notifications_toUser, equalTo: MEParseUser.currentUser()!)
            query.includeKey(FIELDNAME.Notifications_fromUser)
            query.orderByDescending(FIELDNAME.createdAt)
            query.limit = 50
            query.cachePolicy = .NetworkElseCache
            query.findObjectsInBackgroundWithBlock({ (result: [PFObject]?, error: NSError?) in
                self.isLoading = false
                if error == nil {
                    self.notifications = result as! [MEParseNotifications]
                }
                self.tableView.reloadData()
            })
        }
    }

    // MARK - UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading == true {
            return notifications.count + 1
        } else if self.isLoading == false && notifications.count == 0 {
            return 1
        } else {
            return notifications.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.isLoading == true {
            let cell = tableView.dequeueReusableCellWithIdentifier(MELoadingCell.cellIdentifier()) as! MELoadingCell
            cell.showLoading()
            return cell
        } else if self.isLoading == false && notifications.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(MELoadingCell.cellIdentifier()) as! MELoadingCell
            cell.showLoading(false, emptyMessage: "No Notifications")
            return cell
        }  else {
            let cell = tableView.dequeueReusableCellWithIdentifier(MENotificationCell.cellIdentifer()) as! MENotificationCell
            
            cell.notification = notifications[indexPath.row]
            
            return cell
        }
    }
    
    // MARK delegate

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let profileVC = segue.destinationViewController as? MEOtherStylistProfileVC {
            let cell = sender as! MENotificationCell
            profileVC.user = cell.notification.fromUser
        }
    }
    

}
