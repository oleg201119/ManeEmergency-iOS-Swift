//
//  MEAvailabilityTimeCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/14/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MEAvailabilityTimeCell: METableViewCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewBox: UIView!
    
    class func cellIndentifier() -> String {
        return "MEAvailabilityTimeCell"
    }

    private var _date: MEParseAvailability! //= NSDate()
    var delegate: MEAvailabilityTimeCellDelegate?
    
    var date: MEParseAvailability {
        set {
            _date = newValue
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            var timeInterval = newValue.time
            if String(timeInterval).characters.count > 10 {
                timeInterval = timeInterval / 1000
            }

            self.lblTime.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: timeInterval))
        }
        get {
            return _date
        }
    }
    
    @IBAction func onPressEditTime(sender: AnyObject) {
        delegate?.availabilityTimeCellEdit(self)
    }
    
    @IBAction func onPressDeleteTime(sender: AnyObject) {
        delegate?.availabilityTimeCellDelete(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBox.makeRoundView()
    }
}

protocol MEAvailabilityTimeCellDelegate {
    func availabilityTimeCellEdit(cell: MEAvailabilityTimeCell) -> Void
    func availabilityTimeCellDelete(cell: MEAvailabilityTimeCell) -> Void
}