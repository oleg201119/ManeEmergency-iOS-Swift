//
//  MEFollow.swift
//  Mane Emergency
//
//  Created by Oleg on 9/7/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse

class MEParseFollow: PFObject , PFSubclassing {
    
    static func parseClassName() -> String {
        return TABLENAME.Follow
    }
    
    @NSManaged var toUser: MEParseUser
    @NSManaged var fromUser: MEParseUser
    
}
