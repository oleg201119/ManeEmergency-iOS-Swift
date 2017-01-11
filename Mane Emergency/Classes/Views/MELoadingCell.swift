//
//  MELoadingCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/13/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MELoadingCell: METableViewCell {

    class func cellIdentifier() -> String {
        return "MELoadingCell"
    }
    
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet weak var lblEmpty: UILabel!
    
    func showLoading(loading: Bool = true, emptyMessage: String? = nil) -> Void {
        if loading {
            self.indicatorLoading.startAnimating()
            self.lblEmpty.hidden = true
        } else {
            self.indicatorLoading.stopAnimating()
            if emptyMessage != nil {
                self.lblEmpty.text = emptyMessage
                self.lblEmpty.hidden = false
            } else {
                self.lblEmpty.hidden = true
            }
        }
    }
}
