//
//  NRDStatusPic_urls.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/15.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDStatusPic_urls: NSObject {

    var thumbnail_pic: String?
    
    //  重载
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

    
    
}
