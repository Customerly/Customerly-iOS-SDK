//
//  CyDate.swift
//  Customerly
//
//  Created by Paolo Musolino on 28/11/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

extension Date {
    
    static func timeAgoSinceUnixTime(unix_time: Double, currentDate: Date) -> String{
        return timeAgoSinceDate(Date(timeIntervalSince1970:TimeInterval(unix_time)), currentDate: currentDate)
    }
    
    static func timeAgoSinceDate(_ date: Date, currentDate: Date) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            return "\(components.year) year ago"
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            return "\(components.month!) month ago"
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            return "\(components.weekOfYear!) week ago"
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            return "\(components.day!) day ago"
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            return "\(components.hour!) hour ago"
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            return "\(components.minute!) minute ago"
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "just now"
        }
    }
    
}
