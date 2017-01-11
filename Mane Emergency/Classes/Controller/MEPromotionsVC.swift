//
//  MEPromotionsVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/1/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class MEPromotionsVC: METableViewController {

    private var promotions: [MEParsePromotions] = []
    
    override func setupLayout() {
        super.setupLayout()
        
        if let currentUser = MEParseUser.currentUser() {
            if currentUser.isStylist == true && checkPurchase() == true {
                let btnAddPromotion = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.onPressAddPromotion(_:)))
                btnAddPromotion.tintColor = APPCOLOR.Default_YELLOW
                self.navigationItem.rightBarButtonItem = btnAddPromotion
            }
        }

//        self.navigationController?.addSideMenuButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getPromotions()
    }
    
    private func getPromotions() {
        SVProgressHUD.show()
        let query = MEParsePromotions.query()!
        query.orderByDescending(FIELDNAME.createdAt)
        query.includeKey(FIELDNAME.Promotitons_userId)
        query.limit = 50
        query.cachePolicy = .NetworkElseCache
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
            if error == nil {
                self.promotions = result as! [MEParsePromotions]
                self.tableView.reloadData()
            }
            SVProgressHUD.dismiss()
        }
    }
    
    // UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MEPromotionCell.cellIdentifier()) as! MEPromotionCell
        cell.promotion = promotions[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let promotion = promotions[indexPath.row]
        if let promotionDescription = promotion.objectForKey(FIELDNAME.Promotitons_description) as? String {
            let textHeight = promotionDescription.heightWithConstrainedWidth(tableView.frame.size.width - 16, font: UIFont(name: "MuseoSansCyrl-300", size: 16.0)!)
            return textHeight + tableView.frame.size.width + 150
        } else {
            return tableView.frame.size.width + 150
        }
        
    }
    
    // MARK: - Actions
    func onPressAddPromotion(sender: AnyObject) -> Void {
        self.performSegueWithIdentifier(APPSEGUE.gotoPostPromotionVC, sender: self)
    }
    
    
}
