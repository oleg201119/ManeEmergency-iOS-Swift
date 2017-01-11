//
//  MEHairStyle.swift
//  Mane Emergency
//
//  Created by Oleg on 9/6/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse

class MEParseHairStyle: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return TABLENAME.HairStyle
    }
    
    @NSManaged var userId: MEParseUser
    @NSManaged var photo: PFFile?

}
