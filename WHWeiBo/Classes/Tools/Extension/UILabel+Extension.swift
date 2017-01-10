//
//  UILabel+Extension.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/13.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
extension UILabel {
    convenience init(title: String, textFont: CGFloat) {
        self.init()
        text = title
//        textColor = UIColor.whiteColor()
        textColor = UIColor.grayColor()
        font = UIFont.systemFontOfSize(textFont)
    }
}
