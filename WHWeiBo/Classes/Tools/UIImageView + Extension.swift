//
//  UIImageView + Extension.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/17.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit 
extension UIImageView {
    class func clipScreenImage() ->UIImageView {
        //  获取主window
        let window = UIApplication.sharedApplication().keyWindow
        //  开启图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(screenWidth, screenHeight))
        //
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(screenWidth,screenHeight), false, 0)
        //
        window?.drawViewHierarchyInRect((window?.bounds)!, afterScreenUpdates: false)
        //  从图形上下文获取图片
        let clipImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        //  关闭图形上下文
        UIGraphicsEndImageContext()
        //  保存本地
        let imageData = UIImagePNGRepresentation(clipImage)
        imageData?.writeToFile("/Users/luoli/Desktop/1.png", atomically: true)
        

        return UIImageView(image: clipImage.applyLightEffect())
    }
    
    
//    var buttonArr: NRDComposButton = {
//       
//        
//        let
//        
//    }()
}