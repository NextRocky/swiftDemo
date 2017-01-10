//
//  NRDStatusViewModel.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/13.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
let HomeFontSize: CGFloat = 15
class NRDStatusViewModel: NSObject {
    
    //  微博内容AttributedString
    var OriginalattributedString: NSAttributedString?
    //  转发微博的AttributedString
    var retweetAttributedStr: NSAttributedString? {
        return handleRetweetContent(status?.retweeted_status)
    }
    //  转发
    var repostsStr: String?
    //  评论
    var commentsStr: String?
    //  表态
    var attitudesStr: String?
    //  vip
    var mbRankImage: UIImage?
    //  source
    var sourceStr: String?
    //  认证
    var verified_typeImage: UIImage?
    //  微博时间
    var time: String? {
        
        guard let createTime = self.status?.created_at else {
            return nil
        }
//        print(createTime)
        
        
        return NSDate.thisTime(createTime).pastTime
    }
    
//      get方法 可以调用系统函数
//        {
//        return handleCount(<#T##count: Int##Int#>, title: <#T##String#>)
//    }
    
//    var retweetContentStr: String? {
//     
//        return handleRetweetContent(status?.retweeted_status)
//        
//    }
    
    //
    var status: NRDStatus?
    
    init(status: NRDStatus) {
        super.init()
        //  中转--模型嵌套
        self.status = status
        //  转发评论表态
        subFunc(status)
        //  vip
        handleMBRank(status.user?.mbrank ?? 0)
        //  source 
        handleSource(status.source )
        //  verified_type--认证
        handleVerified_type(status.user?.verified_type ?? 0)
        
        OriginalattributedString = handleAttributeString(status.text!)
    }
    
    // MARK: - 认证
    private func handleVerified_type(verified_type: Int) {
        switch verified_type {
        case 0:
            verified_typeImage = UIImage(named:"avatar_vip")
        case 2,3,5:
            verified_typeImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verified_typeImage = UIImage(named: "avatar_grassroot")
        default:
            verified_typeImage = nil
        }
        
    }
    
    // MARK: - source
    private func handleSource(source: String?) {
        
 
        guard let startString = source!.rangeOfString("\">"),let endString = source!.rangeOfString("</") else {
         
            return
        }
            let startPos = startString.endIndex
            let endPos = endString.startIndex
            sourceStr = "来自" + source!.substringWithRange(startPos..<endPos)

 
    }
    
    // MARK: - vip  转换
    private func handleMBRank (mbRank: Int) {
 
        if mbRank >= 1 && mbRank <= 6 {
            mbRankImage = UIImage(named: "common_icon_membership_level\(mbRank)")

        }
        
    }
    
    // MARK: - 转发评论表态 {
    private func subFunc(status:NRDStatus) {
        ////  转发
        self.repostsStr = handleCount(status.reposts_count, title: "转发")
        //  评论
        self.commentsStr = handleCount(status.comments_count, title: "评论")
        //  表态
        self.attitudesStr = handleCount(status.attitudes_count, title: "赞")
    }
    
    // MARK: - 转发内容
    private func handleRetweetContent(status: NRDStatus? ) -> NSAttributedString? {
        
        if let name = status?.user?.screen_name, let content = status?.text {
        
            return handleAttributeString("@\(name): \(content)")
        }
        return nil
        
    }
    
    //  处理toolbar  个按钮的数据
    private func handleCount(count: Int, title: String) -> String {
        if count > 0 {
            if count >= 10000 {
                let num = CGFloat(count / 1000) / 10
                var str = "\(num)万"
                if str.containsString(".0") {
                    //  包含有.0  就替换成 空
                    str = str.stringByReplacingOccurrencesOfString(".0", withString: "")

               }
                return str
            }else {
                return "\(count)"
            }
        } else {
            return title;
        }

    }

}


extension NRDStatusViewModel {
//    // MARK: - 判断时间
//    //  判断是否是今年
//    private func thisTime(createTime: String ) -> String?{
//        let dt = NSDateFormatter()
//        //  "Sun Jul 17 13:44:53 +0800 2016"
//        dt.dateFormat = "EEE MMM dd HH:mm:ss z yyy"
//        dt.locale = NSLocale(localeIdentifier: "en_US")
//        let createDate = dt.dateFromString(createTime)!
//        
//        //  判断是否是今年
//        if isThisYear(createDate) {
//            //  是今年
//            //  判断是否是今天
//            let calendar = NSCalendar.currentCalendar()
//            //  
//            if calendar.isDateInToday(createDate) {
//                //  是今天
//                //  距离当前时间当前时间多少秒
////                let timeInterval = abs(createDate.timeIntervalSinceDate(NSDate()))
//                //
//                let timeInterval = abs(createDate.timeIntervalSinceNow)
//
//                //  判断是否是一分钟前
//                if timeInterval < 60 {
//                    return "刚刚"
//                }else if timeInterval < 60 * 60 {
//                    return  "\(Int(timeInterval / 60))分钟前"
//                }else {
//                    let hourTime = timeInterval / 60 / 60
//                    return "\(hourTime)小时前"
//                }
//                
//                
//                
//                
//                
//                
//            }else if calendar.isDateInYesterday(createDate) {
//                //  昨天
//                dt.dateFormat = "昨天 HH:mm"
//            }else {
//                //  不是昨天
//                dt.dateFormat = "MM-dd HH:mm"
//            }
//            
//            
//            
//            
//            
//            
//        } else {
//            dt.dateFormat = "yyyy-MM-dd HH:mm"
//        }
//        
//        return dt.stringFromDate(createDate)
//    }
    
    
//    private func isThisYear(createDate: NSDate) -> Bool {
//     
//        //  时间格式化
//        let dt = NSDateFormatter()
//        dt.dateFormat = "yyyy"
//        //  本地设置
//        dt.locale = NSLocale(localeIdentifier:"en_US")
//        //  把时间转换成对象
//        let createYear = dt.stringFromDate(createDate)
//        //  当前时间对象
//        let currentYear = dt.stringFromDate(NSDate())
//        
//        return createYear == currentYear
//    }
    
    //  将微博数据转换成富文本
    func  handleAttributeString(statusText: String) -> NSAttributedString {
        
        //  定义一个富文本  用于记录
        let result = NSMutableAttributedString(string: statusText)

        /**
          *  1.匹配个数
          *  2.匹配内容的指针
          *  3.匹配范围的值
          *  4.是否停止
          */
        var matchArr = [NRDMatchResult]()
        (statusText as NSString).enumerateStringsMatchedByRegex("\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]") { (matchCount, matchString, matchRange, _) -> Void in
            //  memory 是取到指针的内容
            //  转换成string
            if let chs = matchString.memory as? String {
                //  存储matchString ,matchRange
                let range = matchRange.memory
                let matchResult = NRDMatchResult(string: chs, range:range)
                //  模型数组
                matchArr.append(matchResult)
            }
            

        }
        for value in matchArr.reverse() {
            //  查找是否有相应的表情
            if let emoticon = NRDOpenBundleTools.sharedOpenBundleTools.findEmoticnByString(value.matchString) {
                let attributeStr = NSAttributedString.attributedStringByEmoticon(emoticon, font: UIFont.systemFontOfSize(ContentFont))
                //  替换成我们想要的富文本
                result.replaceCharactersInRange(value.matchRange, withAttributedString: attributeStr)
            }
        }
        
      return result
    }
    
    
    
    
    
    
    
}







