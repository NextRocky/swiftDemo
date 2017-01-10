//
//  NRDWelcomeViewController.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/12.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit
class NRDWelcomeViewController: UIViewController {
    // 背景图片
    private lazy var bgImage:UIImageView = {
        //  设置图片
       let bgImage = UIImageView(image: UIImage(named: "ad_background"))
        return bgImage
    }()
    
    //  头像
    private lazy var icon:UIImageView = {//ad_background//avatar_default_big
        //  头像
        let iconImage = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        //  存在urlString 是否存在
        if let urlString = NRDUserAccountViewModel.sharedUserAccountViewModel.userInfos?.avatar_large  {

            //  网络加载头像
            iconImage.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named: "avatar_default_big"))
            
        }
        //  设置圆角
        iconImage.layer.cornerRadius = 42.5
        iconImage.layer.masksToBounds = true
    
        return iconImage
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
       
        if let name = NRDUserAccountViewModel.sharedUserAccountViewModel.userInfos?.name {
            label.text = "欢迎回来,\(name)"
        }else {
             label.text = "欢迎来到微博"
        }
        label.textColor = UIColor.grayColor()
        label.alpha = 0
        return label
    }()
    
    override func loadView() {
        view = bgImage
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //  开始动画
        startAnimate()
    }
    
    private func setUpUI() {
        view.addSubview(icon)
        view.addSubview(welcomeLabel)
        
        
        //  添加约束
        icon.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(222)
            make.centerX.equalTo(view)
            make.size.equalTo(CGSizeMake(85, 85))
        }
        
        welcomeLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.icon.snp_bottom).offset(20)
            make.centerX.equalTo(self.icon)
            
        }
    }
    private func startAnimate () {
        
        //  重新更新约束
        icon.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(view).offset(100)
        }
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            
           
        
        //  添加动画
//        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            //  重新刷新布局
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                //  头像移动完成后
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    //  透明度变成1
                    self.welcomeLabel.alpha = 1
                    }, completion: { (_) -> Void in
                        //  发送通知修改根控制器
                        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootVCNotification , object: nil);
                })
        }
        
    }

}
