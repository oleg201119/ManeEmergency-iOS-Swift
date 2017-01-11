//
//  MEMenuCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/5/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MEMenuCell: METableViewCell {

    class func cellIdentifier() -> String {
        return "MEMenuCell"
    }
    
    @IBOutlet weak var lblTitle: UILabel!
    
    func setTitle(title: String?) -> Void {
        self.lblTitle.text = title?.uppercaseString
    }
}
