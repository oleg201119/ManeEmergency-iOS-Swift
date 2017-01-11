//
//  MEWriteReviewVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import ParseUI
import KMPlaceholderTextView
import SVProgressHUD
import HCSStarRatingView

class MEWriteReviewVC: METableViewController {

    @IBOutlet weak var imgviewUserAvatar: PFImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtReview: KMPlaceholderTextView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    private var _user: MEParseUser!
    var user: MEParseUser {
        set {
            _user = newValue
        }
        get {
            return _user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkRate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.imgviewUserAvatar.makeRoundView(radius: self.imgviewUserAvatar.frame.size.width * 0.5)
        self.txtReview.makeRoundView()
        self.txtReview.layer.borderColor = APPCOLOR.Default_LIGHT_BLACK.CGColor
        self.txtReview.layer.borderWidth = 1
        
        
        self.lblUsername.text = self.user.firstName + " " + self.user.lastName
        
        self.imgviewUserAvatar.file = self.user.profile
        self.imgviewUserAvatar.loadInBackground()
    }

    private func checkRate() {
        SVProgressHUD.show()
        let query = MEParseRating.query()!
        query.whereKey(FIELDNAME.Rating_toUser, equalTo: self.user)
        query.whereKey(FIELDNAME.Rating_fromUser, equalTo: MEParseUser.currentUser()!)
        query.getFirstObjectInBackgroundWithBlock { (result: PFObject?, error: NSError?) in
            if let rate = result as? MEParseRating {
                self.txtReview.text = rate.review
                // TODO: rate star
                self.ratingView.value = CGFloat(rate.rate)
                
                self.ratingView.userInteractionEnabled = false
                self.txtReview.editable = false
                self.navigationItem.rightBarButtonItem = nil
            }
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func onPressSendReview(sender: AnyObject) {
        if self.ratingView.value == 0 || self.txtReview.text.characters.count == 0 {
            self.showSimpleAlert("Warning", Message: "Please write rate and review.", CloseButton: "OK", Completion: nil)
        } else {
            let rate = MEParseRating()
            rate.fromUser = MEParseUser.currentUser()!
            rate.toUser = self.user
            rate.rate = Float(self.ratingView.value)
            rate.review = self.txtReview.text
            
            SVProgressHUD.show()
            rate.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                if success {
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    self.showSimpleAlert("Error", Message: error!.localizedDescription, CloseButton: "OK", Completion: nil)
                }
                SVProgressHUD.dismiss()
            })
        }
    }
    
    @IBAction func onPressRate(sender: AnyObject) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
