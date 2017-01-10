//
//  NRDTabBar.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/9.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit



protocol  NRDTabBarDelegate: NSObjectProtocol {
    func didSelectComposeButton()
}

class NRDTabBar: UITabBar {

    
    //  代理方法
    weak var  NRDDelegate: NRDTabBarDelegate?
    
    var addClosure:(() -> ())?
    private lazy var composeButton: UIButton = {
        //  创建button
        let button = UIButton()
        
        //  设置图片
        button.setImage(UIImage(named: "tabbar_compose_icon_add" ), forState: .Normal)
        button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: .Highlighted)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: .Highlighted)
        button.sizeToFit()
        
        button.addTarget(self, action: "addAction", forControlEvents: .TouchUpInside)
        return button
    }()
    
    //重写方法--创建对象
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }

    // MARK -- xib相关
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置tableBar
    func setUpUI() {
        addSubview(composeButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //  设置分类
        composeButton.centerX = width * 0.5
        composeButton.centerY = height * 0.5
        
        
        //  设置tabBarItem的宽度
        let itemWidth = width / 5
        //  索引
        var index = 0
        //  遍历subviews
        for value in subviews {
                //  判断是否是同一个类
            if value.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                
                //  设置宽度
                value.width = itemWidth
                //  设置位置
                value.x = CGFloat(index) * itemWidth
                if index == 1{
                    index++
                }
                index++
            }
            
        }
    }
    
    @objc func addAction() {
        print("add")
        
        addClosure!()
        NRDDelegate?.didSelectComposeButton()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
