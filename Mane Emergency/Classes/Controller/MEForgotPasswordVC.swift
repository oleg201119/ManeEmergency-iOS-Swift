//
//  MEForgotPasswordVC.swift
//  Mane Emergency
//
//  Created by Oleg on 8/23/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MEForgotPasswordVC: MEViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSendPassword: UIButton!
    @IBOutlet weak var constrainBottomOfMainContainer: NSLayoutConstraint!
    @IBOutlet weak var lblWarning: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func setupLayout() {
        super.setupLayout()
        
        let textfields: [UITextField] = [
            self.txtEmail,
        ]
        self.setDefaultThemeToTextField(textfields)
        
        self.btnSendPassword.makeRoundView()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
