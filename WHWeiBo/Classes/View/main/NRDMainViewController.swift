//
//  NRDMainViewController.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/9.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
import SVProgressHUD
class NRDMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

      loadVC()
    }
    
    
    func loadVC() {
        
        //自定义的tabbar
        let newTabBar = NRDTabBar()
        /*  1.代理
         *  2.闭包
         *
         */
        setValue(newTabBar, forKey: "tabBar")
        //  闭包
        newTabBar.addClosure = { [weak self] in
            //  判断登入状态
            if NRDUserAccountViewModel.sharedUserAccountViewModel.isLogin {
                //  创建UIView,添加到
                guard let weakSelf = self else {
                    return
                }
                //  一定有控制器
                let composeView = NRDCompos()
                //  show
                composeView.show(weakSelf)
            }else {
                //  没有登入就先登入
                SVProgressHUD.showWithStatus("请先登入")
            }
        }
        //代理
        newTabBar.NRDDelegate = self
        
        //  1.homeVC
        addChildViewController(NRDHomeTableViewController(), isTiltes: "首页", imageName: "tabbar_home")
        
        //  2.message
        addChildViewController(NRDMessageTableViewController(), isTiltes: "消息", imageName: "tabbar_message_center")
        
        //  3.discover  
        addChildViewController(NRDDiscoverTableViewController(), isTiltes: "发现", imageName: "tabbar_discover")
        
        //  4.profile   
        addChildViewController(NRDProfileTableViewController(), isTiltes: "我的", imageName: "tabbar_profile")
        
        
    }

    //  重载
    private func addChildViewController(childController: UIViewController, isTiltes: String, imageName: String ) {
        //  设置标题
        childController.title = isTiltes
        
        //  自定义的tabBarItem
        childController.tabBarItem = NRDTabBarItem()
        
        //  设置UITabbarItem
        childController.tabBarItem.image = UIImage(named: imageName)
        
        /*  设置图片的渲染方式
        *    >1.UITabBar.appearance().tintColor = UIColor.orangeColor()//放置在appDelegate
        *    >2.UIImage(named: imageName + "_selected")?.imageWithRenderingMode(.AlwaysOriginal)
        *    >3.图片放置区域 1.选中-Assets.xcassets  2.选中相应图片 3.设置属性区域第三个图片 4.打开 image set
        *        5.选中 render as 6.设置原色
        */
        //  设置被选中的图片
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")?.imageWithRenderingMode(.AlwaysOriginal)
        
        //  设置tabbar的字体颜色
        childController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()] , forState: .Selected)
        
        //  创建navController
        let nav = NRDNavigationController(rootViewController: childController)
        
        //  添加到UITabbarController控制器
        addChildViewController(nav)
    }


}

extension UITabBarController: NRDTabBarDelegate {
    func didSelectComposeButton() {
     print("代理")
    }
}
