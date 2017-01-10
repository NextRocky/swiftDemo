//
//  NSAttributedString + Extension.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/24.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    
    class  func attributedStringByEmoticon(emoticon:NRDEmoticonList, font: UIFont) -> NSAttributedString {
        //  创建文本附件
        let attachment = NRDTextAttachment()
        attachment.image = UIImage(named: emoticon.path!)
        //  模型赋值
        attachment.emoticonList = emoticon
        //  设置行高
        let fontHeight = font.lineHeight
        attachment.bounds = CGRectMake(0, -4, fontHeight,fontHeight )
        
        let attributedString = NSAttributedString(attachment: attachment)
        return attributedString
        
        
    }
}
