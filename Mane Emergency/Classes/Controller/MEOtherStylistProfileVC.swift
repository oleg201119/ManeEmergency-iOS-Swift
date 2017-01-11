//
//  MEOtherStylistProfileVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class MEOtherStylistProfileVC: MEProfileVC, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var btnWriteReview: UIButton!
    @IBOutlet weak var btnAvailability: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.btnFollow.makeRoundView()
        self.btnBook.makeRoundView()
        self.btnWriteReview.makeRoundView()
        self.btnAvailability.makeRoundView()
        
        if self.user.phoneNumber == nil {
            self.buttonEnable(self.btnBook, enable: false)
        }
        
        if MEParseUser.currentUser() == nil{
            
            self.buttonEnable(self.btnFollow, enable: false)
            self.buttonEnable(self.btnWriteReview, enable: false)
            self.buttonEnable(self.btnBook, enable: false)
            
//            self.btnFollow.hidden = true
//            self.btnWriteReview.hidden = true
//            self.btnBook.hidden = true
        } else {
            checkingFollow()
        }
        
    }
    
    @IBAction func onPressFollow(sender: AnyObject) {
        self.buttonEnable(self.btnFollow, enable: false)
        if self.btnFollow.selected {
            let query = MEParseFollow.query()!
            query.whereKey(FIELDNAME.Follow_toUser, equalTo: self.user)
            query.whereKey(FIELDNAME.Follow_fromUser, equalTo: MEParseUser.currentUser()!)
            query.findObjectsInBackgroundWithBlock({ (result: [PFObject]?, error: NSError?) in
                if error == nil {
                    for following in result as! [MEParseFollow] {
                        following.deleteInBackground()
                    }
                    self.btnFollow.selected = false
                    
                } else {
                    
                }
                self.buttonEnable(self.btnFollow)
            })
        } else {
            let following = MEParseFollow()
            following.fromUser = MEParseUser.currentUser()!
            following.toUser = self.user
            following.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                if success {
                    self.btnFollow.selected = true
                }
                self.buttonEnable(self.btnFollow)
            })
        }
    }
    
    @IBAction func onPressBook(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let callAction = UIAlertAction(title: "Call", style: .Default) { (action: UIAlertAction) in
//            if self.user.phoneNumber != nil {
                if let url = NSURL(string: "tel://\(self.user.phoneNumber!)") {
                    UIApplication.sharedApplication().openURL(url)
                }
//            }
        }
        let smsAction = UIAlertAction(title: "Send SMS", style: .Default) { (action: UIAlertAction) in
            if MFMessageComposeViewController.canSendText() {
                let recipents = [self.user.phoneNumber!]
                
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate = self
                messageController.recipients = recipents
                
                self.presentViewController(messageController, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) in
            
        }
        actionSheet.addAction(callAction)
        actionSheet.addAction(smsAction)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    private func checkingFollow() {
        self.buttonEnable(self.btnFollow, enable: false)
        let query = MEParseFollow.query()!
        query.whereKey(FIELDNAME.Follow_toUser, equalTo: self.user)
        query.whereKey(FIELDNAME.Follow_fromUser, equalTo: MEParseUser.currentUser()!)
        query.countObjectsInBackgroundWithBlock { (result: Int32, error: NSError?) in
            self.buttonEnable(self.btnFollow)
            if result > 0 {
                self.btnFollow.selected = true
            }
        }
    }
    
    private func checkRate() {
        
    }
    
    private func buttonEnable(button: UIButton, enable: Bool = true) {
        button.enabled = enable
        if enable {
            button.alpha = 1
        } else {
            button.alpha = 0.5
        }
    }
    
    // MessageComposer delegate
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result {
        case MessageComposeResultCancelled:
            
            break
        case MessageComposeResultSent:
            self.showSimpleAlert("Sent SMS", Message: "SMS has been sent to Stylist successfully.", CloseButton: "OK", Completion: nil)
            break
        case MessageComposeResultFailed:
            self.showSimpleAlert("Failed SMS", Message: nil, CloseButton: "Close", Completion: nil)
            break
        default:
            
            break
        }
        controller.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let rateVC = segue.destinationViewController as? MEWriteReviewVC {
            rateVC.user = self.user
        } else if let availabilityVC = segue.destinationViewController as? MEStylistAvailabilityVC {
            availabilityVC.user = self.user
        }
    }
    

}
