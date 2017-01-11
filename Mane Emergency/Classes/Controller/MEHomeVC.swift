//
//  MEHomeVC.swift
//  Mane Emergency
//
//  Created by Oleg on 8/30/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MEHomeVC: MEViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtSearchZipCode: UITextField!
    @IBOutlet weak var btnLoginWithStylist: UIButton!
    @IBOutlet weak var btnLoginWithCustomer: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var constrainBottomOfMainContainer: NSLayoutConstraint!
    
    override func setupLayout() {
        super.setupLayout()
        
        let imgviewSearchIcon = UIImageView(image: UIImage(named: "iconSearchBlack"))
        imgviewSearchIcon.backgroundColor = APPCOLOR.Default_YELLOW
        imgviewSearchIcon.contentMode = .Center
        imgviewSearchIcon.frame = CGRectMake(0, 0, self.txtSearchZipCode.frame.size.height, self.txtSearchZipCode.frame.size.height)
        self.setDefaultThemeToTextField([self.txtSearchZipCode])
        self.txtSearchZipCode.addRightView(imgviewSearchIcon)
        
        let tapSearchIcon = UITapGestureRecognizer(target: self, action: #selector(onPressSearch(_:)))
        imgviewSearchIcon.addGestureRecognizer(tapSearchIcon)
        imgviewSearchIcon.userInteractionEnabled = true
        
        self.btnLoginWithStylist.makeRoundView()
        self.btnLoginWithCustomer.makeRoundView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.txtSearchZipCode.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func keyboardWillShowRect(keyboardSize: CGSize) {
        self.constrainBottomOfMainContainer.constant = keyboardSize.height
        self.updateConstraintWithAnimate(true)
    }
    
    override func keyboardWillHideRect() {
        self.constrainBottomOfMainContainer.constant = 0
        self.updateConstraintWithAnimate(true)
    }
    
    func onPressSearch(sender: AnyObject) -> Void {
        print("Tap Search")
        if self.txtSearchZipCode.text?.characters.count > 2 {
            appManager().zipcodeForSearch = self.txtSearchZipCode.text!
            self.txtSearchZipCode.resignFirstResponder()
            self.appManager().isLoadingFromLogin = true
            NSNotificationCenter.defaultCenter().postNotificationName(APPNOTIFICATION.Login, object: nil, userInfo: nil)
            self.navigationController?.dismissViewControllerAnimated(true, completion: { 
                
            })
        }
    }
    
    // MARK: - UITextField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtSearchZipCode {
            self.onPressSearch(textField)
        }
        return true
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == APPSEGUE.gotoLoginWithStylist {
            let loginVC = segue.destinationViewController as! MELoginVC
            loginVC.stylist = true
        } else if segue.identifier == APPSEGUE.gotoLoginWithCustomer {
            let loginVC = segue.destinationViewController as! MELoginVC
            loginVC.stylist = false
        }
    }
    
}
