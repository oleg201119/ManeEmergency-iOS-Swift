//
//  MEFollowingVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import Parse

class MEFollowingVC: METableViewController, MEFollowingCellDelegate {

    
    private var followings: [MEParseFollow] = []
    private var doingRequest: Array<Bool> = Array()
    private var followingUser: Array<Bool> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getFollowing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getFollowing() {
        if self.isLoading == false {
            self.isLoading = true
            let query = MEParseFollow.query()!
            query.whereKey(FIELDNAME.Follow_fromUser, equalTo: MEParseUser.currentUser()!)
            query.limit = 100
            query.includeKey(FIELDNAME.Follow_toUser)
            query.cachePolicy = .NetworkElseCache
            query.findObjectsInBackgroundWithBlock({ (result: [PFObject]?, error: NSError?) in
                self.isLoading = false
                if error == nil {
                    self.followings = result as! [MEParseFollow]
                    self.doingRequest = Array(count: result!.count, repeatedValue: false)
                    self.followingUser = Array(count: result!.count, repeatedValue: true)
                }
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK - UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading == true {
            return followings.count + 1
        } else if self.isLoading == false && followings.count == 0 {
            return 1
        } else {
            return followings.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.isLoading == true {
            let cell = tableView.dequeueReusableCellWithIdentifier(MELoadingCell.cellIdentifier()) as! MELoadingCell
            cell.showLoading()
            return cell
        } else if self.isLoading == false && followings.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(MELoadingCell.cellIdentifier()) as! MELoadingCell
            cell.showLoading(false, emptyMessage: "No Following")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(MEFollowingCell.cellIdentifer()) as! MEFollowingCell

            cell.followingUser = followings[indexPath.row].toUser
            cell.delegate = self
            cell.btnFollow.enabled = !doingRequest[indexPath.row]
//            if doingRequest[indexPath.row] == true {
//                cell.btnFollow.alpha = 0.5
//            } else {
//                cell.btnFollow.alpha = 1
//            }
            cell.btnFollow.selected = followingUser[indexPath.row]
            return cell
        }

    }
    
    // MARK delegate
    
    func followingCellPressFollow(cell: MEFollowingCell) {
        let index = tableView.indexPathForCell(cell)!.row
        if doingRequest[index] == false {
            
            doingRequest[index] = true
//            cell.btnFollow.alpha = 0.5
            cell.btnFollow.enabled = false
            
            if cell.btnFollow.selected {
                let following = MEParseFollow()
                following.fromUser = MEParseUser.currentUser()!
                following.toUser = cell.followingUser
                following.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                    if success {
                        self.followingUser[index] = true
                    } else {
                        self.followingUser[index] = false
                        cell.btnFollow.selected = false
                    }
                    self.doingRequest[index] = false
//                    cell.btnFollow.alpha = 1
                    cell.btnFollow.enabled = true
                    self.followings[index] = following
                })
            }
            else {
                let following = followings[index]
                following.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                    if success {
                        self.followingUser[index] = false
                    } else {
                        self.followingUser[index] = true
                        cell.btnFollow.selected = true
                    }
                    self.doingRequest[index] = false
//                    cell.btnFollow.alpha = 1
                    cell.btnFollow.enabled = true
                })
            }
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let profileVC = segue.destinationViewController as? MEOtherStylistProfileVC {
            let cell = sender as! MEFollowingCell
            profileVC.user = cell.followingUser
        }
    }
    

}
