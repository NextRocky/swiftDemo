//
//  UITabBarItem+Extension.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/10.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
extension UIBarButtonItem{
    convenience init(title: String, obj: AnyObject, action: Selector) {
        self.init()
        //创建button
        let button = UIButton()
        
        //  设置button 的属性
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.sizeToFit()
        
        //  设置点击事件
        button.addTarget(obj, action: action, forControlEvents: .TouchUpInside)
        customView = button
    }
}