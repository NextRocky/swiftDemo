//
//  NSDate + Extension.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/17.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

extension NSDate {
    class func thisTime(createTime: String) -> NSDate {
        let dt = NSDateFormatter()
        ////  "Sun Jul 17 13:44:53 +0800 2016"
        dt.dateFormat = "EEE MM dd HH:mm:ss z yyyy"
        dt.locale = NSLocale(localeIdentifier: "en_US")
        return dt.dateFromString(createTime)!
    }
    
    var pastTime: String {
        let dt = NSDateFormatter()
        //  "Sun Jul 17 13:44:53 +0800 2016"
//        dt.dateFormat = "EEE MMM dd HH:mm:ss z yyy"
        dt.locale = NSLocale(localeIdentifier: "en_US")
//        let createDate = dt.dateFromString(self)!
        
        //  判断是否是今年
        if isThisYear(self) {
            //  是今年
            //  判断是否是今天
            let calendar = NSCalendar.currentCalendar()
            //
            if calendar.isDateInToday(self) {
                //  是今天
                //  距离当前时间当前时间多少秒
                //                let timeInterval = abs(createDate.timeIntervalSinceDate(NSDate()))
                //
                let timeInterval = abs(self.timeIntervalSinceNow)
                
                //  判断是否是一分钟前
                if timeInterval < 60 {
                    return "刚刚"
                }else if timeInterval < 60 * 60 {
                    return  "\(Int(timeInterval / 60))分钟前"
                }else {
                    let hourTime = timeInterval / 60 / 60
                    return "\(hourTime)小时前"
                }
                
                
                
                
                
                
            }else if calendar.isDateInYesterday(self) {
                //  昨天
                dt.dateFormat = "昨天 HH:mm"
            }else {
                //  不是昨天
                dt.dateFormat = "MM-dd HH:mm"
            }
            
            
            
            
            
            
        } else {
            dt.dateFormat = "yyyy-MM-dd HH:mm"
        }
        
        return dt.stringFromDate(self)
    }
    
    private func isThisYear(createDate: NSDate) -> Bool {
        
        //  时间格式化
        let dt = NSDateFormatter()
        dt.dateFormat = "yyyy"
        //  本地设置
        dt.locale = NSLocale(localeIdentifier:"en_US")
        //  把时间转换成对象
        let createYear = dt.stringFromDate(createDate)
        //  当前时间对象
        let currentYear = dt.stringFromDate(NSDate())
        
        return createYear == currentYear
    }
}
