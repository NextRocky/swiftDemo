//
//  NRDEmoticonButton.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/21.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDEmoticonButton: UIButton {

 
    var emoticonList:NRDEmoticonList?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
