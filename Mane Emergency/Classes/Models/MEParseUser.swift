//
//  MEParseUser.swift
//  Mane Emergency
//
//  Created by Oleg on 9/8/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Parse

class MEParseUser: PFUser {
    
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var bio: String?
    @NSManaged var expired_date: NSTimeInterval
    @NSManaged var price: Int
    @NSManaged var rate: Float
    @NSManaged var purchase: Int
    @NSManaged var profile: PFFile?
    @NSManaged var isStylist: Bool
    @NSManaged var zipCode: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var availability_date_time: NSTimeInterval
    
}
