//
//  UIView+Extension.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/10.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
extension UIView {
    var x: CGFloat {
        get {
            return frame.origin.x
        } set {
            frame.origin.x = newValue
        }
    }
    var y: CGFloat {
        get {
            return frame.origin.y
        } set {
            frame.origin.y = newValue
        }
    }
    var width: CGFloat {
        get {
            return frame.size.width
        } set {
            frame.size.width = newValue
        }
    }
    var height: CGFloat {
        get {
            return frame.size.height
        } set {
            frame.size.height = newValue
        }
    }
    var centerX: CGFloat {
        get {
            return center.x
        } set {
            center.x = newValue
        }
    }
    var centerY: CGFloat {
        get {
            return center.y
        } set {
            center.y = newValue
        }
    }
    var size: CGSize {
        get {
            return frame.size
        } set {
            frame.size = newValue
        }
    }
}
