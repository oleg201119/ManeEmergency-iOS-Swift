//
//  MEStylistPhotoCell.swift
//  Mane Emergency
//
//  Created by Oleg on 9/13/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse
import ParseUI

class MEStylistPhotoCell: MECollectionViewCell {

    class func cellIdentifier() -> String {
        return "MEStylistPhotoCell"
    }
    
    @IBOutlet weak var imgviewPhoto: PFImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var delegate: MEStylistPhotoCellDelegate?
    
    @IBAction func onPressEdit(sender: AnyObject) -> Void {
        delegate?.MEStylistPhotoCellEditPhoto(self)
    }
    
    @IBAction func onPressDelete(sender: AnyObject) -> Void {
        delegate?.MEStylistPhotoCellDeletePhoto(self)
    }
    
    private var _hairStyle: MEParseHairStyle!
    var hairStyle: MEParseHairStyle {
        set {
            _hairStyle = newValue
            self.imgviewPhoto.image = nil
            self.imgviewPhoto.file = newValue.photo
            self.imgviewPhoto.loadInBackground()
            
        }
        get {
            return _hairStyle
        }
    }
}

protocol MEStylistPhotoCellDelegate {
    func MEStylistPhotoCellEditPhoto(cell: MEStylistPhotoCell) -> Void
    func MEStylistPhotoCellDeletePhoto(cell: MEStylistPhotoCell) -> Void
}