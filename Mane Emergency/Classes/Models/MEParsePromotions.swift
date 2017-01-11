//
//  MEParsePromotions.swift
//  Mane Emergency
//
//  Created by Oleg on 9/10/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse

class MEParsePromotions: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return TABLENAME.Promotions
    }
    
    @NSManaged var userId: MEParseUser
    @NSManaged var photo: PFFile?
//    @NSManaged var description: String?
    
}
