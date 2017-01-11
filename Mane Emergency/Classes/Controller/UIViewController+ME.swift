//
//  UIViewController+UMO.swift
//  UMO
//
//  Created by Oleg on 8/27/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController


extension UIViewController {


    func setupLayout() -> Void {

    }
    
    func keyboardWillShowRect(keyboardSize : CGSize) -> Void {
        
    }
    
    func keyboardWillHideRect() -> Void {
        
    }
    
    func updateConstraintWithAnimate(animate: Bool) -> Void {
        if animate == true {
            self.view.setNeedsUpdateConstraints()
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: { (complete) in
                    
            })
        } else {
            updateViewConstraints()
        }
    }
    
    func appManager() -> MEAppManager {
        return MEAppManager.sharedManager
    }
    
    
    func enableButton(button: UIButton) -> Void {
        button.enabled = true
        button.alpha = 1
    }
    
    func disableButton(button: UIButton) -> Void {
        button.enabled = false
        button.alpha = 0.5
    }
    
    internal func checkPurchase() -> Bool {
        if let currentUser = MEParseUser.currentUser() {
            if  currentUser.purchase > 0 &&
                currentUser.expired_date / 1000 > NSDate().timeIntervalSince1970 {
                return true
            }
        }
        return false
    }

    // MARK: - NSNotification Selector
    
    internal func addNotificationSelectors() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationPostedMedia(_:)), name: APPNOTIFICATION.POSTEDMEDIA, object: nil)
        
    }
    
    internal func removeNotificationSelectors() {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: APPNOTIFICATION.POSTEDMEDIA, object: nil)
    }

    func showSimpleAlert(title: String?, Message message: String?, CloseButton closeButton: String?, Completion completion:(() -> Void)?) -> Void {
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .Alert)
        let closeAction = UIAlertAction.init(title: closeButton, style: .Cancel) { (alertAction: UIAlertAction) in
            if completion != nil {
                completion!()
            }
        }
        alertView.addAction(closeAction)
        presentViewController(alertView, animated: true) {
        }
    }
    
    func setDefaultThemeToTextField(textfields: [UITextField]) -> Void {
        for textfield in textfields {
            textfield.addLeftPadding()
            textfield.makeRoundView()
            textfield.makeBorder(APPCOLOR.TextField_Border)
            textfield.backgroundColor = APPCOLOR.TextField_Background
            if let originPlaceholder = textfield.placeholder {
                let placeholder = NSAttributedString(string: originPlaceholder, attributes: [NSForegroundColorAttributeName:APPCOLOR.Default_YELLOW_TRANS])
                textfield.attributedPlaceholder = placeholder
            }
        }
    }
    
    func validateEmail(enteredEmail:String?) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
        
    }
    
    func addGestureForFullScreenImage(imageview: UIImageView!) -> Void {
        
        imageview.gestureRecognizers?.forEach({ (gesture: UIGestureRecognizer) in
            imageview.removeGestureRecognizer(gesture)
        })        
        let tapPicture = UITapGestureRecognizer(target: self, action: #selector(fullscreenImage(_:)))
        imageview.addGestureRecognizer(tapPicture)
        imageview.userInteractionEnabled = true
    }
    
    func fullscreenImage(sender: UITapGestureRecognizer) -> Void {
        let imageView = sender.view as! UIImageView
        if imageView.image != nil {
            let viewController = SFFullscreenImageDetailViewController(imageView: imageView)
            viewController.presentInCurrentKeyWindow()
        }
    }
    
    @IBAction func onBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancleNavigationController(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

}


