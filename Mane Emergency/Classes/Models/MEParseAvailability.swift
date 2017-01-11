//
//  MEParseAvailability.swift
//  Mane Emergency
//
//  Created by Oleg on 9/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse

class MEParseAvailability: PFObject, PFSubclassing {

    static func parseClassName() -> String {
        return TABLENAME.Availability
    }

//    private var _time: NSTimeInterval?
    @NSManaged var time: NSTimeInterval
//        {
//        get {
//            if _time == nil {
//                return 0
//            } else if String(_time).characters.count > 10 {
//                return _time! / 1000
//            } else {
//                return _time!
//            }
//        }
//    }
    @NSManaged var date: String?
    @NSManaged var userId: MEParseUser
    
    
}
