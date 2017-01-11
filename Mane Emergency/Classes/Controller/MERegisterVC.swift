//
//  MERegisterVC.swift
//  Mane Emergency
//
//  Created by Oleg on 8/25/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse
import SVProgressHUD

class MERegisterVC: METableViewController {
	
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var switchStylist: UISwitch!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblWarning: UILabel!
    
    override func setupLayout() {
        super.setupLayout()
        
        /*
        let btnBack = UIBarButtonItem(image: UIImage(named: "iconBack"), style: .Plain, target: self, action: #selector(onBack(_:)))
        btnBack.tintColor = APPCOLOR.Default_YELLOW
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        space.width = 10
        self.navigationItem.back
        self.navigationItem.leftBarButtonItems = [space, btnBack]
 */
        let textfields: [UITextField] = [
            self.txtFirstName,
            self.txtLastName,
            self.txtEmail,
            self.txtPhoneNumber,
            self.txtZipCode,
            self.txtPassword,
            self.txtConfirmPassword
        ]
        self.setDefaultThemeToTextField(textfields)
        
        self.btnRegister.makeRoundView()
        self.lblWarning.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func checkUserRegisterInfo() -> Bool {
        if  self.txtFirstName.text?.characters.count == 0 ||
            self.txtLastName.text?.characters.count == 0 ||
            self.txtEmail.text?.characters.count == 0 ||
            self.txtPhoneNumber.text?.characters.count == 0 ||
            self.txtZipCode.text?.characters.count == 0 ||
            self.txtPassword.text?.characters.count == 0 ||
            self.txtConfirmPassword.text?.characters.count == 0
        {
            self.lblWarning.text = "Please fill out your information to all field."
            return false
        }
        if validateEmail(self.txtEmail.text!) == false {
            self.lblWarning.text = "Invalide email address."
            return false
        }
        if self.txtPassword.text != self.txtConfirmPassword.text {
            self.lblWarning.text = "Incorrect password. Please confirm your password again."
            return false
        }
        return true
    }
    
    @IBAction func onPressRegister(sender: UIButton) -> Void {
        if checkUserRegisterInfo() {
            self.lblWarning.hidden = true
            let newUser = MEParseUser()
            newUser.username    = self.txtEmail.text!
            newUser.email       = self.txtEmail.text!
            newUser.firstName   = self.txtFirstName.text!
            newUser.lastName    = self.txtLastName.text!
            newUser.phoneNumber = self.txtPhoneNumber.text!
            newUser.zipCode     = self.txtZipCode.text!
            newUser.password    = self.txtPassword.text!
            newUser.isStylist   = self.switchStylist.on
            
            SVProgressHUD.show()
            newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                if success == true {
                    self.appManager().isLoadingFromLogin = true
                    NSNotificationCenter.defaultCenter().postNotificationName(APPNOTIFICATION.Login, object: nil, userInfo: nil)
                    self.navigationController?.modalTransitionStyle = .CoverVertical
                    self.navigationController?.dismissViewControllerAnimated(true, completion: { 
                        
                    })
                } else {
                    var errorMessage: String!
                    if error == nil {
                        errorMessage = "Unknown server error..."
                    } else {
                        errorMessage = error!.localizedDescription
                    }
                    self.showSimpleAlert("Error", Message: errorMessage, CloseButton: "Close", Completion: { 
                        
                    })
                }
                SVProgressHUD.dismiss()
            })
        } else {
            self.lblWarning.hidden = false
        }
    }
}
