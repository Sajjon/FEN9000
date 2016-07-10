//
//  NSDate_Extension.swift
//  FEN9000
//
//  Created by Alexander Georgii-Hemming Cyon on 10/07/16.
//  Copyright © 2016 sajjon. All rights reserved.
//

import Foundation

extension NSDate {
    func moreMsLeftThan(milliseconds: Int) -> Bool {
        let millisecondsUntil = millisecondsFrom(NSDate())
        let stillTime = millisecondsUntil > milliseconds
        return stillTime
    }

    func millisecondsFrom(date: NSDate) -> Int {
        let nanoseconds = nanosecondsFrom(date)
        let milliseconds = nanoseconds/1000
        return milliseconds
    }

    func nanosecondsFrom(date: NSDate) -> Int {
        let nanoseconds = NSCalendar.currentCalendar().components(.Nanosecond, fromDate: date, toDate: self, options: []).nanosecond
        return nanoseconds
    }

    func secondsFrom(date: NSDate) -> Int {
        let seconds = NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
        return seconds
    }

    class func future(amount: Int, unit: NSCalendarUnit) -> NSDate {
        return NSDate().add(amount, unit: unit)
    }

    func add(amount: Int, unit: NSCalendarUnit) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(unit, value: amount, toDate: self, options: [])!
    }
}
