//
//  NRDPictureCell.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/19.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDPictureCell: UICollectionViewCell {
    
    //  删除图片的闭包
    var deleteImageCallBack: (() -> ())?
    
    var image:UIImage? {
    
        didSet {
            if image == nil {
                showPictureBox.image = UIImage(named: "compose_pic_add")
                //  设置添加图片的高亮状态
                showPictureBox.highlightedImage = UIImage(named: "compose_pic_add_highlighted")
                deleteButton.hidden = true
            }else {
                showPictureBox.image = image
                deleteButton.hidden = false
            }
        }
    }
    private lazy var deleteButton:UIButton = {
        let deleteButton = UIButton()
        deleteButton.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        deleteButton.sizeToFit()
        
        //  添加点击事件
        deleteButton.addTarget(self, action: "deleteImageAction", forControlEvents: .TouchUpInside)
        
        return deleteButton
    }()
    private lazy var showPictureBox: UIImageView = {
        let picture = UIImageView(image: UIImage(named: "avatar_default_big"))
        return picture
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI () {
        contentView.addSubview(showPictureBox)
        contentView.addSubview(deleteButton)
        
        //  添加约束
        showPictureBox.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).offset(UIEdgeInsetsZero)
        }
        
        deleteButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.trailing.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func deleteImageAction() {
        deleteImageCallBack!()
    }
}
