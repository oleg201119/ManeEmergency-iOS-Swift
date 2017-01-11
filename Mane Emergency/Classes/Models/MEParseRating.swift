//
//  MEParseRating.swift
//  Mane Emergency
//
//  Created by Oleg on 9/10/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse

class MEParseRating: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return TABLENAME.Rating
    }
    
    @NSManaged var rate: Float
    @NSManaged var toUser: MEParseUser
    @NSManaged var fromUser: MEParseUser
    @NSManaged var review: String?
    
}
