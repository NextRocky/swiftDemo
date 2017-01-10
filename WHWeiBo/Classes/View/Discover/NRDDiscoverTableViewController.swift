//
//  NRDDiscoverTableViewController.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/9.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDDiscoverTableViewController: NRDBaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        if login {
            setupUI()
        }else
        {
            self.visitorView?.updateVisitorPage("visitordiscover_image_message", changeLabel: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
        }

    }

    private func setupUI() {
        
        //  search
        let search = NRDSearchView.searchView()
        //  这只frame
        search.width = self.view.width
        //
        navigationItem.titleView = search
        //  设置badgeValue
        tabBarItem.badgeValue = "哈哈"
        
    }
    
  
}
