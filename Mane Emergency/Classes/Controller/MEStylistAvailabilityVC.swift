//
//  MEStylistAvailabilityVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import FSCalendar
import Parse
import SVProgressHUD

class MEStylistAvailabilityVC: METableViewController {

    @IBOutlet weak var viewCalendarBox: UIView!
    @IBOutlet weak var lblDate: UILabel!
    weak var viewCalendar: MEAvailabilityCalendarView!
    @IBOutlet weak var fsCalendar: FSCalendar!
    
    private var _user: MEParseUser!
    var user: MEParseUser {
        set {
            _user = newValue
        }
        get {
            return _user
        }
    }

    private var _events: [String: [MEParseAvailability]] = [:]
    private var _availabilityTimes: [MEParseAvailability] = []
    private var _availabilityTimesForSelectedDate: [MEParseAvailability] = []
    private var _selectedDate: NSDate?
    
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
        fsCalendar.makeRoundView()
        fsCalendar.appearance.titleFont = UIFont(name: APPFONTNAME.Default700, size: 22)
        fsCalendar.appearance.weekdayFont = UIFont(name: APPFONTNAME.Default500, size: 18)
        fsCalendar.appearance.weekdayTextColor = APPCOLOR.Default_YELLOW
        fsCalendar.appearance.headerTitleFont = UIFont(name: APPFONTNAME.Default700, size: 22)
        fsCalendar.appearance.cellShape = .Rectangle
        
        self.getAvailability()
    }
    
    private func getAvailability() {
        SVProgressHUD.show()
        let query = MEParseAvailability.query()
        query?.whereKey(FIELDNAME.Availability_userId, equalTo: self.user)
        query?.limit = 100
        query?.cachePolicy = .NetworkElseCache
        query?.findObjectsInBackgroundWithBlock({ (result: [PFObject]?, error: NSError?) in
            if error == nil {
                self._availabilityTimes = result as! [MEParseAvailability]
                /*
                 for event in result as! [MEParseAvailability] {
                 var array = event[event.date!] as? [MEParseAvailability]
                 if array == nil {
                 array = []
                 }
                 array!.append(event)
                 event[event.date!] = array
                 } */
                
            } else {
                
            }
            self.fsCalendar.reloadData()
            SVProgressHUD.dismiss()
        })

    }
    
    // MARK: - UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _availabilityTimesForSelectedDate.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MEAvailabilityTimeCell.cellIndentifier()) as! MEAvailabilityTimeCell
        cell.date = _availabilityTimesForSelectedDate[indexPath.row]
        return cell
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

extension MEStylistAvailabilityVC: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        print(date)
        self._availabilityTimesForSelectedDate.removeAll()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM.d.yyyy"
        let dateKey = dateFormatter.stringFromDate(date)

        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = "MMM.d.yyyy"
        self.lblDate.text = dateFormatter.stringFromDate(date)
        //        view.showRedCorner()
        
        
        self._availabilityTimes.forEach { (time: MEParseAvailability) in
            if time.date == dateKey {
                self._availabilityTimesForSelectedDate.append(time)
            }
        }
        self.tableView.reloadData()

    }
    
    func calendar(calendar: FSCalendar, didDeselectDate date: NSDate) {
        
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM.d.yyyy"
        let dateKey = dateFormatter.stringFromDate(date)
        var value : Bool = false
        self._availabilityTimes.forEach { (time: MEParseAvailability) in
            if time.date == dateKey {
                value = true
                return
            }
        }
        return value == true ? 1 : 0
    }
    
}

extension MEStylistAvailabilityVC: FSCalendarDelegateAppearance {
    
    
}