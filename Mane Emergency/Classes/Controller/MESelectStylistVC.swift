//
//  MESelectStylistVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MESelectStylistVC: METableViewController {

    
    private var stylists: [MEParseUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.addSideMenuButton()
        if appManager().zipcodeForSearch != nil && MEParseUser.currentUser() == nil {
            /// Search stylist with Zip code
            searchStylistWithZipcode(appManager().zipcodeForSearch!)
            appManager().zipcodeForSearch = nil
        } else {
            self.getStylist()
        }
    }
    
    private func getStylist() {
        if isLoading == false {
            isLoading = true
//            SVProgressHUD.show()
            let query = MEParseUser.query()!
            query.whereKey(FIELDNAME.User_isStylist, equalTo: true)
            query.limit = 100
            query.cachePolicy = .NetworkElseCache
            query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
                self.isLoading = false
                
                if error == nil {
                    self.stylists = result as! [MEParseUser]
                    
                } else {
                    
                }
                self.tableView.reloadData()
//                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func searchStylist(price: Int?, date: String?, fromTime: NSTimeInterval?, toTime: NSTimeInterval?, rate: Float?, zipcode: String?) {
        if zipcode == nil {
            
            if isLoading == false {
                
                isLoading = true
                
                let query = MEParseUser.query()!
                query.whereKey(FIELDNAME.User_price, equalTo: price!)
                query.whereKey(FIELDNAME.User_rate, greaterThanOrEqualTo: rate!)
                query.whereKey(FIELDNAME.User_isStylist, equalTo: true)
                query.whereKey(FIELDNAME.User_availability_date_time, greaterThanOrEqualTo: fromTime!)
                query.whereKey(FIELDNAME.User_availability_date_time, lessThanOrEqualTo: toTime!)
                
                SVProgressHUD.show()
                query.findObjectsInBackgroundWithBlock({ (result: [PFObject]?, error: NSError?) in
                    self.isLoading = false
                    
                    if error == nil {
                        self.stylists = result as! [MEParseUser]
                        self.searchStylistWithPrice(price!, date: date!, fromTime: fromTime!, toTime: toTime!, rate: rate!)
                    }
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                })
            }
            
            self.stylists.removeAll()

        } else {
            self.searchStylistWithZipcode(zipcode!)
        }
    }
    
    private func searchStylistWithPrice(price: Int, date: String, fromTime: NSTimeInterval, toTime: NSTimeInterval, rate: Float) {
        if isLoading == false {
            isLoading = true
            
            
            let query = MEParseAvailability.query()!
            query.includeKey(FIELDNAME.Availability_userId)
            query.whereKey(FIELDNAME.Availability_time, greaterThanOrEqualTo: fromTime)
            query.whereKey(FIELDNAME.Availability_time, lessThanOrEqualTo: toTime)
            query.whereKey(FIELDNAME.Availability_date, equalTo: date)
            
            query.findObjectsInBackgroundWithBlock({ (result: [PFObject]?, error: NSError?) in
                if error == nil {
                    for availability in result as! [MEParseAvailability] {
                        let user = availability.userId
                        var existUser = false
                        for eUser in self.stylists {
                            if user.objectId == eUser.objectId {
                                existUser = true
                                break
                            }
                        }
                        if existUser == false {
                            if user.rate > rate && user.price == price && user.isStylist == true {
                                self.stylists.append(user)
                            }
                        }
                    }
                }
                self.isLoading = false
                self.tableView.reloadData()
            })
        }
    }

    
    private func searchStylistWithZipcode(zipCode: String) {
        if isLoading == false {
            isLoading = true
            SVProgressHUD.show()
            let query = MEParseUser.query()!
            query.whereKey(FIELDNAME.User_isStylist, equalTo: true)
            query.whereKey(FIELDNAME.User_zipCode, equalTo: zipCode)
            query.limit = 100
            query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
                
                self.isLoading = false
                
                if error == nil {
                    self.stylists = result as! [MEParseUser]
                    
                } else {
                    
                }
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
        
    }

    // MARK: - UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading == true {
            return stylists.count + 1
        } else if self.isLoading == false && stylists.count == 0 {
            return 1
        } else {
            return stylists.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.isLoading == true {
            let cell = tableView.dequeueReusableCellWithIdentifier(MELoadingCell.cellIdentifier()) as! MELoadingCell
            cell.showLoading()
            return cell
        } else if self.isLoading == false && stylists.count == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(MELoadingCell.cellIdentifier()) as! MELoadingCell
            cell.showLoading(false, emptyMessage: "No Stylist")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(MEStylistCell.cellIdentifer()) as! MEStylistCell
            cell.stylist = stylists[indexPath.row]
            if indexPath.row == 0 {
                cell.showTopSeparatorLine()
            }
            return cell
        }
    }
    // MARK: delegate
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let stylistProfileVC = segue.destinationViewController as? MEOtherStylistProfileVC {
            let cell = sender as! MEStylistCell
            stylistProfileVC.user = cell.stylist
        } else if let searchOptionVC = segue.destinationViewController as? MESearchOptionVC {
            searchOptionVC.delegate = self
        }
    }
}

extension MESelectStylistVC: MESearchOptionVCDelegate {
    func searchStylist(price: Int, date: String, fromTime: NSTimeInterval, toTime: NSTimeInterval, rate: Float) {
        searchStylist(price, date: date, fromTime: fromTime, toTime: toTime, rate: rate, zipcode: nil)
    }
}