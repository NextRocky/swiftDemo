//
//  NRDTableViewCell.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/13.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
import SnapKit

/*
//  转发
var repostsStr: String?
//  评论
var commentsStr: String?
//  表态
var attitudesStr: String?

*/
class NRDTableViewCell: UITableViewCell {


    var toolConstraint: Constraint?
    //  接受参数
    var statusViewModel: NRDStatusViewModel? {
        didSet {
            //  原创参数
            originalView.statusViewModel = statusViewModel
            
            //  toolbar参数
            toolbar.statusViewModel = statusViewModel
            
            // 卸载约束
            toolConstraint?.uninstall()
            //  转发微博是否有
            if   statusViewModel?.retweetAttributedStr != nil {
                //  隐藏取消
                retweetView.hidden = false
                //
                retweetView.statusViewModel = statusViewModel
                
                // tool约束更新
                toolbar.snp_updateConstraints(closure: { (make) -> Void in
                    //  替换约束
                    toolConstraint = make.top.equalTo(retweetView.snp_bottom).constraint
                })
                
            }else {
                retweetView.hidden = true
                
                toolbar.snp_updateConstraints(closure: { (make) -> Void in
                    toolConstraint = make.top.equalTo(originalView.snp_bottom).constraint
                })
                
            }
        }
    }
    
    //  若设置为私有属性上面个的didSet 中拿不到
    //  原创视图
    lazy var originalView: NRDOriginalView = {
       let originalView = NRDOriginalView()
        return NRDOriginalView()
    }()
    //  转载视图
    lazy var retweetView: NRDRetweetView = NRDRetweetView()
    //  toolbar
    lazy var toolbar: NRDToolBarView = NRDToolBarView()
    
    override  init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //  添加控件--设置约束
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        contentView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        contentView.addSubview(originalView)
        contentView.addSubview(retweetView)
        contentView.addSubview(toolbar)
     
        
        originalView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)

        }
        
        retweetView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(originalView.snp_bottom)
            make.leading.equalTo(originalView)
            make.trailing.equalTo(originalView)
        }
        
        toolbar.snp_makeConstraints { (make) -> Void in
            self.toolConstraint = make.top.equalTo(retweetView.snp_bottom).constraint
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(35)
        }
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.trailing.equalTo(self)
            make.leading.equalTo(self)
            make.bottom.equalTo(toolbar)
            
        }
    }
    
}
