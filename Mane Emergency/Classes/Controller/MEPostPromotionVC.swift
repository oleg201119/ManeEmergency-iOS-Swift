//
//  MEPostPromotionVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/1/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import Parse
import MobileCoreServices
import SVProgressHUD

class MEPostPromotionVC: METableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var viewDescriptionBox: UIView!
    @IBOutlet weak var txtDescription: KMPlaceholderTextView!
    @IBOutlet weak var viewImageBox: UIView!
    @IBOutlet weak var imgviewPromotion: UIImageView!
    @IBOutlet weak var btnSetImage: UIButton!
    
    private var selectedImage: UIImage?
    
    override func setupLayout() {
        super.setupLayout()
        self.viewDescriptionBox.makeRoundView()
        self.viewImageBox.makeRoundView()
        self.btnSetImage.makeRoundView()
        self.imgviewPromotion.makeBorder(APPCOLOR.Default_YELLOW_TRANS, borderWidth: 2)
    }
    
    @IBAction func onPressSetImage(sender: AnyObject) {
        self.txtDescription.resignFirstResponder()
        self.openActionSheetForLocal()
    }
    
    @IBAction func onPressPost(sender: AnyObject) {
        if selectedImage != nil && self.txtDescription.text.characters.count > 0 {
            let imageFile = PFFile(data: UIImageJPEGRepresentation(selectedImage!, 0.8)!, contentType: "image/jpg")
            
            SVProgressHUD.showProgress(0)
            imageFile.saveInBackgroundWithBlock({ (successFile: Bool, errorFile: NSError?) in
                if successFile {
                    SVProgressHUD.show()
                    
                    let promotion = MEParsePromotions()
                    promotion.photo = imageFile
                    promotion.userId = MEParseUser.currentUser()!
                    promotion.setObject(self.txtDescription.text, forKey: FIELDNAME.Promotitons_description)
                    promotion.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                        if success {
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            self.showError(error!, complete: nil)
                        }
                        SVProgressHUD.dismiss()
                    })
                } else {
                    self.showError(errorFile!, complete: {
                        SVProgressHUD.dismiss()
                    })
                }
                }, progressBlock: { (progress: Int32) in
                    SVProgressHUD.showProgress(Float(progress) / 100.0)
            })

        } else {
            self.showSimpleAlert("Warning", Message: "Please add description and promotion image.", CloseButton: "OK", Completion: nil)
        }
    }
    
    // MARK: - UITableView datasource
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            let screenWidth = UIScreen.mainScreen().bounds.size.width
            return screenWidth + 80
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    // MARK: - ImagePicker
    private func openActionSheetForLocal() -> Void {
        let actionSheet = UIAlertController(title: "Select Resource", message: nil, preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "From Camera", style: .Default) { (action: UIAlertAction) in
            self.openStandardImagePicker(kUTTypeImage as String, sourceType: .Camera)
        }
        let albumAction = UIAlertAction(title: "From Album", style: .Default) { (action: UIAlertAction) in
            self.openStandardImagePicker(kUTTypeImage as String, sourceType: .PhotoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action: UIAlertAction) in
            
        }
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true) {
            
        }
    }
    
    private func openStandardImagePicker(mediaType: String, sourceType: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType;
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = [mediaType]
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = image
            self.imgviewPromotion.image = selectedImage
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Alert
    private func showError(error: NSError, complete:(() -> Void)?) {
        self.showSimpleAlert("Error", Message: error.localizedDescription, CloseButton: "Close", Completion: complete)
    }

}
