//
//  MEStylistProfileVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/4/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import ParseUI
import HCSStarRatingView

class MEProfileVC: METableViewController {

    @IBOutlet weak var imgviewUserAvatar: PFImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var rateView: HCSStarRatingView!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var lblZipCode: UILabel!
    @IBOutlet weak var clsviewHairStyle: UICollectionView!
    
    private var currentUser: MEParseUser!
    private var hairStyles: [MEParseHairStyle] = []
    
    var user: MEParseUser {
        set {
            currentUser = newValue
        }
        get {
            return currentUser!
        }
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updatedSelfProfile(_:)), name: APPNOTIFICATION.UpdateProfile, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: APPNOTIFICATION.UpdateProfile, object: nil)
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.imgviewUserAvatar.makeRoundView(radius: self.imgviewUserAvatar.frame.size.width * 0.5)

        showProfileInfo(user)
    }
    
    @IBAction func onPressPhoneNumber(sender: AnyObject) -> Void {
//        self.performSegueWithIdentifier(APPSEGUE.gotoStylistPhotoVC, sender: self)
        
    }
    
    func showProfileInfo(profileUser: MEParseUser) -> Void{
        // Avatar
        imgviewUserAvatar.image = PLACEHOLDER.avatarUser
        imgviewUserAvatar.file = profileUser.profile
        imgviewUserAvatar.loadInBackground()
        
        // User Name
        self.lblUsername.text = profileUser.firstName + " " + profileUser.lastName
        
        // Bio
        self.lblBio.text = profileUser.bio
        
        // Phone Number
        if profileUser.phoneNumber != nil {
            self.btnPhone.setTitle("Phone : " + profileUser.phoneNumber!, forState: .Normal)
        }
        
        // Zip Code
        self.lblZipCode.text = profileUser.zipCode
        
        // Rate
        if profileUser.isStylist == true {
            self.rateView.hidden = false
            self.rateView.value = 0
//            self.getRateValue()
            appManager().getRateValueOfUser(profileUser, complete: { (rate: CGFloat) in
                self.rateView.value = rate
            })
        } else {
            self.rateView.hidden = true
        }
        
        getHairStylesOfUser(profileUser)
        
        if let appUser = MEParseUser.currentUser() {
            if profileUser.objectId != appUser.objectId {
                self.navigationItem.rightBarButtonItem = nil
            } else {
                
            }
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    internal func getHairStylesOfUser(user: MEParseUser) {
        let query = MEParseHairStyle.query()!
        query.whereKey(FIELDNAME.HairStyle_userId, equalTo: user)
        query.includeKey(FIELDNAME.HairStyle_userId)
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
            if error == nil {
                self.hairStyles = result as! [MEParseHairStyle]
                self.tableView.reloadData()
                self.clsviewHairStyle.reloadData()
                
            }
        }
    }
    
    internal func getRateValue() {
        let query = MEParseRating.query()!
        query.whereKey(FIELDNAME.Rating_toUser, equalTo: self.user)
        query.limit = 200
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
            if error == nil {
                var sum: Float = 0
                for rate in result as! [MEParseRating] {
                    sum += rate.rate
                }
                self.rateView.value = CGFloat(sum) / CGFloat(result!.count)
//                self.user.rate = Float(self.rateView.value)
//                self.user.saveInBackground()
            }
        }
    }
    
    // MARK: - Notification methods
    func updatedSelfProfile(sender: AnyObject) -> Void {
        
        if let appUser = MEParseUser.currentUser() {
            showProfileInfo(appUser)
        }
    }

    //MARK: - UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if user.isStylist == true && self.hairStyles.count > 0{
                return 1
            } else {
                return 0
            }
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if user.isStylist == true {
                let rows = Int(Float(hairStyles.count) / 3.0 + 0.9)
                return CGFloat(rows) * (tableView.frame.size.width / 3.0) + 5
            } else {
                return 0
            }
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let profileEditVC = segue.destinationViewController as? MEProfileEditVC {
            profileEditVC.user = user
        }
    }
}

extension MEProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hairStyles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MEHairStyleCell.cellIdentifier(), forIndexPath: indexPath) as! MEHairStyleCell
        cell.hairStyle = self.hairStyles[indexPath.row]
        addGestureForFullScreenImage(cell.imgviewPicture)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = collectionView.frame.size
        let unitWidth = screenSize.width / 3 - 1
        let cellSize = CGSizeMake(unitWidth, unitWidth)
        return cellSize
    }

}
