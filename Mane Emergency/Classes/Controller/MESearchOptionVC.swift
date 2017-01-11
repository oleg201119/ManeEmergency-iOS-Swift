//
//  MESearchOptionVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/5/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import HCSStarRatingView
import DatePickerDialog

class MESearchOptionVC: MEViewController {

    @IBOutlet weak var segmentPricce: UISegmentedControl!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var btnFromTime: UIButton!
    @IBOutlet weak var btnToTime: UIButton!
    @IBOutlet weak var rateView: HCSStarRatingView!
    @IBOutlet weak var btnSearch: UIButton!
    
    private var dateFormatter: NSDateFormatter {
        let _dateFormatter = NSDateFormatter()
        _dateFormatter.dateFormat = "MMM.d.yyyy"
        return _dateFormatter
    }
    
    private var timeFormatter: NSDateFormatter {
        let _timeFormatter = NSDateFormatter()
        _timeFormatter.dateFormat = "h:mm a"
        return _timeFormatter
    }
    
    private var fromTime: NSTimeInterval = NSDate().timeIntervalSince1970
    private var toTime: NSTimeInterval = NSDate(timeInterval: 7200, sinceDate: NSDate()).timeIntervalSince1970
    
    var delegate: MESearchOptionVCDelegate?

    override func setupLayout() {
        super.setupLayout()
        
        self.btnDate.makeRoundView()
        self.btnFromTime.makeRoundView()
        self.btnToTime.makeRoundView()
        self.btnSearch.makeRoundView()
        
        self.segmentPricce.selectedSegmentIndex = 0
        self.btnDate.setTitle(self.dateFormatter.stringFromDate(NSDate()), forState: .Normal)
        self.btnFromTime.setTitle(self.timeFormatter.stringFromDate(NSDate(timeIntervalSince1970: fromTime)), forState: .Normal)
        self.btnToTime.setTitle(self.timeFormatter.stringFromDate(NSDate(timeIntervalSince1970: toTime)), forState: .Normal)
        self.rateView.value = 2.0
        
        
    }
    
    @IBAction func onPressDateTime(sender: UIButton) {
        var pickerTitle = "Select Date"
        var pickerMode : UIDatePickerMode = .Date
        
        if sender == self.btnToTime || sender == self.btnFromTime {
            pickerTitle = "Select Time"
            pickerMode = .Time
        }
        
        DatePickerDialog().show(pickerTitle, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: NSDate(), minimumDate: nil, maximumDate: nil, datePickerMode: pickerMode) { (date) in
            if date != nil {
//                self.btnDate.setTitle(self.dateFormatter.stringFromDate(date!), forState: .Normal)
                if sender == self.btnDate {
                    self.btnDate.setTitle(self.dateFormatter.stringFromDate(date!), forState: .Normal)
                    
                } else {
                    if sender == self.btnFromTime {
                        self.btnFromTime.setTitle(self.timeFormatter.stringFromDate(date!), forState: .Normal)
                        self.fromTime = date!.timeIntervalSince1970
                    } else if sender == self.btnToTime {
                        self.btnToTime.setTitle(self.timeFormatter.stringFromDate(date!), forState: .Normal)
                        self.toTime = date!.timeIntervalSince1970
                    }
                }
            }
        }
    }
    
    @IBAction func onPressSearch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
        self.delegate?.searchStylist(self.segmentPricce.selectedSegmentIndex, date: self.btnDate.titleLabel!.text!, fromTime: fromTime, toTime: toTime, rate: Float(self.rateView.value))
    }
}

protocol MESearchOptionVCDelegate {
    func searchStylist(price: Int, date: String, fromTime: NSTimeInterval, toTime: NSTimeInterval, rate: Float) -> Void
}