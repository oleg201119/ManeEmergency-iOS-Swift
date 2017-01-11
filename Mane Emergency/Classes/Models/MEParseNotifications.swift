//
//  MEParseNotifications.swift
//  Mane Emergency
//
//  Created by Oleg on 9/6/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse

class MEParseNotifications: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return TABLENAME.Notifications
    }
    
    @NSManaged var date: String?
    @NSManaged var toUser: MEParseUser
    @NSManaged var fromUser: MEParseUser
    @NSManaged var date_time: NSTimeInterval
    
}
