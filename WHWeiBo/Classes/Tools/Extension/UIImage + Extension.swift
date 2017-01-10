//
//  UIImage + Extension.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/19.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
extension UIImage {
    
    func scaleImageWithScaleWidth(scaleWidth: CGFloat) -> UIImage {
        //  获取缩放比例的图片
        let scaleHeight = self.size.height / self.size.width * scaleWidth
        //  开启图片上下文
        UIGraphicsBeginImageContext(CGSizeMake(scaleWidth, scaleHeight))
        //  渲染图片到指定区域
        self.drawInRect(CGRect(origin: CGPointZero, size: CGSizeMake(scaleWidth, scaleHeight)))
        //  从图形上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //  关闭图形上下文
        UIGraphicsEndImageContext()
        return image
        
        
    }
    
    
}
