//
//  NRDMatchResult.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/24.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
class NRDMatchResult: NSObject {

    //  存放内容
    var matchString: String
    //  存放range
    var matchRange: NSRange
    init(string: String, range: NSRange) {
        matchRange = range
        
        matchString = string
    }
    
}
