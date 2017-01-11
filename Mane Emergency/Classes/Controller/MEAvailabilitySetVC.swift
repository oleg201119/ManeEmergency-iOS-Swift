//
//  MEAvailabilitySetVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/1/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD
import DatePickerDialog


class MEAvailabilitySetVC: METableViewController, MEAvailabilityCalendarViewDelegate, MEAvailabilityCalendarViewDataSource, MEAvailabilityTimeCellDelegate {

    @IBOutlet weak var viewCalendarBox: UIView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnAddTime: UIButton!
    @IBOutlet weak var indicatorAddTime: UIActivityIndicatorView!
    
    weak var viewCalendar: MEAvailabilityCalendarView?
    private var _events: [String: [MEParseAvailability]] = [:]
    private var _availabilityTimes: [MEParseAvailability] = []
    private var _selectedDate: NSDate?
    private var _selectedDateView: MEAvailabilityCalendarDayView?
    private var _availabilityTimesForSelectedDate: [MEParseAvailability] = []
    
    private var dateKeyFormatter: NSDateFormatter {
        let _dateFormatter = NSDateFormatter()
        _dateFormatter.dateFormat = "MMM.d.yyyy"
        return _dateFormatter
    }

    
    // MARK: -
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
//        self.navigationController?.addSideMenuButton()
        self.btnAddTime.makeRoundView()
        
        getEvents()
    }
    
    private func getEvents() {
        
        SVProgressHUD.show()
        let query = MEParseAvailability.query()
        query?.whereKey(FIELDNAME.Availability_userId, equalTo: MEParseUser.currentUser()!)
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
            self.reloadAvailability()
            SVProgressHUD.dismiss()
        })
    }
    
    private func reloadAvailability() {
        
        self.lblDate.text = nil
        if self.viewCalendar != nil {
            self.viewCalendar?.removeFromSuperview()
            self.viewCalendar = nil
        }
        
        let calendarView = MEAvailabilityCalendarView.instanceFromNib()
        calendarView.delegate = self
        calendarView.dataSource = self
        self.viewCalendarBox.addSubview(calendarView)
        calendarView.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.height.equalTo(160)
        }
        viewCalendar = calendarView
        
        showDate()

        _selectedDate = nil
        _selectedDateView = nil
        self.loadAvailabilityTimes(_selectedDate)
    }

    private func showDate() {
        
        let today = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.firstWeekday = 1
        var startOfWeek: NSDate?
        var endOfWeek: NSDate
        var interval: NSTimeInterval = 0
        calendar.rangeOfUnit(.WeekOfYear, startDate: &startOfWeek, interval: &interval, forDate: today)
        endOfWeek = startOfWeek!.dateByAddingTimeInterval(interval * 2 - 1)
        viewCalendar!.setDuration(startOfWeek!, lastDate: endOfWeek)
        
    }
    
    
    // MARK: - MEAvailabilityCalendarView delegate
    func availabilityCalendayView(view: MEAvailabilityCalendarDayView, selectedDate: NSDate) {
        
        _selectedDate = selectedDate
        _selectedDateView = view
        loadAvailabilityTimes(selectedDate)
    }
    
    private func loadAvailabilityTimes(date: NSDate?) {
        self._availabilityTimesForSelectedDate.removeAll()

        if date != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM.d.yyyy"
            self.lblDate.text = dateFormatter.stringFromDate(date!)
            //        view.showRedCorner()
            
            let dateKey = dateKeyFormatter.stringFromDate(date!)
            
            self._availabilityTimes.forEach { (time: MEParseAvailability) in
                if time.date == dateKey {
                    self._availabilityTimesForSelectedDate.append(time)
                }
            }
        }
        self.tableView.reloadData()

    }
    
    // MARK: datasource
    func availabilityCalendayViewShowRedDot(view: MEAvailabilityCalendarDayView, date: NSDate) -> Bool {
        let dateKey = dateKeyFormatter.stringFromDate(date)
        var value : Bool = false
        self._availabilityTimes.forEach { (time: MEParseAvailability) in
            if time.date == dateKey {
                value = true
                return
            }
        }

        return value
    }
    
    // MARK: - Add Time
    @IBAction func onPressAddTime(sender: AnyObject) {
        if _selectedDate != nil {
            DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: NSDate(), minimumDate: nil, maximumDate: nil, datePickerMode: .Time) { (date) in
                if date != nil {
                    
                    self.addingTimeWithIndicatorAnimated(true)
                    
                    let dateAndTimeInterval = self.getDateStringAndTime(date!)
                    let availabilityTime = MEParseAvailability()
                    availabilityTime.date = dateAndTimeInterval.0

                    availabilityTime.time = dateAndTimeInterval.1 * 1000
                    availabilityTime.userId = MEParseUser.currentUser()!
                    availabilityTime.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                        if error == nil {
                            self._availabilityTimesForSelectedDate.append(availabilityTime)
                            self._availabilityTimes.append(availabilityTime)
                            self.tableView.reloadData()
                            self._selectedDateView?.showRedCorner()
                        } else {
                            
                        }
                        
                        self.addingTimeWithIndicatorAnimated(false)
                    })
                }
            }
        }
        
    }
    
    private func getDateStringAndTime(dateForTime: NSDate) -> (String, NSTimeInterval) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM.d.yyyy"
        
        let selectedDateString = dateFormatter.stringFromDate(self._selectedDate!)
        
        dateFormatter.dateFormat = "hh:mm a"
        let selectedTimeString = dateFormatter.stringFromDate(dateForTime)
        
        dateFormatter.dateFormat = "MMM.d.yyyy hh:mm a"
        let finalTimeString = selectedDateString + " " + selectedTimeString
        let realyTimeInterval = dateFormatter.dateFromString(finalTimeString)!.timeIntervalSince1970
        
        return (selectedDateString, realyTimeInterval)
    }
    
    private func addingTimeWithIndicatorAnimated(animate: Bool) {
        if animate {
            self.indicatorAddTime.startAnimating()
            self.btnAddTime.enabled = false
            self.btnAddTime.alpha = 0.5
            self.viewCalendar?.userInteractionEnabled = false

        } else {
            self.indicatorAddTime.stopAnimating()
            self.btnAddTime.enabled = true
            self.btnAddTime.alpha = 1.0
            self.viewCalendar?.userInteractionEnabled = true

        }
    }
    
    // MARK: - UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _availabilityTimesForSelectedDate.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MEAvailabilityTimeCell.cellIndentifier()) as! MEAvailabilityTimeCell
        cell.delegate = self
        cell.date = _availabilityTimesForSelectedDate[indexPath.row]
        return cell
    }
    
    // MARK: - MEAvailabilityTimeCell delegate
    func availabilityTimeCellEdit(cell: MEAvailabilityTimeCell) {
        
        var timeInterval = cell.date.time
        if String(timeInterval).characters.count > 10 {
            timeInterval = timeInterval / 1000
        }

        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: NSDate(timeIntervalSince1970: timeInterval), minimumDate: nil, maximumDate: nil, datePickerMode: .Time) { (date) in
            if date != nil {
                
                self.addingTimeWithIndicatorAnimated(true)
                
                let dateAndTimeInterval = self.getDateStringAndTime(date!)
                
                cell.date.time = dateAndTimeInterval.1 * 1000 // miliseconds
                cell.date.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                    if error == nil {
                        self.tableView.reloadData()
                    } else {
                        
                    }
                    
                    self.addingTimeWithIndicatorAnimated(false)
                })
            }
        }

    }
    
    func availabilityTimeCellDelete(cell: MEAvailabilityTimeCell) {
        self.addingTimeWithIndicatorAnimated(true)
        cell.date.deleteInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if let index = self._availabilityTimesForSelectedDate.indexOf(cell.date) {
                self._availabilityTimesForSelectedDate.removeAtIndex(index)
            }
            if let index = self._availabilityTimes.indexOf(cell.date) {
                self._availabilityTimes.removeAtIndex(index)
            }
            self.tableView.reloadData()
            self.addingTimeWithIndicatorAnimated(false)
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
