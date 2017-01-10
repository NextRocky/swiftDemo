//
//  NRDToolBarView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/13.
//  Copyright © 2016年 罗李. All rights reserved.
//

/*
 *  工具栏
 */
import UIKit

class NRDToolBarView: UIToolbar {

    
    var statusViewModel: NRDStatusViewModel? {
        didSet {
            //  赋值
            //  转发
            retweetButton.setTitle(statusViewModel?.repostsStr, forState: .Normal)
            //  评论
            commentButton.setTitle(statusViewModel?.commentsStr, forState: .Normal)
            //  赞
            unlikeButton.setTitle(statusViewModel?.attitudesStr, forState: .Normal)
        }
    }
    //  转发
    private lazy var retweetButton: UIButton = self.addChildButton("转发", imageName: "timeline_icon_retweet")
    //  评论
    private lazy var commentButton: UIButton = self.addChildButton("评论", imageName: "timeline_icon_comment")
    //  点赞
    private lazy var unlikeButton: UIButton = self.addChildButton("赞", imageName: "timeline_icon_unlike")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - 设置UI界面--添加控件--设置约束
    private func setupUI(){
        
        //  设置背景色
//        backgroundColor = randomColor()
        
        addSubview(retweetButton)
        addSubview(commentButton)
        addSubview(unlikeButton)
        
        //  设置约束
        retweetButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.height.equalTo(35)
            make.width.equalTo(commentButton)
        }
        commentButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(retweetButton)
            make.leading.equalTo(retweetButton.snp_trailing)
            make.height.equalTo(retweetButton)
            make.width.equalTo(retweetButton)
        }
        unlikeButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(commentButton)
            make.leading.equalTo(commentButton.snp_trailing)
            make.width.equalTo(commentButton)
            make.height.equalTo(retweetButton)
            make.trailing.equalTo(self)
        }
        snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(retweetButton)
        }
        
    }

    // MARK: - 抽取创建button的方法
    private func addChildButton(title: String, imageName: String ) -> UIButton{
    
        let button = UIButton()
        button.setTitle(title, forState: .Normal)
        
        //  取消选中高亮状态
        /*
             1.>button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: .Normal)
                button.adjustsImageWhenHighlighted = false
        
             2.>button.backgroundColor = UIColor(patternImage: UIImage(named:"timeline_card_bottom_background")!)
        
        */

        
        button.backgroundColor = UIColor(patternImage: UIImage(named: "timeline_card_bottom_background")!)
        button.setImage(UIImage(named: imageName), forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        return button
        
    }
}
