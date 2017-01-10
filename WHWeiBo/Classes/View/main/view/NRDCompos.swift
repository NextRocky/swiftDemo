//
//  NRDCompos.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/17.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
import pop

class NRDCompos: UIView {

    private lazy var bgImage:UIImageView = UIImageView.clipScreenImage()
    private lazy var plistData: [NRDComposeModel] = [NRDComposeModel]()
    private lazy var composeButtonArr: [NRDComposButton] = [NRDComposButton]()
    private var mainVC: NRDMainViewController?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupUI() {
    
        backgroundColor = randomColor()
        //  设置自己的frame
        frame.size = CGSizeMake(screenWidth, screenHeight)
        
//        let bgImage = UIImageView.clipScreenImage()
        
        addSubview(bgImage)
    
        bgImage.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).offset(UIEdgeInsetsZero)
        }
        
    
        addPlist()
//        createButton()
    }
    
    //  绘画图片
//    private func clipScreenImage() ->UIImageView {
//        //  获取主window
//        let window = UIApplication.sharedApplication().keyWindow
//        //  开启图形上下文
//        UIGraphicsBeginImageContext(CGSizeMake(screenWidth, screenHeight))
//        //  
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(screenWidth,screenHeight), false, 0)
//        //
//        window?.drawViewHierarchyInRect((window?.bounds)!, afterScreenUpdates: false)
//        //  从图形上下文获取图片
//        let clipImage = UIGraphicsGetImageFromCurrentImageContext()!
//        
//        //  关闭图形上下文
//        UIGraphicsEndImageContext()
//        //  保存本地
//        let imageData = UIImagePNGRepresentation(clipImage)
//        imageData?.writeToFile("/Users/luoli/Desktop/1.png", atomically: true)
//        
//        return UIImageView(image: clipImage)
//    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        UIView.animateWithDuration(0.25) { () -> Void in
            for(i, value) in self.composeButtonArr.reverse().enumerate() {
                
                self.startAnimate(value, i: i, isUp: false)
                
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.8 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            //  从父控件移除
            self.removeFromSuperview()
    
        });
     
    }
    private func addPlist()  {//-> [NRDComposeModel]
        
        //  添加plist 文件
        let path = NSBundle.mainBundle().pathForResource("compose.plist", ofType: nil)
        let arr = NSArray(contentsOfFile: path!)!
        //  转模型
        var muArr = [NRDComposeModel]()
        for value in arr {
            let composeMode = NRDComposeModel(dic: value as! [String : AnyObject])
            muArr.append(composeMode)
        }
        plistData = muArr
//        return muArr
        createButton()

    }
    
    private func createButton() {
        
        
        
        let colNum = 3
        let buttonW:CGFloat = 80
        let buttonH:CGFloat = 110
        let buttonMargin: CGFloat = (screenWidth - buttonW * CGFloat(colNum)) / CGFloat(colNum + 1)
    

//        let plistData = addPlist()
        //  遍历字典数组
        for (i,value) in plistData.enumerate() {
            let col = i % colNum
            let row = i / colNum
            let composeButton = NRDComposButton()
            composeButton.composeModel = value
            composeButton.width = buttonW
            composeButton.height = buttonH
            composeButton.x = CGFloat(col) * buttonW + CGFloat(col + 1) * buttonMargin
            composeButton.y = CGFloat(row) * buttonH + CGFloat(row) * buttonMargin + screenHeight
            
            composeButton.setTitle(value.title, forState: .Normal)
            composeButton.setImage(UIImage(named: value.icon!), forState: .Normal)
        
            composeButtonArr.append(composeButton)
            
            //  点击事件
            composeButton.addTarget(self, action: "composeAction:", forControlEvents: .TouchUpInside)
            addSubview(composeButton)
        }
    }
    
    func show(mainVC: NRDMainViewController) {
        //
        self.mainVC = mainVC
        /*
           将蒙版添加套window 上在用主控制器去present  会出现层次混乱
        
        */
//        //  需要添加到的目标view
//        let destinationView = UIApplication.sharedApplication().windows.last
//        //  添加
//        destinationView?.addSubview(self)
        
        mainVC.view.addSubview(self)
        UIView.animateWithDuration(0.25) { () -> Void in
            for(i, value) in self.composeButtonArr.enumerate() {

                self.startAnimate(value, i: i, isUp: true)

            }
        }

    }
    
    private func startAnimate(value:NRDComposButton, i: Int, isUp:Bool) {
        //  创建动画
        let animation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        
        let y = isUp ? value.centerY - 350 : value.centerY + 350
        //  动画执行目的地
        animation.toValue = NSValue(CGPoint:CGPoint(x: value.centerX, y: y))
        //
        animation.springBounciness = 15
        //
        animation.springSpeed = 5
        //
        animation.beginTime = CACurrentMediaTime() + Double(i) * 0.025
        //
        value.pop_addAnimation(animation, forKey: nil)
    }
    
    
    // MARK: - 点击事件
    @objc private func composeAction(btn: NRDComposButton) {
    //  通过className 创建控制器
        //  将字符串转成类
        let sendWeiBo = NSClassFromString((btn.composeModel?.className)!) as! NRDSendWeiBoViewController.Type
        //  创建控制器
        let sendWeiBoVC = sendWeiBo.init()

        UIView.animateWithDuration(0.25, animations: { () -> Void in
        //  放大当前点击的按钮
        for value in self.composeButtonArr {
            if value == btn {
                //  放大
                value.transform = CGAffineTransformMakeScale(3, 3)
            } else {
              
                //  其他缩小
                value.transform = CGAffineTransformMakeScale(0.25, 0.25)
            }
            
   
        }
        }, completion: { (_) -> Void in

            UIView.animateWithDuration(0.2, animations: { () -> Void in
                //  回复初始状态
                for value in self.composeButtonArr {
               
                    value.transform = CGAffineTransformIdentity
                }
                //  包装navigation
                let nav = UINavigationController(rootViewController: sendWeiBoVC)
                //  present控制器
                self.mainVC!.presentViewController(nav, animated: true, completion: nil)
//                print(self.mainVC)
              
            })
                        })

    }
}



