//
//  NRDUser.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/13.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDUser: NSObject {

    //  关注用户名称
    var screen_name: String?
    //  关注用户的头像
    var profile_image_url: String?
    //  认证
    var verified_type: Int = 0
    //  vip
    var mbrank: Int = 0
    
    init(dic: [String: AnyObject]) {
        super.init()
        //  kvc
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
