 //
//  AppDelegate.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/9.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        
        
        
        /*
           // 字符串转变对象
        */
        
        
//        let vc = NSClassFromString("WHWeiBo.NRDHomeTableViewController") as? UIViewController.Type
//        
//        let newVC = vc!.init()
//        
//        print(newVC)
        
        let userInfo = NRDUserAccount().loadUserInfos()
        print(userInfo)
        
        //  创建window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //  创建根控制器
//        let mainTabbarController = NRDMainViewController()
        let mainTabbarController = NRDWelcomeViewController()
        
        //  统一设置tabar的渲染
//        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        //  设置根控制器
        window?.rootViewController = mainTabbarController
        //  接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToLoginPage:", name: SwitchRootVCNotification , object:nil )
        
        //  设置为主控制器并显示
        window?.makeKeyAndVisible()
        
   
        return true
    }

    @objc private func goToLoginPage(noti:NSNotification) {
        let object = noti.object

//        NRDUserAccountViewModel.sharedUserAccountViewModel.isLogin//不能用做判断条件 登入成功后会反复执行登入界面
        if object is NRDWebViewController {

            //  登入后会到欢迎页面
            window?.rootViewController = NRDWelcomeViewController()
        }else{

            //  进入主界面
            window?.rootViewController = NRDMainViewController()
        }
        
    }
    
    
    
    
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}

