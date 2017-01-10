//
//  NRDPullDownReload.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/16.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

private let selfHeight: CGFloat = 50
enum refreshType: Int {
    //  普通状态
    case Normal = 0
    //  下拉状态
    case PullDown = 1
    //  刷新状态
    case Reload = 2
}

class NRDPullDownReload: UIControl {

    //  箭头
    private lazy var pull_refreshImageView: UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    //  菊花
    private lazy var refreshIndicator:UIActivityIndicatorView = {
        let refreshIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        refreshIndicator.sizeToFit()
        return refreshIndicator
    }()
    //  提示内容
    private lazy var messageLabel: UILabel = {
       let messageLabel = UILabel()
        messageLabel.text = "下拉刷新"
        messageLabel.font = UIFont.systemFontOfSize(15)
        messageLabel.textColor = UIColor.grayColor()
        return messageLabel
    }()
    
    //  记录滚动的view
     private  var currentView: UIScrollView?
    
    //  下拉刷新的状态
      var pullDownReloadType: refreshType = .Normal {
        didSet {
            switch pullDownReloadType {
            case .Normal:
                print("下拉刷新")
                //  箭头不隐藏
                pull_refreshImageView.hidden = false
                //  菊花隐藏
                refreshIndicator.stopAnimating()
                refreshIndicator.hidden = true
                //  message
                messageLabel.text = "下拉刷新"

                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.pull_refreshImageView.transform = CGAffineTransformIdentity
                })
                
                if oldValue == .Reload {
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        self.currentView?.contentInset.top -= selfHeight
                    })
                }
                
            case .PullDown:
//                print("松手就刷新")
                //  箭头不隐藏
                pull_refreshImageView.hidden = false
                //  菊花隐藏
                refreshIndicator.hidden = true
                // message
                messageLabel.text = "松手就刷新"
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.pull_refreshImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                })
                
            case .Reload:
//                print("刷新")
                refreshIndicator.hidden = false
                pull_refreshImageView.hidden = true
                messageLabel.text = "正在刷新...."
                refreshIndicator.startAnimating()
                
                //  刷新停留
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.currentView?.contentInset.top += selfHeight
                })
                //  发送targe   事件
                sendActionsForControlEvents(.ValueChanged)
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        //  添加控件
        addSubview(pull_refreshImageView)
        addSubview(refreshIndicator)
        addSubview(messageLabel)
        
        //  使用手动不局-<关闭>
        pull_refreshImageView.translatesAutoresizingMaskIntoConstraints = false
        //  系统添加约束
        addConstraint(NSLayoutConstraint(item: pull_refreshImageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: -35))
        addConstraint(NSLayoutConstraint(item: pull_refreshImageView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        refreshIndicator.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: pull_refreshImageView, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: pull_refreshImageView, attribute: .CenterY, multiplier: 1, constant: 0))
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Leading, relatedBy: .Equal, toItem: pull_refreshImageView, attribute: .Trailing, multiplier: 1, constant: 0 ))
    }

    // MARK: - 控件添加到父控件上是会被掉用--<view.addSubview(pullDowndReload)>
    override func willMoveToSuperview(newSuperview: UIView?) {
        guard let scrollView = newSuperview as? UIScrollView else {
            return
        }
        //  设置自己的frame
        size = CGSizeMake(scrollView.size.width, selfHeight)
        y = -selfHeight

        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.New], context: nil)
        //  设置为属性
        currentView = scrollView
        
    }
//    override func willChangeValueForKey(key: String) {
//        print("ppp")
//    }
//    override func didChangeValueForKey(key: String) {
//        print("ppp")
//    }
    

        // MARK: - KVO 监听方法
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        
        guard let scrollview = currentView else  {
            return
        }
        //  滚动状态判断,及距离
        if scrollview.dragging {
            
            if scrollview.contentOffset.y < -(scrollview.contentInset.top + selfHeight) && pullDownReloadType == .Normal {
                
                //  放手刷新状态
                pullDownReloadType = .PullDown
//                print("松手刷新")
                
            }else if scrollview.contentOffset.y > -(scrollview.contentInset.top + selfHeight)&&pullDownReloadType == .PullDown {
                
                //  下拉刷新状态
                pullDownReloadType = .Normal
//                print("下拉刷新")
            }
            
        }else {
            //  刷新状态
            if pullDownReloadType == .PullDown {
                pullDownReloadType = .Reload
//                print("刷新")
            }
            
        }
        
    }
    deinit {
        //  移除KVO
//        removeObserver(currentView!, forKeyPath: "contentOffset")
        currentView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
     func endRefreshing(){
        pullDownReloadType = .Normal
    }
    
}
