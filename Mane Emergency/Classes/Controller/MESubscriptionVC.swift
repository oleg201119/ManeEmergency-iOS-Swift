//
//  MESubscriptionVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/2/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import SVProgressHUD
import StoreKit

class MESubscriptionVC: METableViewController {

    @IBOutlet weak var btnSubscription: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveProducts()
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.navigationController?.addSideMenuButton()
        self.btnSubscription.makeRoundView()
    }
    
    private func retrieveProducts() {
        
        SVProgressHUD.show()
        
        let products: Set<String> = [ SUBSCRIPTION_INAPP_ID ]
        
        SwiftyStoreKit.retrieveProductsInfo(products) { result in
            if result.retrievedProducts.count > 0 {
                self.btnSubscription.enabled = true
                let product = result.retrievedProducts.first!
                let priceString = self.priceStringForProduct(product)
                self.btnSubscription.setTitle("SUBSCRIPTION " + priceString!, forState: .Normal)
            } else {
                self.btnSubscription.enabled = false
            }
            
            if result.error != nil {
                self.btnSubscription.enabled = false
                print("Error: \(result.error)")
            }
            
            SVProgressHUD.dismiss()
        }
    }

    func priceStringForProduct(item: SKProduct) -> String? {
        let numberFormatter = NSNumberFormatter()
        let price = item.price
        let locale = item.priceLocale
        numberFormatter.numberStyle = .CurrencyStyle
        numberFormatter.locale = locale
        return numberFormatter.stringFromNumber(price)
    }

    @IBAction func onPressSubscription(sender: AnyObject) {
        
        SVProgressHUD.show()
        SwiftyStoreKit.purchaseProduct(SUBSCRIPTION_INAPP_ID) { (result) in
            switch result {
            case .Success(let productId):
                print("Purchase Success: \(productId)")
                let currentUser = MEParseUser.currentUser()!
                currentUser.purchase = 2
                let expireDate = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: 1, toDate: NSDate(), options: [])
                currentUser.expired_date = expireDate!.timeIntervalSince1970 * 1000 // miliseconds

                currentUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                    if success == true {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(APPNOTIFICATION.Login, object: nil, userInfo: nil)
                        
                        self.showSimpleAlert("Purchased Successfully", Message: "You can get premium service from now about a month.", CloseButton: "OK", Completion: nil)
                    } else {
                        self.showSimpleAlert("Failed", Message: "You did successed to buy credits but failed to save your total credits to database. Please contact to support team. We apologized about this.", CloseButton: "OK", Completion: {
                            
                        })
                    }
                    SVProgressHUD.dismiss()
                })
            case .Error(let error):
                var errorString: String!
                switch error {
                case .Failed(let error):
                    errorString = error.localizedDescription
                    break
                case .InvalidProductId( _):
                    errorString = "You did request with invalid ProductID, Please contact support team."
                    break
                case .NoProductIdentifier:
                    errorString = "There is no exist ProductID, Please contact support team."
                    break
                case .PaymentNotAllowed:
                    errorString = "This item is not allowed by UMO LLC. Please contact support team."
                    break
                }
                print("Purchase Failed: \(error)")
                self.showSimpleAlert("Error", Message: errorString, CloseButton: "Close", Completion: {
                    
                })
                SVProgressHUD.dismiss()
            }
            
        }

    }
}
