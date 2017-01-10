//
//  CommonTools.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/12.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

//  切换根视图控制器通知名
let SwitchRootVCNotification = "SwitchRootVCNotification"

let screenWidth = UIScreen.mainScreen().bounds.size.width
let screenHeight = UIScreen.mainScreen().bounds.size.height
//  随机色
func randomColor() -> UIColor {
    //  随机值
    let red = random() % 256
    let green = random() % 256
    let blue = random() % 256

    
    return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
}


//  如果函数参数提供默认值,则可以省略不传入这个参数
func printLog(file: String = __FILE__, funcName: String = __FUNCTION__, line: Int = __LINE__) {
    //    __FUNCTION__ // swift 3.0 改成#function
    //    __LINE__     //             #line
    //    __FILE__    //                 #file
    //
    
    #if DEBUG
        
        print("\((file as NSString).lastPathComponent)[\(line)], \(funcName)")
        
        
    #endif
    
    
}
