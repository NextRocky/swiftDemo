    //
//  NRDTabBarItem.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/14.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDTabBarItem: UITabBarItem {

    override var badgeValue: String? {
        didSet {
            
            /*
             *获取他的tabarController
             *
             */
            //  获取application对象
            let tabBarController = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
            
            //  遍历所有的子控件
            for valus in tabBarController.tabBar.subviews {

                //  新寻找第一层
                if valus.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                    for valusChild in valus.subviews {
                        
                //  寻找第二层
                if valusChild.isKindOfClass(NSClassFromString("_UIBadgeView")!) {
                    for valusChildChild in valusChild.subviews {
                                
                //  寻找第三层
                if valusChildChild.isKindOfClass(NSClassFromString("_UIBadgeBackground")!) {
                    print("找到了")
                    //  统计成员变量有多少个
                    var count: UInt32 = 0
                    //  获取成员列表--<相当一个数组
                    //  <#T##outCount: UnsafeMutablePointer<UInt32>##UnsafeMutablePointer<UInt32>#> 用来存放成员变量个数的
                    let  ivars = class_copyIvarList(NSClassFromString("_UIBadgeBackground"), &count)
                    //  遍历成员名称
                    for i in 0..<count {
                        //  获取自定成员
                        let ivar = ivars[Int(i)]
                        //  获取成员名字
                        let name = ivar_getName(ivar)
                        let type = ivar_getTypeEncoding(ivar)
                        //  转码成字符串
                        let itemName = String(CString: name, encoding: NSUTF8StringEncoding)
                        let itemType = String(CString: type, encoding: NSUTF8StringEncoding)
                        
                        print(itemName)
                        print(itemType)
                        //  判断
                        if itemName == "_image" {
                            valusChildChild.setValue(UIImage(named: "yuan"), forKey: "_image")
                        }
                        
                    }
                    
                                    
                                    
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
    }

    
}
