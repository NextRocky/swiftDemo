//
//  NRDKeyBoardToolBar.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/20.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

enum keyBoardEmoticonType: Int {
    case Default = 0
    case Emoji = 1
    case Lxh = 2
    
}


class NRDKeyBoardToolBar: UIStackView {

    var keyBoardToolBarClosure: ((enumType: keyBoardEmoticonType) -> ())?
    
    var scrollButton: UIButton?
    //  计入点击的button
    var ClickButton:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        tag = 3
        //  布局横向
        axis = .Horizontal
        //  等比填充
        distribution = .FillEqually
        
        ClickButton = addButton("compose_emotion_table_left",title: "默认",type: .Default)
        ClickButton?.selected = true
        addButton("compose_emotion_table_mid",title: "emoji", type: .Emoji)
        addButton("compose_emotion_table_right",title: "浪小花", type: .Lxh)
    }
    //  compose_emotion_table_left_normal
    private func addButton(imageName: String, title: String, type:keyBoardEmoticonType) -> UIButton {
    
        let button = UIButton()
        //  枚举值转换tag值
        button.tag = type.rawValue
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Selected)
        button.setBackgroundImage(UIImage(named: imageName + "_normal"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: imageName + "_selected"), forState: .Selected)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: "emoticonBttonAction:", forControlEvents: .TouchUpInside)
        
        addArrangedSubview(button)
        
        return button
    }
    @objc private func emoticonBttonAction(sender: UIButton) {
        
        print(sender.tag);
            //  不是同一个button
            if ClickButton == sender
            {
               
             return
            }
        //  取消高亮状态
        ClickButton?.selected = false
        sender.selected = true
        //  保存上一个button
        ClickButton = sender
        //  将tag 值转换成枚举值
        let enumType = keyBoardEmoticonType(rawValue: sender.tag)
        keyBoardToolBarClosure!(enumType: enumType!)
    }
    
    func scrollChangeButtonWithIndexPath(indexPath: NSIndexPath){

        // scrollButton ClickButton 可以设置同一个
        print(indexPath.section)
         // 通过indexpath,得到tag值然后获取button
        let button = viewWithTag(indexPath.section ) as? UIButton
        //  判断 是否是同意个button 同一个就不执行任何炒作
        if scrollButton == button {
            return
        }
        //  上一个button取消选中的状态
        scrollButton?.selected = false
        //  当前button设置为选中状态
        button?.selected = true
        //  记录button
        scrollButton = button
    }
    
    
}
