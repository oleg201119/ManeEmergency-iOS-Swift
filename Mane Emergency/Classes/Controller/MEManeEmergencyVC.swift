//
//  MEManeEmergencyVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/1/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import DatePickerDialog
import Parse
import SVProgressHUD

class MEManeEmergencyVC: MEViewController {

    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnManeEmergency: UIButton!
    
    private var dateFormatter: NSDateFormatter {
        let _dateFormatter = NSDateFormatter()
        _dateFormatter.dateFormat = "MMM.d.yyyy"
        return _dateFormatter
    }
    
    private var timeFormatter: NSDateFormatter {
        let _timeFormatter = NSDateFormatter()
        _timeFormatter.dateFormat = "hh:mm a"
        return _timeFormatter
    }
    
    private var dateTimeFormatter: NSDateFormatter {
        let _dateTimeFormatter = NSDateFormatter()
        _dateTimeFormatter.dateFormat = "MMM.d.yyyy hh:mm a"
        return _dateTimeFormatter

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.btnDate.makeRoundView()
        self.btnTime.makeRoundView()
        self.btnManeEmergency.makeRoundView()
        
        let today = NSDate()
        self.btnDate.setTitle(dateFormatter.stringFromDate(today), forState: .Normal)
        self.btnTime.setTitle(timeFormatter.stringFromDate(today), forState: .Normal)
    }
    
    @IBAction func onPressDate(sender: AnyObject) {
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: NSDate(), minimumDate: NSDate(), maximumDate: nil, datePickerMode: .Date) { (date) in
            if date != nil {
                self.btnDate.setTitle(self.dateFormatter.stringFromDate(date!), forState: .Normal)
            }
        }
    }
    
    @IBAction func onPressTime(sender: AnyObject) {
        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: NSDate(), minimumDate: NSDate(), maximumDate: nil, datePickerMode: .Time) { (date) in
            if date != nil {
                self.btnTime.setTitle(self.timeFormatter.stringFromDate(date!), forState: .Normal)
            }
        }

    }
    
    @IBAction func onPressManeEmergency(sender: AnyObject) {
        if let currentUser = MEParseUser.currentUser() {
            let dateString = self.btnDate.titleLabel!.text! + " " + self.btnTime.titleLabel!.text!
            if let availabilityTime = dateTimeFormatter.dateFromString(dateString) {
                if availabilityTime.timeIntervalSince1970 < NSDate().timeIntervalSince1970 {
                    self.showSimpleAlert("Warning", Message: "Selected Date and Time is behind of now.", CloseButton: "Close", Completion: nil)
                } else {
                    currentUser.availability_date_time = availabilityTime.timeIntervalSince1970 * 1000
                    SVProgressHUD.show()
                    currentUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                        SVProgressHUD.dismiss()
                        if success {
                            self.sendPushNotification()
                        } else {
                            self.showSimpleAlert("Error", Message: error!.localizedDescription, CloseButton: "Close", Completion: nil)
                        }
                    })
                }
            }
            
        }
    }
    
    private func sendPushNotification(startIndex: Int = 0) {
        let currentUser = MEParseUser.currentUser()!
        let query = MEParseFollow.query()!
        query.whereKey(FIELDNAME.Follow_toUser, equalTo: currentUser)
        query.skip = startIndex
        query.limit = 20
        query.includeKey(FIELDNAME.Follow_fromUser)
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
            if error == nil {
                for follower in result as! [MEParseFollow] {
                    self.addNotificationToFollower(follower.fromUser)
                    let params: [String: AnyObject] = [
                        "data" : currentUser.firstName + " " + currentUser.lastName + " CHANGED",
                        "userIdSend" : follower.fromUser.objectId!
                    ]
                    PFCloud.callFunctionInBackground("pushFollow", withParameters: params, block: { (resultForPush: AnyObject?, errorForPush: NSError?) in
                        if errorForPush == nil {
                            print (result)
                        } else {
                            print (errorForPush!.localizedDescription)
                        }
                    })
                }
                if result?.count == query.limit {
                    self.sendPushNotification(query.skip + query.limit)
                }
            } else {
                print (error!.localizedDescription)
            }
        }
    }
    
    private func addNotificationToFollower(user: MEParseUser) {
        
        let notification = MEParseNotifications()
        notification.fromUser = MEParseUser.currentUser()!
        notification.toUser = user
        
        let today = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a MMM.d.yyyy"
        notification.date_time = today.timeIntervalSince1970 * 1000 // miliseconds
        notification.date = dateFormatter.stringFromDate(today)
        notification.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                print ("add notification to table")
            } else {
                print ("error for add notification to table")
            }
        }
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
