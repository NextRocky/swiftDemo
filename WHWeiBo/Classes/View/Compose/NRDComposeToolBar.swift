//
//  NRDComposeToolBar.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/19.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

enum stackType: Int {
    //  图片
    case Picture = 0
    //  @
    case Mention = 1
    //  话题
    case Trend = 2
    //  表情
    case Emoticon = 3
    //  添加
    case Add = 4
}


@available(iOS 9.0, *)
class NRDComposeToolBar: UIStackView {

    private var button: UIButton?
    var callBack: ((type: stackType) -> ())?
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        //  横向
        axis = .Horizontal
    
        //  横向相等填充
        distribution = .FillEqually
        
        createButton("compose_toolbar_picture", type: .Picture)
        createButton("compose_mentionbutton_background", type: .Mention)
        createButton("compose_trendbutton_background", type: .Trend)
        button = createButton("compose_emoticonbutton_background", type: .Emoticon)
        createButton("compose_add_background", type: .Add)
    }
    
    private func createButton(imageName: String, type:stackType) -> UIButton  {
        let stackButton = UIButton()
        //  获取枚举的原始值
        stackButton.tag =  type.rawValue
        
        stackButton.setImage(UIImage(named: imageName), forState: .Normal)
        stackButton.setImage(UIImage(named: "\(imageName)_highlighted"), forState: .Highlighted)
        
        stackButton.setBackgroundImage(UIImage(named: "compose_toolbar_background"), forState: .Normal)
        stackButton.adjustsImageWhenHighlighted = false
        
        stackButton.addTarget(self, action: "toolBarButtonAction:", forControlEvents: .TouchUpInside)
        
        addArrangedSubview(stackButton)
        
        return stackButton
    }
    
    
    @objc private func toolBarButtonAction(btn:UIButton) {
        //  将tag 转成枚举值
        let type = stackType(rawValue: btn.tag)!
        callBack!(type: type)
        
    }
    func changeEmojiButtonImage(change:Bool) {
        if change {
            button?.setImage(UIImage(named: "compose_keyboardbutton_background"), forState: .Normal)
            button!.setImage(UIImage(named: "compose_keyboardbutton_background_highlighted"), forState: .Highlighted)
        }else {
            button?.setImage(UIImage(named: "compose_emoticonbutton_background"), forState: .Normal)
            button!.setImage(UIImage(named: "compose_emoticonbutton_background_highlighted"), forState: .Highlighted)
        }
    }
}


