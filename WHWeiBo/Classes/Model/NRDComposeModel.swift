//
//  NRDComposeModel.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/17.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDComposeModel: NSObject {

    //  自定义类名
    var className: String?
    //  图片名
    var icon: String?
    //  标题
    var title: String?
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
