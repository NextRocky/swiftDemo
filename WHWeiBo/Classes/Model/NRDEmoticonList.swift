//
//  NRDEmoticonList.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/20.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDEmoticonList: NSObject {
    
    var type: String?
    var png: String?
    var chs: String?
    var path: String?
    // emoji  16进制字符串
    var code: String?
 
    init(dic: [ String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

    override var description: String {
       let key = ["type", "png", "chs", "path"]
        return dictionaryWithValuesForKeys(key).description
    }
}
