//
//  NRDComposeTextView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/18.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDComposeTextView: UITextView {

    
    // placeHolderLabel
    private lazy var placeHolderLabel: UILabel = {
        let placeHolderLabel = UILabel(title: "下雨天,出来吹吹风,就是爽~~", textFont: 14)
        //  换行
        placeHolderLabel.numberOfLines = 0
        //  文本颜色
        placeHolderLabel.textColor = UIColor.lightGrayColor()
        
        placeHolderLabel.sizeToFit()
        return placeHolderLabel
    }()
    //  placeHolder  设置属性
    var placeHolder: String? {
        didSet {
            placeHolderLabel.text = placeHolder
        }
    }
    //  重写text属性
    override var text: String? {
        didSet {
            //  如果textView文本输入有值就隐藏
            placeHolderLabel.hidden = self.hasText()
        }
    }
    
    //  重写font 属性
    override var font: UIFont? {
        didSet {
            if font == nil {
                return
            }
            placeHolderLabel.font = font
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        
        
        
        //  监听textView 的改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selfTextChange", name: UITextViewTextDidChangeNotification, object: nil)

        //  开启弹簧效果
        self.bounces = true
        //  设置默认的字体大小
//        font = UIFont.systemFontOfSize(30)
        //  添加控件
        addSubview(placeHolderLabel)
        
//        //  设置约束
//        placeHolderLabel.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(self).offset(8)
//            make.leading.equalTo(self).offset(5)
//            make.trailing.equalTo(self).offset(5)
//        }
        //  关闭布局
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 5))
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 8))
        addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: -5))
        
      

    }
    
    // MARK: - 监听textView 值改变的点击事件
    @objc private func selfTextChange() {
        
        placeHolderLabel.hidden = hasText()
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
