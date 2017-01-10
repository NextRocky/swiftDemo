//
//  NRDVisitor.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/9.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
import SnapKit
class NRDVisitor: UIView {

    //  闭包回传
    var closure: (() -> ())?
    
    
    //  旋转ImageView
    private lazy var cycleImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //  遮挡ImageView
    private lazy var maskImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    //  主页图片
    private lazy var homeImageView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "关注一些人，回这里看看有什么惊喜关注一些人，回这里看看有什么惊喜"
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        label.textColor = UIColor.grayColor()
        label.numberOfLines = 0
        
        return label
    }()
    
    //  注册按钮
    private lazy var registerButton: UIButton = {
       let button = UIButton()
        button.setTitle("注册", forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Normal)
        
        //  添加点击事件
        button.addTarget(self, action: "registerAction", forControlEvents: .TouchUpInside)
        return button
    }()
    //  登入按钮
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("登入", forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: .Highlighted)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Normal)
        
        //  添加点击事件
        button.addTarget(self, action: "loginAction", forControlEvents: .TouchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 设置UI
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpUI () {
        backgroundColor = UIColor(white: 237/255, alpha: 1)
        
        //  添加控件
        addSubview(cycleImageView)
        addSubview(maskImageView)
        addSubview(homeImageView)
        addSubview(label)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 框架添加约束
        cycleImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
        maskImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(cycleImageView)
        }
        homeImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(cycleImageView)
        }
        
        //  label
        label.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(cycleImageView)
            make.top.equalTo(cycleImageView.snp_bottom)
            make.width.equalTo(224)
        }
        
        //  registerButton
        registerButton.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(label.snp_leading)
            make.top.equalTo(label.snp_bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        //  loginButton
        loginButton.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(label.snp_trailing)
            make.top.equalTo(label.snp_bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        

        
//          系统自带的约束
//        settingConstraint()
        
        
    }

    //  registerButton 点击事件
    @objc private func registerAction() {
        print("register")
        
        //  
        closure?()
    }
    //  loginButton 点击事件
    @objc private func loginAction() {
        print("login")
        
        closure?()
    }

    //  开启动画
    private func startAnimation() {
        //  创建动画对象
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //  旋转到的位置
        animation.toValue = 2 * M_PI
        //  重复次数
        animation.repeatCount = MAXFLOAT
        //  转到指定位置所需事件
        animation.duration = 20
        //  动画执行完成不让其释放
        animation.removedOnCompletion = false
        //  添加动画
        cycleImageView.layer.addAnimation(animation, forKey: "key")//  or forKey: nil
    }
    
    
    
    
    
    
    
    
    
    
    
    private func settingConstraint() {
        cycleImageView.translatesAutoresizingMaskIntoConstraints = false
        maskImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //系统自带的约束
        addConstraint(NSLayoutConstraint(item: cycleImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: cycleImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0))
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    //  提供需改的信息
    func updateVisitorPage(changeImageName: String?, changeLabel: String?) {
        if let civ = changeImageName, let cl = changeLabel {
           cycleImageView.hidden = true
            maskImageView.hidden = true
            homeImageView.image = UIImage(named: civ)
            label.text = cl
        }else {
            cycleImageView.hidden = false
            maskImageView.hidden = false
            startAnimation()
        }
    }
    

}
