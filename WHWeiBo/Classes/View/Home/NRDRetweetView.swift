//
//  NRDRetweetView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/13.
//  Copyright © 2016年 罗李. All rights reserved.
//

/*
 * 转发
 */
import UIKit
import SnapKit



class NRDRetweetView: UIView {

    var recordConstraint: Constraint?
    var statusViewModel:NRDStatusViewModel? {
        didSet {
            if statusViewModel!.retweetAttributedStr != nil {
            
                retweetLabel.attributedText = statusViewModel!.retweetAttributedStr
            }
            
            //  写在上衣个约束
            recordConstraint?.uninstall()
            //  通过图片的数量来指定约束
            if statusViewModel?.status?.retweeted_status?.pic_urls?.count > 0 {
                //  显示状态
                retweetShowImageView.hidden = false
                //  更新约束
                self.snp_updateConstraints(closure: { (make) -> Void in
                    recordConstraint=make.bottom.equalTo(retweetShowImageView.snp_bottom).offset(subMargin).constraint
                })
                //  传值
                retweetShowImageView.pic_urls = statusViewModel?.status?.retweeted_status?.pic_urls
                
                
            }else{
                //  隐藏
                retweetShowImageView.hidden = true
                self.snp_makeConstraints(closure: { (make) -> Void in
                   recordConstraint = make.bottom.equalTo(retweetLabel.snp_bottom).offset(subMargin).constraint
                })
            }
            
        }
    }
    
    
    //  展示图片
    private lazy var retweetShowImageView: NRDCollectionView = {
       let showImage = NRDCollectionView()
        showImage.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return showImage
    }()
    
    //  RetweetLabel
    private lazy var retweetLabel: UILabel = {
    let label = UILabel(title: "案发生佛IPO哈是你疯了呢;两年;哦哈;领啊;我去特区外", textFont: 12)
        label.backgroundColor = UIColor(white: 0.9, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //  添加控件设置约束
    private func setupUI () {
        addSubview(retweetLabel)
        addSubview(retweetShowImageView)
        
        
        backgroundColor = UIColor(white: 1.0 , alpha: 1)
        
        retweetLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(subMargin)
            make.leading.equalTo(subMargin)
            make.trailing.equalTo(subMargin).offset(-subMargin)
        }
        //  展示图片视图
        retweetShowImageView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(retweetLabel)
            make.top.equalTo(retweetLabel.snp_bottom).offset(subMargin)
            make.size.equalTo(CGSizeMake(100, 100))
        }
        
        self.snp_makeConstraints { (make) -> Void in
          recordConstraint = make.bottom.equalTo(retweetShowImageView).offset(subMargin).constraint
        }
        
        
        
    }
    
}
