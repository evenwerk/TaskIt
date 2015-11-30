//
//  Date.swift
//  TaskIt
//
//  Created by Tim Even on 11-03-15.
//  Copyright (c) 2015 evenwerk. All rights reserved.
//

import Foundation

class Date {
    class func from (year year:Int, month:Int, day:Int) -> NSDate {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        let gregorianCalander = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let date = gregorianCalander.dateFromComponents(components)
        
        return date!
    }
    
    class func toString(date date:NSDate) -> String {
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateStringFormatter.stringFromDate(date)
        
        return dateString
    }
}