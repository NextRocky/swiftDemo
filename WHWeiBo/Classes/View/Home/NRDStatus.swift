//
//  NRDStatus.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/12.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDStatus: NSObject {

    var created_at: String?
    
    var id: Int64 = 0
    
    var text: String?
    
    var source: String?
    
    var user: NRDUser?
    //  转发
    var reposts_count: Int = 0
    //  评论
    var comments_count: Int = 0
    //  表态
    var attitudes_count: Int = 0
    //  转发
    var retweeted_status: NRDStatus?
    //  图片
    var pic_urls:[NRDStatusPic_urls]?
    
    init(Dic: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(Dic)
    }
    
    // MARK: - 特殊赋值
    override func setValue(value: AnyObject?, forKey key: String) {
  
        
       //  给user赋值
       if let dic = value as? [String: AnyObject] {
            if key == "user" {
                //  kvc
                user = NRDUser(dic: dic)
            }else if key == "retweeted_status"{
                
                retweeted_status = NRDStatus(Dic: dic)
            }
        }else if let arr = value as? [[String: AnyObject]]{
        
        if key == "pic_urls" {
        var muArr = [NRDStatusPic_urls]()
        for dic in arr {
            let pic_url = NRDStatusPic_urls(dic: dic)
            muArr.append(pic_url)
        }
        pic_urls = muArr
        }
        
        } else {
        super.setValue(value, forKey: key)
       }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let key = ["created_at", "id", "text", "source", "reposts_count", "attitudes_count"]
        return dictionaryWithValuesForKeys(key).description 
    }
}
