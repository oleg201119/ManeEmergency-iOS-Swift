//
//  MEStylistProfileEditVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/4/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import ParseUI
import MobileCoreServices
import SVProgressHUD

class MEProfileEditVC: METableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imgviewUserAvatar: PFImageView!
    @IBOutlet weak var btnEditPhoto: UIButton!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtBio: UITextView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var segmentPrice: UISegmentedControl!
    
    private var changedPhoto: UIImage?
    
    private var _user: MEParseUser!
    var user: MEParseUser {
        set {
            _user = newValue
            
        }
        get {
            return _user
        }
    }
    
    override func setupLayout() {
        super.setupLayout()
        self.imgviewUserAvatar.makeRoundView(radius: self.imgviewUserAvatar.frame.size.width * 0.5)
        let textfields: [UITextField] = [
            self.txtFirstName,
            self.txtLastName,
            self.txtPhoneNumber,
            self.txtZipCode
        ]
        self.setDefaultThemeToTextField(textfields)
        
        showProfileInfo(_user)
    }

    func showProfileInfo(user: MEParseUser) -> Void{
        // Avatar
        imgviewUserAvatar.image = PLACEHOLDER.avatarUser
        imgviewUserAvatar.file = user.profile
        imgviewUserAvatar.loadInBackground()
        
        // User Name
        self.txtFirstName.text = user.firstName
        self.txtLastName.text = user.lastName
        
        // Bio
        self.txtBio.text = user.bio
        
        // Phone Number
        self.txtPhoneNumber.text = user.phoneNumber
        
        // Zip Code
        self.txtZipCode.text = user.zipCode
        
        // Price Type
        if user.isStylist == true {
            if 0 <= user.price && user.price < 3 {
                self.segmentPrice.selectedSegmentIndex = user.price
            }
        }
    }

    @IBAction func onPressChangePhone(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Select Phoeo", message: nil, preferredStyle: .ActionSheet)
        let albumAction = UIAlertAction(title: "From Photo Album", style: .Default) { (action: UIAlertAction) in
            self.openImagePicker(.SavedPhotosAlbum)
        }
        let cameraAction = UIAlertAction(title: "From Camera", style: .Default) { (action: UIAlertAction) in
            self.openImagePicker(.Camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true) { 
            
        }
    }
    
    @IBAction func onPressSaveProfile(sender: AnyObject) {
        if self.txtFirstName.text?.characters.count == 0 ||
        self.txtLastName.text?.characters.count == 0 ||
        self.txtPhoneNumber.text?.characters.count == 0 ||
        self.txtZipCode.text?.characters.count == 0
        {
            let message = "You should fill out First Name, Last Name, Phone Number and Zip Code."
            self.showSimpleAlert("Warning", Message: message, CloseButton: "OK", Completion: nil)
            return
        }
        
        let saveProfile = { () -> Void in
            SVProgressHUD.show()
            self.user.firstName = self.txtFirstName.text!
            self.user.lastName = self.txtLastName.text!
            self.user.bio = self.txtBio.text
            self.user.phoneNumber = self.txtPhoneNumber.text!
            self.user.zipCode = self.txtZipCode.text!
            if self.user.isStylist == true {
                self.user.price = self.segmentPrice.selectedSegmentIndex
            }
            self.user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                if error != nil {
                    self.showSimpleAlert("Error", Message: error?.localizedDescription, CloseButton: "Close", Completion: nil)
                } else {
                    self.navigationController?.popViewControllerAnimated(true)
                    NSNotificationCenter.defaultCenter().postNotificationName(APPNOTIFICATION.UpdateProfile, object: nil)
                }
                SVProgressHUD.dismiss()
            })
        }
        
        if changedPhoto != nil {
            user.profile = PFFile(data: UIImageJPEGRepresentation(changedPhoto!, 0.5)!, contentType: "image/jpg")
            SVProgressHUD.showProgress(0)
            user.profile?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                saveProfile()
            }, progressBlock: { (progress: Int32) in
                SVProgressHUD.showProgress(Float(progress) / 100.0)
            })
        } else {
            saveProfile()
        }
    }
    
    private func openImagePicker(type: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = type;
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [kUTTypeImage as String]
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // UIImagePickerController delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        changedPhoto = image
        self.imgviewUserAvatar?.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil);
    }

    
    // UITableView datasource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _user.isStylist == true {
            return super.tableView(tableView, numberOfRowsInSection: section)
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section) - 2
        }
    }
}
