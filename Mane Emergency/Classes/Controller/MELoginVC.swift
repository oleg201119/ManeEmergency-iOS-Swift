//
//  MELoginVC.swift
//  Mane Emergency
//
//  Created by Oleg on 8/25/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse
import SVProgressHUD

class MELoginVC: MEViewController {

    private var _isStylist: Bool = true
    
    var stylist: Bool {
        set {
            _isStylist = newValue
        }
        get {
            return _isStylist
        }
    }
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var constrainBottomOfMainContainer: NSLayoutConstraint!
    @IBOutlet weak var lblWarning: UILabel!

    override func setupLayout() {
        super.setupLayout()
        
        let textfields: [UITextField] = [
            self.txtEmail,
            self.txtPassword
        ]
        self.setDefaultThemeToTextField(textfields)
        
        self.btnLogin.makeRoundView()
        self.lblWarning.hidden = true
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func keyboardWillShowRect(keyboardSize: CGSize) {
        self.constrainBottomOfMainContainer.constant = keyboardSize.height - 40
        self.updateConstraintWithAnimate(true)
    }
    
    override func keyboardWillHideRect() {
        self.constrainBottomOfMainContainer.constant = 0
        self.updateConstraintWithAnimate(true)
    }

    private func checkLoginInfo() -> Bool {
        var result = true
        if !validateEmail(self.txtEmail.text) {
            result = false
        } else if self.txtPassword.text == nil || self.txtPassword.text?.characters.count == 0 {
            result = false
        }
        return result
    }
    
    private func loginWithEmail(email: String, password: String) -> Void {
        
        view.endEditing(true)
        SVProgressHUD.show()
        MEParseUser.logInWithUsernameInBackground(email, password: password) { (user: PFUser?, error: NSError?) in
            
            if error == nil {
                
                let gotoMainVC = { () -> Void in
                    SVProgressHUD.dismiss()
                    self.appManager().isLoadingFromLogin = true
                    NSNotificationCenter.defaultCenter().postNotificationName(APPNOTIFICATION.Login, object: nil, userInfo: nil)
                    self.navigationController?.modalTransitionStyle = .CoverVertical
                    self.navigationController?.dismissViewControllerAnimated(true, completion: {
                        
                    })
                    
                    
                }
                if (user as! MEParseUser).isStylist == true && self.stylist == true {
                    gotoMainVC()
                } else if (user as! MEParseUser).isStylist == false && self.stylist == false {
                    gotoMainVC()
                } else {
                    let accountType = (self.stylist == false ? "Customer" : "Stylist")
                    let accountTypeNot = (self.stylist == true ? "Customer" : "Stylist")
                    let messageTitle = "Warning"
                    let message = "Here is login form for \(accountType). But you are logging in with \(accountTypeNot) user. Please login with \(accountType) account."
                    self.showSimpleAlert(messageTitle, Message: message, CloseButton: "Close", Completion: {
                        
                    })
                    MEParseUser.logOutInBackgroundWithBlock({ (error: NSError?) in
                        SVProgressHUD.dismiss()
                    })
                }
            } else {
                let messageTitle = "Failure"
                let message = error!.localizedDescription
                self.showSimpleAlert(messageTitle, Message: message, CloseButton: "Close", Completion: { 
                    SVProgressHUD.dismiss()
                })
            }
        }
        
    }
    
    @IBAction func onPressLogin(sender: AnyObject) -> Void {
        if checkLoginInfo() {
            self.lblWarning.hidden = true
            self.loginWithEmail(self.txtEmail.text!, password: self.txtPassword.text!)
        } else {
            self.lblWarning.hidden = false
        }
    }
}

extension MELoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtPassword.becomeFirstResponder()
        } else if textField == self.txtPassword {
            
        }
        return true
    }
}