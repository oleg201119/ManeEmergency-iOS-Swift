//
//  MEAvailabilityCalendarView.swift
//  Mane Emergency
//
//  Created by Oleg on 9/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import Foundation

func > (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == .OrderedDescending
}

extension NSCalendar {
    func dateRange(startDate startDate: NSDate, endDate: NSDate, stepUnits: NSCalendarUnit, stepValue: Int) -> DateRange {
        let dateRange = DateRange(calendar: self, startDate: startDate, endDate: endDate, stepUnits: stepUnits, stepValue: stepValue, multiplier: 0)
        return dateRange
    }
}

struct DateRange : SequenceType {
    
    var calendar: NSCalendar
    var startDate: NSDate
    var endDate: NSDate
    var stepUnits: NSCalendarUnit
    var stepValue: Int
    private var multiplier: Int
    
    func generate() -> Generator {
        return Generator(range: self)
    }
    
    struct Generator: GeneratorType {
        
        var range: DateRange
        
        mutating func next() -> NSDate? {
            guard let nextDate = range.calendar.dateByAddingUnit(range.stepUnits,
                                                          value: range.stepValue * range.multiplier,
                                                         toDate: range.startDate,
                                                        options: []) else {
                return nil
            }
            if nextDate > range.endDate {
                return nil
            }
            else {
                range.multiplier += 1
                return nextDate
            }
        }
    }
}

/*
// Usage:
func testDateRange() {
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let startDate = NSDate(timeIntervalSinceNow: 0)
    let endDate = NSDate(timeIntervalSinceNow: 24*60*60*7-1)
    let dateRange = calendar.dateRange(startDate: startDate,
                                       endDate: endDate,
                                       stepUnits: .Day,
                                       stepValue: 1)
    let datesInRange = Array(dateRange)
//    XCTAssertEqual(datesInRange.count, 7, "Expected 7 days")
//    XCTAssertEqual(datesInRange.first, startDate, "First date should have been the start date.")
}
 */
