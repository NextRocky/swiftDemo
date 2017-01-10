//
//  NRDComposeTextView + Extension.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/22.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

extension NRDComposeTextView {
    var emoticonString: String {
        //  定义可变字符串
        var result = ""
        //  文本range
        /*  1.range根据指定的范文遍历富文本
         *  2.infosDic 遍历出来的内容
         *  3.nrdRange遍历出来的内容的范围
         */
        let range = NSMakeRange(0, self.attributedText.length)
        self.attributedText.enumerateAttributesInRange(range, options: []) { (infosDic, nrdRange, _) -> Void in
            
            if let attachment = infosDic["NSAttachment"] as? NRDTextAttachment {
                //  是图片
                //  获取图片的文字
                let chs = attachment.emoticonList!.chs!
                result += chs
            }else {
                //  通过文字范围获取文字并转换成String的类型
                let emoticonText = self.attributedText.attributedSubstringFromRange(nrdRange).string
                result += emoticonText
            }
        }
        
        
        return result
    }
    
    
    func insertAttribute(emoticon: NRDEmoticonList) {
        //
        if emoticon.type == "0" {
            //  text = ...//  是能单一文本一只被替换
            //  插入多个文本,不会被替换
            //insertText(text!)
            //  定义个可变的富文本
            let  originalAttributeStr = NSMutableAttributedString(attributedString: self.attributedText)
            //  1.获取图片
//            let imageName = emoticon.path!
//            //  2.创建一个文本附件
//            let attachment = NRDTextAttachment()
//            
//            attachment.image = UIImage(named: imageName)
//            //  设置表情模型
//            attachment.emoticonList = emoticon
//            
//            //  获取文本字体的高度
//            let fontHeight = self.font!.lineHeight
//            //  设置文本附件的高度
//            attachment.bounds = CGRectMake(0, -4, fontHeight, fontHeight)
//            
//            
//            //  3.通过attachment 创建一个富文本(不可变的)
//            let emoticonAttributeStr = NSAttributedString(attachment: attachment)
            
            //  4.组合成完整的富文本
            //            originalAttributeStr.appendAttributedString(emoticonAttributeStr)
            //  3.通过attachment 创建一个富文本(不可变的)
            let emoticonAttributeStr = NSAttributedString.attributedStringByEmoticon(emoticon, font: font!)
            
            //  获取textView被选中的区域
            var range = self.selectedRange
            
            //  根据选中的范围替换富文本
            originalAttributeStr.replaceCharactersInRange(range, withAttributedString: emoticonAttributeStr)
            
            //  5.指定富文本的大小
            originalAttributeStr.addAttribute(NSFontAttributeName, value: self.font!, range: NSMakeRange(0, originalAttributeStr.length))
            
            
            //  给自己的富文本赋最新的富文本
            self.attributedText = originalAttributeStr
            
            //  设置光标的位置
            range.location += 1
            range.length = 0
            self.selectedRange = range
            
            
            
            
            //  发送通知textView已经被改变, 隐藏placeHoldel
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: nil)
            //  调用代理方法,开启右边button.enable的状态
            self.delegate?.textViewDidChange!(self)
            
        }else {
            
            
            //  写入文本
            self.insertText((emoticon.code! as NSString).emoji())
        }

    }
}