//
//  MESideMenuController.swift
//  Mane Emergency
//
//  Created by Oleg on 8/31/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import SideMenuController
import Parse

class MESideMenuController: SideMenuController {

    required init?(coder aDecoder: NSCoder) {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "iconMenu")
        SideMenuController.preferences.drawing.sidePanelPosition = .UnderCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 240
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .HorizontalPan
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if appManager().isLoadingFromLogin == true {
            self.appManager().isLoadingFromLogin = false
            self.performSegueWithIdentifier(APPSEGUE.sideMenu, sender: self)
            if let currentUser = MEParseUser.currentUser() {
                
                if currentUser.isStylist == true {
                    self.performSegueWithIdentifier(APPSEGUE.gotoStylistMyProfile, sender: self)
                } else {
                    self.performSegueWithIdentifier(APPSEGUE.gotoSelectStylist, sender: self)
                }
                
                let installation = PFInstallation.currentInstallation()
                installation?.setObject(MEParseUser.currentUser()!.objectId!, forKey: FIELDNAME.Installation_userID)
                installation?.setObject(MEParseUser.currentUser()!, forKey: FIELDNAME.Installation_user)
                installation?.saveInBackground()

                appManager().getRateValueOfUser(currentUser, complete: { (rate: CGFloat) in
                    currentUser.rate = Float(rate)
                    currentUser.saveInBackground()
                })
            } else {
                if appManager().zipcodeForSearch != nil {
                    self.performSegueWithIdentifier(APPSEGUE.gotoSelectStylist, sender: self)
                } else {
                    self.performSegueWithIdentifier(APPSEGUE.gotoLogin, sender: self)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let profileVC = (segue.destinationViewController as? MENavigationController)?.topViewController as? MEProfileVC {
            profileVC.user = MEParseUser.currentUser()!
        }
    }
}
