//
//  NRDHomeTableViewController.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/9.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
import SVProgressHUD
private let  key:String = "cell"

class NRDHomeTableViewController: NRDBaseViewController {
    
   private lazy var statusViewModel: NRDStatusTableViewModel = NRDStatusTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if login {
            //  登入状态
            //  发送请求
            loadWebData()
            //  设置UI
            setupUI()
            //  刷新数据
            reloadMoreData()
            //  设置Nav
            setupNavUI()
            
         
        }else
        {
            self.visitorView?.updateVisitorPage(nil, changeLabel: nil)
        }
    }


    //  上拉刷新加载更多
    private lazy var pullUpReload: UIActivityIndicatorView = {
        
       let pullUpReload = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        pullUpReload.color = UIColor.redColor()
        return pullUpReload
    }()
    
    
    //  下拉刷新
//    private lazy var pullDownReload: UIRefreshControl = {
//       let pullDownReload = UIRefreshControl()
//        pullDownReload.tintColor = UIColor.redColor()
//        //  添加点击事件
//        pullDownReload.addTarget(self, action: "pullDownReloadMoreData", forControlEvents: .ValueChanged)
//        return pullDownReload
//    }()
    
    //  自定义下拉刷新
    private lazy var pullDowndReload: NRDPullDownReload = {
       let pullDowndReload = NRDPullDownReload()
        pullDowndReload.backgroundColor = UIColor.whiteColor()
        pullDowndReload.addTarget(self, action: "pullDownReloadMoreData", forControlEvents: .ValueChanged)
        return pullDowndReload
    }()
    //  提示刷新的数据
    private lazy var messageLabel:UILabel = {
        let messageLabel = UILabel()
        messageLabel.backgroundColor = UIColor.orangeColor()
        messageLabel.font = UIFont.systemFontOfSize(12)
        messageLabel.textColor = UIColor.grayColor()
        messageLabel.textAlignment = .Center
        return messageLabel
    }()
    //  messageLabel
    // MARK: - 界面搭建
    private func setupUI() {
        
        //  通知接受
        let defaultCenter = NSNotificationCenter.defaultCenter()
        defaultCenter.addObserver(self, selector: "action:", name: "sendPanVCNotification", object: nil)
        
        //  注册
        tableView.registerClass(NRDTableViewCell.self, forCellReuseIdentifier: key)
        
        //  估算行高
        tableView.estimatedRowHeight = 200
        
        //  设置行高--自动行高
        tableView.rowHeight = UITableViewAutomaticDimension

        //  取消cell之间的线
        tableView.separatorStyle = .None
        
        //  添加refresh
//        tableView.addSubview(pullDownReload)
        
        //  添加自定义下拉刷新控件
        view.addSubview(pullDowndReload)
        
    }
// MARK: - 接受通知
    func action(noti:NSNotification)
    {
//        let vc = noti.object as! NRDPanViewController
//        self.navigationController?.pushViewController(vc, animated: false)
//        self.navigationController?.childViewControllers
//        print(vc)
    }
    
    /*
    
       下拉刷新方式
       1> self.refreshControl = pullDownReload
       2> tableView.addSubview(pullDownReload)
    
    */
    
    
    // MARK: - 上拉加载,下拉刷新
    private func reloadMoreData() {
        //上拉加载
        //  设置底部菊花转
        tableView.tableFooterView = pullUpReload
        //  设置size
        pullUpReload.sizeToFit()
        
        //  下拉刷新
//        self.refreshControl = pullDownReload
        
    }
    @objc private func pullDownReloadMoreData() {
        
        //  下拉刷新
        loadWebData()
        
    }
    
    // MARK: - 关闭加载
    private func closeRefresh() {
    
        //  请求成功后关闭refresh
        self.pullDowndReload.endRefreshing()
    }
    //  网络请求数据
    private func loadWebData() {
        //  发送请求
        statusViewModel.loadWebData(pullUpReload.isAnimating()) { (isSuccess, messageText) -> () in
            
            if isSuccess {

                if self.pullUpReload.isAnimating() {
                    //  成功后关闭菊花转
                    self.pullUpReload.stopAnimating()
                }else {
                    self.pullDowndReload.endRefreshing()
                }
                
                self.messageLabel.text = messageText
                self.messageLabelAnimation()
             
                //  请求成功属性数据
                self.tableView.reloadData()
            }else {
                print("错误")
            }
        }
    }
}

extension NRDHomeTableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusViewModel.statusList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //  cell创建
        let cell = tableView.dequeueReusableCellWithIdentifier(key, forIndexPath: indexPath) as! NRDTableViewCell
        //  获取模型
        let myStatusViewModel = statusViewModel.statusList[indexPath.row]
 
        //  设置为不被选中
        cell.selectionStyle = .None
        
        //  cell的statusViewModel 赋值
        cell.statusViewModel = myStatusViewModel
        
     
    
        return cell
        
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row == statusViewModel.statusList.count - 1 && !pullUpReload.isAnimating() {
            //  开启动画
            pullUpReload.startAnimating()
            print(statusViewModel.statusList[indexPath.row].status?.id)
            //  加载数据
            loadWebData()
        }
    }

    
    
}

extension NRDHomeTableViewController {
    
    // MARK: - 设置nav
    private func setupNavUI() {
        //  判断nav
        guard let nav = self.navigationController else {
            return
        }
        nav.view.insertSubview(messageLabel, belowSubview: nav.navigationBar)
        //  设置frame
        messageLabel.frame = CGRectMake(0, 64 - 30 , screenWidth, 30)
        
        messageLabel.hidden = true
        
        
    }
    
    // MARK: - message动画
    private func messageLabelAnimation() {
        
        //  如果提示栏不是隐藏状态就提示,不会再调用显示状态
        if messageLabel.hidden == false {
            return
        }
    
        messageLabel.hidden = false
        //  动画
        UIView.animateWithDuration(1, animations: { () -> Void in
            
            //  messageY
            self.messageLabel.transform = CGAffineTransformMakeTranslation(0, self.messageLabel.height)
            }) { (_) -> Void in
                UIView.animateWithDuration(1, animations: { () -> Void in
                    //  回复初始状态
                    self.messageLabel.transform = CGAffineTransformIdentity
                    
                    }, completion: { (_) -> Void in
                        //  回去后再隐藏
//                        self.messageLabel.backgroundColor = UIColor.clearColor()
                        self.messageLabel.hidden = true
                })
                
        }
    }
    
    

    
    
    
    
    
    
}