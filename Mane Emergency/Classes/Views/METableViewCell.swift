//
//  METableViewCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/5/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class METableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedBgView = UIView(frame: self.bounds)
        selectedBgView.backgroundColor = APPCOLOR.Default_LIGHT_BLACK
        self.selectedBackgroundView = selectedBgView
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
    }

}
