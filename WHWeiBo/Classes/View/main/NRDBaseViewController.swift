//
//  NRDBaseViewController.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/9.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDBaseViewController: UITableViewController {

    //访客视图
    var visitorView:NRDVisitor?
    //是否登入标记
    var login: Bool = NRDUserAccountViewModel.sharedUserAccountViewModel.isLogin
    
    override func loadView() {
        
        if login {
            //  登入成功
            super.loadView()
        }
        else
        {
            //   未登入
            visitorView = NRDVisitor()
            visitorView?.closure = { [weak self] in
//                print("注册或者是登入")
                //  webVC
                self!.presentwebController();
            }
            //   设置为未登入的view
            view = visitorView
            //   未登入设置
            setNav()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    private func setUpUI() {
        
    }
    private func setNav() {
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", obj: self, action: "registAction")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登入", obj: self, action: "loginAction")
    }
    
    @objc private func registAction() {
        print("注册按钮")
        
        //  登入和注册时同一界面
        loginAction()
    }
    
    @objc private func loginAction() {
        print("登入按钮")
        //跳转到webController
        
        presentwebController()
        
    }
    
    
 
}

extension NRDBaseViewController {
   private func presentwebController() {
        //  创建控制器
        let webVC = NRDWebViewController()
        //  创建nav
        let nav = UINavigationController(rootViewController: webVC)
        //  presentwebVC
        presentViewController(nav, animated: true, completion: nil)
        
        
    }
}

