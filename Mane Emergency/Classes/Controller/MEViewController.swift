//
//  MEViewController.swift
//  Mane Emergency
//
//  Created by Oleg on 8/25/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit

class MEViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        //        self.navigationItem.backBarButtonItem?.title = " "
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    
    private func addKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    private func removeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) -> Void {
        var keyboardBound : CGRect = CGRectZero
        notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.getValue(&keyboardBound)
        keyboardWillShowRect(keyboardBound.size)
    }
    
    func keyboardWillHide(notification: NSNotification) -> Void {
        keyboardWillHideRect()
    }
    
    


}
