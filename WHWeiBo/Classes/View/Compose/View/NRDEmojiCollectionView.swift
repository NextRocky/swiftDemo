//
//  NRDEmojiCollectionView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/20.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

private let keyBoardKey = "keyBoardCell"
let sendEmoticonToTextViewNotification = "sendEmoticonToTextViewNotification"
let deleteEmotionOnTextViewNotification = "deleteEmotionOnTextViewNotification"
class NRDEmojiCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let myFlowLayout = UICollectionViewFlowLayout()
        
        super.init(frame: frame, collectionViewLayout: myFlowLayout)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        
        backgroundColor = UIColor.whiteColor()
        //  设置数据源
        dataSource = self
        //  横向滚动条取消
        showsHorizontalScrollIndicator = false
        //  垂直滚动到指示器取消
        showsVerticalScrollIndicator = false
        //  弹簧效果
        bounces = false
        //  分页效果
        self.pagingEnabled = true
        //  注册
        registerClass(NRDKeyBoardCell.self, forCellWithReuseIdentifier: keyBoardKey)
        

     
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let myFlowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        myFlowLayout.itemSize = size
        myFlowLayout.scrollDirection = .Horizontal
        myFlowLayout.minimumInteritemSpacing = 0
        myFlowLayout.minimumLineSpacing = 0
    }
    

    
}


extension NRDEmojiCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return NRDOpenBundleTools.sharedOpenBundleTools.emotionAllDataArr.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NRDOpenBundleTools.sharedOpenBundleTools.emotionAllDataArr[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(keyBoardKey, forIndexPath: indexPath) as! NRDKeyBoardCell
        
//        cell.emojiImageArr = emojiImageArr
        let emojiImageArr = NRDOpenBundleTools.sharedOpenBundleTools.emotionAllDataArr[indexPath.section][indexPath.row]
        cell.emojiImageArr = emojiImageArr

        return cell
    }
    
    
}

class  NRDKeyBoardCell:UICollectionViewCell {
    
    
    //  懒加载删除button
    private lazy var deleteEmoticonButton: UIButton = {
        let deleteEmoticonButton = UIButton()
        deleteEmoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
        deleteEmoticonButton.setImage(UIImage(named: "deleteEmoticonButton_highlighted"), forState: .Highlighted)
        deleteEmoticonButton.addTarget(self, action: "deleteEmoticonAction", forControlEvents: .TouchUpInside)
        return deleteEmoticonButton
    }()
    //  button  数组
    private lazy var emojiButtonArr:[NRDEmoticonButton] = {

        return self.createButton()
    }()
    
    var emojiImageArr: [NRDEmoticonList]? {
        didSet {
            guard let eia = emojiImageArr else{
                return
            }
            //  防止重用 
            for btn in emojiButtonArr {
                //  先隐藏所有的button
                btn.hidden = true
            }
            for (i,value) in eia.enumerate() {
                //  防止越界
                let emojiBtn = emojiButtonArr[i]
                //  每一个btn 自带模型
                emojiBtn.emoticonList = value
                emojiBtn.hidden = false
                if value.type! == "0" {
                    emojiBtn.setImage(UIImage(named: value.path!), forState: .Normal)
                    emojiBtn.setTitle(nil, forState: .Normal)
                }else {
                    //  oc 方法要桥接文件
                    emojiBtn.setTitle((value.code! as NSString).emoji() , forState: .Normal)
                    emojiBtn.setImage(nil, forState: .Normal)
                }
                
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

        contentView.addSubview(deleteEmoticonButton)
        
    }
    
    // MARK: - 创建buttonArr
    private func createButton() ->[NRDEmoticonButton] {
        
        var btnArr = [NRDEmoticonButton]()
        //  创建button
        for _ in 0..<20 {
            let button = NRDEmoticonButton()
            
            button.titleLabel!.font = UIFont.systemFontOfSize(30)
            
            btnArr.append(button)
            
            contentView.addSubview(button)
            
            //  添加点击事件
            button.addTarget(self, action: "addEmoticonAction:", forControlEvents: .TouchUpInside)
        }
        return btnArr
    }
    // MARK: - 设置frame
    override func layoutSubviews() {
        super.layoutSubviews()
        //  设置button的frame
        let buttonW = contentView.width / 7
        let buttonH = contentView.height / 3
        for (i,value) in emojiButtonArr.enumerate() {
            let col = i % 7
            let raw = i / 7
            //  xy
            value.x = buttonW * CGFloat(col)
            value.y = buttonH * CGFloat(raw)
            value.size = CGSizeMake(buttonW, buttonH)
        }
        
        //  设置删除按钮的x,y
        deleteEmoticonButton.x = width - buttonW
        deleteEmoticonButton.y = height - buttonH
        //  设置size
        deleteEmoticonButton.size = CGSizeMake(buttonW, buttonH)
    }
    
    
    
    // MARK: - 删除按钮点击事件
    @objc private func deleteEmoticonAction() {
        print("删除")
    }
    // MARK: -  添加表情到textView
    @objc private func addEmoticonAction(sender:NRDEmoticonButton) {
        //  通知将模型传给textView
        NSNotificationCenter.defaultCenter().postNotificationName(sendEmoticonToTextViewNotification, object: sender.emoticonList)
        
    }
    
    
    
}

