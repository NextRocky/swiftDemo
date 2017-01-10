//
//  NRDComposButton.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/17.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDComposButton: UIButton {


     var composeModel: NRDComposeModel?
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
    
        userInteractionEnabled = true
        //
        setTitleColor(UIColor.grayColor(), forState: .Normal)
        //
        titleLabel?.font = UIFont.systemFontOfSize(15)
        //
        titleLabel?.textAlignment = .Center
        
//        imageView?.layer.borderColor = UIColor.redColor().CGColor
//        imageView?.layer.borderWidth = 1
    }
    

    override var highlighted:Bool {
    
        get {
            return false
        } set {
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.y = 0
        imageView?.x = 0
        imageView?.width = width
        imageView?.height = width

        titleLabel?.x = 0
        titleLabel?.y = width
        titleLabel?.width = width
        titleLabel?.height = height - width
    }
}
