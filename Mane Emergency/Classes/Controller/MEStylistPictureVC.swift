//
//  MEStylistPictureVC.swift
//  Mane Emergency
//
//  Created by Oleg on 9/2/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse
import SVProgressHUD

class MEStylistPictureVC: MECollectionViewController, MEStylistPhotoCellDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var selectedPicture: MEParseHairStyle?
    private var hairStyles : [MEParseHairStyle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadHairStyles()
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.navigationController?.addSideMenuButton()
        
        
    }
    
    private func loadHairStyles() {
        SVProgressHUD.show()
        let query = MEParseHairStyle.query()!
        query.whereKey(FIELDNAME.HairStyle_userId, equalTo: MEParseUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (result: [PFObject]?, error: NSError?) in
            if error == nil {
                self.hairStyles = result as! [MEParseHairStyle]
                self.collectionView?.reloadData()
            } else {
                self.showError(error!, complete: nil)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - UICollectionView
    // MARK: Layout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = collectionView.frame.size
        let unitWidth = screenSize.width / 3 - 1
        let cellSize = CGSizeMake(unitWidth, unitWidth)
        return cellSize
    }
    
    // MARK: Datasource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (checkPurchase() == true && hairStyles.count < 10) ||
            (checkPurchase() == false && hairStyles.count < 7)
        {
            return hairStyles.count + 1
        } else {
            return hairStyles.count
        }
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row >= hairStyles.count {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddPhotoCell", forIndexPath: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MEStylistPhotoCell.cellIdentifier(), forIndexPath: indexPath) as! MEStylistPhotoCell
            cell.delegate = self
            cell.hairStyle = hairStyles[indexPath.row]
            addGestureForFullScreenImage(cell.imgviewPhoto)
            return cell
        }
    }
    
    // MARK: delegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == hairStyles.count {
            if (checkPurchase() == true && hairStyles.count < 10) ||
               (checkPurchase() == false && hairStyles.count < 7)
            {
                self.selectedPicture = nil
                self.openActionSheetForLocal()
            }
            
        }
    }
    
    // MARK: - Check permission and able
    
    private func checkLimit() -> Bool {

        return true
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
            let imageFile = PFFile(data: UIImageJPEGRepresentation(image, 0.8)!, contentType: "image/jpg")
            
            imageFile.saveInBackgroundWithBlock({ (successFile: Bool, errorFile: NSError?) in
                if successFile {
                    SVProgressHUD.show()
                    let completion = { (success: Bool, object: MEParseHairStyle?, error: NSError?) in
                        if success {
                            if object != nil {
                                self.hairStyles.append(object!)
                            }
                            self.collectionView?.reloadData()
                        } else {
                            self.showError(error!, complete: nil)
                        }
                        SVProgressHUD.dismiss()
                    }

                    if self.selectedPicture == nil {
                        let hairStyle = MEParseHairStyle()
                        hairStyle.photo = imageFile
                        hairStyle.userId = MEParseUser.currentUser()!
                        hairStyle.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                            completion(success, hairStyle, error)
                        })
                    } else {
                        self.selectedPicture?.photo = imageFile
                        self.selectedPicture?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                            completion(success, nil, error)
                        })
                    }
                } else {
                    self.showError(errorFile!, complete: { 
                        SVProgressHUD.dismiss()
                    })
                }
            }, progressBlock: { (progress: Int32) in
                    SVProgressHUD.showProgress(Float(progress) / 100.0)
            })

        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - MEStylistPhotoCell Delegate
    func MEStylistPhotoCellEditPhoto(cell: MEStylistPhotoCell) {
        self.selectedPicture = cell.hairStyle
        self.openActionSheetForLocal()
    }
    
    func MEStylistPhotoCellDeletePhoto(cell: MEStylistPhotoCell) {
        let hairStyle = cell.hairStyle
        if let index = self.hairStyles.indexOf(hairStyle) {
            SVProgressHUD.show()
            hairStyle.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                SVProgressHUD.dismiss()
                if error == nil {
                    self.hairStyles.removeAtIndex(index)
                    self.collectionView?.reloadData()
                } else {
                    self.showError(error!, complete: nil)
                }
            })
        }
    }
    
    // MARK: - Alert
    private func showError(error: NSError, complete:(() -> Void)?) {
        self.showSimpleAlert("Error", Message: error.localizedDescription, CloseButton: "Close", Completion: complete)
    }
}
