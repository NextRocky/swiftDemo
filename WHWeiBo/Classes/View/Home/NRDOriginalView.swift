//
//  NRDOriginalView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/13.
//  Copyright © 2016年 罗李. All rights reserved.
//


/*
 * 原装
 */
import UIKit 
import SnapKit
import SDWebImage
let subMargin = 10

let ContentFont: CGFloat = 15
class NRDOriginalView: UIView {



    var pictureConstaint: Constraint?
    
    var statusViewModel: NRDStatusViewModel? {
        didSet {
            //  给自己的属性赋值
            //  判断头像url 是否存在
            if statusViewModel?.status?.user?.profile_image_url != nil {
                //  url存在
                headImageView.sd_setImageWithURL(NSURL(string: (statusViewModel?.status?.user?.profile_image_url)!), placeholderImage: UIImage(named: "avatar_default_big"))
                
            }
  
            //  设置认证
                verified_typeImageView.image = statusViewModel?.verified_typeImage
            
            //  设置VIP
                mbrankImageView.image = statusViewModel?.mbRankImage
          
            //  写在上一个约束
            self.pictureConstaint?.uninstall()
            if statusViewModel?.status?.pic_urls?.count > 0 {
                
                self.pictureView.hidden = false
                self.snp_updateConstraints(closure: { (make) -> Void in
                    self.pictureConstaint = make.bottom.equalTo(pictureView).offset(subMargin).constraint
                    pictureView.pic_urls = statusViewModel?.status?.pic_urls
                    
                })
            }else{
                self.pictureView.hidden = true
                
                self.snp_updateConstraints(closure: { (make) -> Void in
                    self.pictureConstaint = make.bottom.equalTo(contentLabel).offset(subMargin).constraint
                
                })
            }
            
            //  设置关注认得name
            userNameLabel.text = statusViewModel?.status?.user!.screen_name
            
            //  设置time
            timeLabel.text = statusViewModel?.time
            
            //  来源
            sourceLabel.text = statusViewModel?.sourceStr
            
            //  content
//            contentLabel.text = statusViewModel?.status?.text
            contentLabel.attributedText = statusViewModel?.OriginalattributedString
            
            
        }
    }
    
    private lazy var pictureView: NRDCollectionView = {
        let picture = NRDCollectionView()
        
       
        return picture
    }()

    //  懒加载--头像
    private lazy var headImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))    
    //  懒加载-- 认证
    private lazy var verified_typeImageView: UIImageView = UIImageView(image: UIImage(named: "avatar_vip"))
    //  关注的用户昵称
    private lazy var userNameLabel: UILabel = UILabel(title: "小小罗", textFont: ContentFont)
    //  vip
    private lazy var mbrankImageView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership"))
    //  时间
    private lazy var timeLabel: UILabel = UILabel(title: "", textFont: 12)
    //  微博来源
    private lazy var sourceLabel: UILabel = UILabel(title: "source", textFont: 12)
    //  发送的内容
    private lazy var contentLabel: UILabel = {
        let label = UILabel(title: "content", textFont: 12)
        
        label.numberOfLines = 0
        
        return label
    }()
    //  collectionView 展示图片
//    private lazy var showImageView: NRDCollectionView = NRDCollectionView()
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
        
        //  设置UI--添加控件--设置约束
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置UI
    private func setupUI() {
        
        backgroundColor = UIColor.whiteColor()
        addSubview(headImageView)
        addSubview(verified_typeImageView)
        addSubview(userNameLabel)
        addSubview(mbrankImageView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(contentLabel)
        addSubview(pictureView)
        

        
        headImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(subMargin)
            make.leading.equalTo(self).offset(subMargin)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        verified_typeImageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(headImageView.snp_trailing)
            make.centerY.equalTo(headImageView.snp_bottom)
        }
        userNameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(headImageView)
            make.leading.equalTo(headImageView.snp_trailing).offset(subMargin)
        }
        mbrankImageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(userNameLabel)
            make.leading.equalTo(userNameLabel.snp_trailing).offset(subMargin)
        }
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(headImageView.snp_trailing).offset(subMargin)
            make.bottom.equalTo(headImageView.snp_bottom)
        }
        sourceLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(timeLabel.snp_trailing).offset(subMargin)
            make.bottom.equalTo(timeLabel)
        }
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(headImageView.snp_bottom).offset(subMargin)
            make.leading.equalTo(self.snp_leading).offset(subMargin)
            make.trailing.equalTo(self.snp_trailing).offset(-subMargin)
        }
        pictureView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentLabel.snp_bottom).offset(subMargin)
            make.leading.equalTo(contentLabel)
            make.size.equalTo(CGSizeMake(100, 100))
        }
        
        //  设置自己的约束
        self.snp_makeConstraints { (make) -> Void in
           self.pictureConstaint = make.bottom.equalTo(pictureView).offset(subMargin).constraint
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
}
