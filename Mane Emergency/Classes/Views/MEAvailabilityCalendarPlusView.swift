//
//  MEAvailabilityCalendarPlusView.swift
//  Mane Emergency
//
//  Created by Oleg on 9/16/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MEAvailabilityCalendarPlusView: MEAvailabilityCalendarView {

    @IBOutlet weak var btnIncreaseYear: UIButton!
    @IBOutlet weak var btnDecreaseYear: UIButton!
    @IBOutlet weak var btnIncreaseMonth: UIButton!
    @IBOutlet weak var btnDecreaseMonth: UIButton!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    
    
    override func setDuration(firstDate: NSDate, lastDate: NSDate) {
        
    }
    
    @IBAction func onPressChangeYear(sender: UIButton) -> Void {
        if sender == btnIncreaseYear {
            
        } else if sender == btnDecreaseYear {
            
        }
    }
    
    @IBAction func onPressChangeMonth(sender: UIButton) -> Void {
        if sender == btnIncreaseMonth {
            
        } else if sender == btnDecreaseMonth {
            
        }
    }
    
    func setMonth(month: NSDate = NSDate()) -> Void {
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
