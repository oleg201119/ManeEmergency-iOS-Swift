//
//  MEAvailabilityCalendarView.swift
//  Mane Emergency
//
//  Created by Oleg on 9/16/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MEAvailabilityCalendarView: MEView {

    @IBOutlet weak var lblDateDuration: UILabel?
    @IBOutlet weak var viewDateBox: UIView!
    
    private var _dateViews: [MEAvailabilityCalendarDayView] = []
    var delegate: MEAvailabilityCalendarViewDelegate?
    var dataSource: MEAvailabilityCalendarViewDataSource?
    
    class func instanceFromNib() -> MEAvailabilityCalendarView {
        let view = UINib(nibName: "MEAvailabilityCalendarView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! MEAvailabilityCalendarView
        view.makeRoundView()
        return view
    }
    
    func setDuration(firstDate: NSDate, lastDate: NSDate) -> Void {
        
        if _dateViews.count == 0 {
            for index in 0...13 {
                let dateView = MEAvailabilityCalendarDayView()
                dateView.selected(false)
                self.viewDateBox.addSubview(dateView)
                _dateViews.append(dateView)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPressDay(_:)))
                dateView.addGestureRecognizer(tapGesture)
                dateView.userInteractionEnabled = true
                let weekDay = index % 7
                let week = Int(index / 7)
                if weekDay == 0 {
                    if index == 0 {
                        dateView.snp_makeConstraints(closure: { (make) in
                            make.left.equalTo(0)
                            make.top.equalTo(0)
                            make.width.greaterThanOrEqualTo(30)
                            make.height.equalTo(40)
                        })
                    } else {
                        dateView.snp_makeConstraints(closure: { (make) in
                            make.top.equalTo(_dateViews[index - 7].snp_bottom).offset(0)
                            make.height.equalTo(_dateViews[0].snp_height).offset(0)
                            make.width.equalTo(_dateViews[0].snp_width).offset(0)
                            make.left.equalTo(_dateViews[0].snp_left).offset(0)
                        })

                    }
                } else {
                    dateView.snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(_dateViews[week * 7].snp_top).offset(0)
                        make.height.equalTo(_dateViews[0].snp_height).offset(0)
                        make.width.equalTo(_dateViews[0].snp_width).offset(0)
                        make.left.equalTo(_dateViews[index - 1].snp_right).offset(0)
                        if weekDay == 6 {
                            make.right.equalTo(0)
                        }
                    })

                }
                
                /*
                if index == 0 {
                } else if 0 < index && index <= 6 {
                    dateView.snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(_dateViews[0].snp_top).offset(0)
                        make.bottom.equalTo(_dateViews[0].snp_bottom).offset(0)
                        make.width.equalTo(_dateViews[0].snp_width).offset(0)
                        make.left.equalTo(_dateViews[index - 1].snp_right).offset(0)
                        if index == 6 {
                            make.right.equalTo(0)
                        }
                    })
                } else if index == 7 {
                } else if index > 7 {
                    dateView.snp_makeConstraints(closure: { (make) in
                        make.top.equalTo(_dateViews[7].snp_top).offset(0)
                        make.bottom.equalTo(_dateViews[7].snp_bottom).offset(0)
                        make.width.equalTo(_dateViews[0].snp_width).offset(0)
                        make.left.equalTo(_dateViews[index - 1].snp_right).offset(0)
                        if index == 13 {
                            make.right.equalTo(0)
                        }
                    })
                } */
            }
        }
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let dateRange = calendar.dateRange(startDate: firstDate,
                                           endDate: lastDate,
                                           stepUnits: .Day,
                                           stepValue: 1)
        let datesInRange = Array(dateRange)
        for index in 0..._dateViews.count - 1 {
            let dateView = _dateViews[index]
            if index < datesInRange.count {
                let date = datesInRange[index]
                dateView.date = date
                let showRedDot = dataSource?.availabilityCalendayViewShowRedDot(dateView, date: date)
                if showRedDot == true {
                    dateView.showRedCorner()
                } else {
                    dateView.hideRedCorner()
                }
            }
            
        }
        if self.lblDateDuration != nil {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let dateDurationString = dateFormatter.stringFromDate(_dateViews[0].date!) + " - " + dateFormatter.stringFromDate(_dateViews[_dateViews.count - 1].date!)
            self.lblDateDuration!.text = dateDurationString
        }
    }
    
    func onPressDay(sender: AnyObject) -> Void {
        if let gesture = sender as? UITapGestureRecognizer {
            if let dayView = gesture.view as? MEAvailabilityCalendarDayView {
                _dateViews.forEach({ (otherDayView: MEAvailabilityCalendarDayView) in
                    otherDayView.selected(false)
                })
                dayView.selected(true)
                self.delegate?.availabilityCalendayView(dayView, selectedDate: dayView.date!)
            }
        }
    }
}

protocol MEAvailabilityCalendarViewDelegate {
    func availabilityCalendayView(view: MEAvailabilityCalendarDayView, selectedDate: NSDate) -> Void
}

protocol MEAvailabilityCalendarViewDataSource {
    func availabilityCalendayViewShowRedDot(view: MEAvailabilityCalendarDayView, date: NSDate) -> Bool
}

class MEAvailabilityCalendarDayView: MEView {
    
    private var _date: NSDate?
    private var _lblTitle: UILabel?
    private var _imgviewRedCornor: UIImageView?
    
    var date: NSDate? {
        set {
            _date = newValue
            if newValue != nil {
                if _lblTitle == nil {
                    _lblTitle = UILabel(frame: self.bounds)
                    _lblTitle?.textAlignment = .Center
                    _lblTitle?.font = UIFont(name: APPFONTNAME.Default500, size: 14)
                    _lblTitle?.textColor = APPCOLOR.Default_YELLOW
                    _lblTitle?.minimumScaleFactor = 0.5
                    _lblTitle?.adjustsFontSizeToFitWidth = true
                    self.addSubview(_lblTitle!)
                    _lblTitle?.snp_makeConstraints(closure: { (make) in
                        /*
                        make.left.equalTo(0)
                        make.right.equalTo(0)
                        make.top.equalTo(0)
                        make.bottom.equalTo(0) */
                        make.centerX.equalTo(0)
                        make.centerY.equalTo(0)
                        make.width.equalTo(30)
                        make.height.equalTo(28)
                    })
                }
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "d"
                _lblTitle?.text = dateFormatter.stringFromDate(newValue!)
            }
        }
        get {
            return _date
        }
    }
    
    func showRedCorner() -> Void {
        if _imgviewRedCornor == nil {
//            _imgviewRedCornor = UIImageView(image: UIImage(named: "iconRedCorner"))
            _imgviewRedCornor = UIImageView()
            _imgviewRedCornor?.backgroundColor = UIColor.redColor()
            _imgviewRedCornor?.layer.cornerRadius = 2.5
            _imgviewRedCornor?.clipsToBounds = true
            self.addSubview(_imgviewRedCornor!)
            _imgviewRedCornor?.snp_makeConstraints(closure: { (make) in
                make.centerX.equalTo(_lblTitle!.snp_centerX).offset(0)
                make.top.equalTo(_lblTitle!.snp_bottom).offset(1)
                make.width.equalTo(5)
                make.height.equalTo(5)
//                make.right.equalTo(0)
//                make.bottom.equalTo(0)
            })
        }
        _imgviewRedCornor?.hidden = false
    }
    
    func hideRedCorner() -> Void {
        _imgviewRedCornor?.hidden = true
    }
    
    func selected(selected: Bool = true) -> Void {
        if selected {
            _lblTitle?.backgroundColor = APPCOLOR.Default_YELLOW
            self._lblTitle?.textColor = UIColor.blackColor()
        } else {
            _lblTitle?.backgroundColor = UIColor.clearColor()
            self._lblTitle?.textColor = APPCOLOR.Default_YELLOW
        }
    }
    
    func setDisable(disable: Bool = true) -> Void {
        if disable == true {
            self.userInteractionEnabled = false
            self._lblTitle?.alpha = 0.5
            self._imgviewRedCornor?.hidden = true
        } else {
            self.userInteractionEnabled = true
            self._lblTitle?.alpha = 1
            self._imgviewRedCornor?.hidden = false
        }
    }
    
}