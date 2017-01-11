//
//  METableViewController.swift
//  Mane Emergency
//
//  Created by Oleg on 8/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class METableViewController: UITableViewController {

    internal var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "imgBackground"))

    }

}
