//
//  NRDSendWeiBoViewController.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/18.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDSendWeiBoViewController: UIViewController {
    
    
    //  键盘背景View
    private lazy var bgView: NRDEmoticonBgView = {
        let keyBoardView = NRDEmoticonBgView()

        keyBoardView.size = CGSize(width: self.textView.frame.size.width, height: 216)
        return keyBoardView
    }()
    
    //  自定义的collectionView
    private lazy var  showPictureView:NRDShowPictureView = {
       let view = NRDShowPictureView()
//        view.backgroundColor = randomColor()
        return view
    }()
    //  自定义的TextView 
    private lazy var textView: NRDComposeTextView = {
        
        let textView = NRDComposeTextView()
        //  设置代理对象
        textView.delegate = self
        //  设置placeHolder
        textView.placeHolder = "顶风尿三丈~~~"
        
        // textViewFont
        textView.font = UIFont.systemFontOfSize(30)
        
        //  垂直滚动
        textView.alwaysBounceVertical = true
        return textView
        
    }()
    
    //  自定义的toolBar
    private lazy var toolBar: NRDComposeToolBar = {
        //  frame 必须设置
        let toolBar = NRDComposeToolBar(frame: CGRectZero)
        
        return toolBar
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        if let name = NRDUserAccountViewModel.sharedUserAccountViewModel.userInfos?.name {
            let title = "发微博\n\(name)"
            
            /*
             *  NSMutableAttributedString<副文本> ??????????????
             *
             */
            let attribute = NSMutableAttributedString(string: title)

            //  获取名字的范围
            let range = (title as NSString).rangeOfString(name)
            //  富文本对象添加属性
            attribute.addAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                NSFontAttributeName: UIFont.systemFontOfSize(12)] , range: range)

            titleLabel.attributedText = attribute
            
        } else {
            titleLabel.text = "发微博"
        }
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    // MARK: - 右边按钮
    private lazy var rightButton: UIButton = {
       
        let rightButton = UIButton()
        //  设置状态
        rightButton.setTitle("发送", forState: .Normal)
        rightButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        rightButton.setBackgroundImage(UIImage(named: "common_button_orange"), forState: .Normal)
        rightButton.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), forState: .Highlighted)
        //  未选中的状态
        rightButton.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: .Disabled)
        
        //  添加点击事件
        rightButton.addTarget(self, action: "sendInfosAction", forControlEvents: .TouchUpInside)
        //  设置大小
        rightButton.sizeToFit()
        
        return rightButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupNav()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // MARK: - setupNav
    private func setupNav() {
        
        //  取消按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", obj: self, action: "cancelAction")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem?.enabled = false
        /*  注意:
        *       rightButton 是被navigationItem.rightBarButtonItem 管理并且它有enable 属性
        *       所以不能设置rightButton 的属性 enable
        *       外部设置->navigationItem.rightBarButtonItem?.enabled = true
        */
        
        //  设置titleView
        navigationItem.titleView = titleLabel
    }

    private func setupUI() {
        view.backgroundColor = UIColor.whiteColor()
        //  添加textView
        view.addSubview(textView)
        view.addSubview(toolBar)
        textView.addSubview(showPictureView)
   
        
        //  设置约束
        textView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(toolBar.snp_top)
        }
        showPictureView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textView).offset(100)
            make.leading.equalTo(textView).offset(10)
            make.width.equalTo(textView.snp_width).offset(-020)
            make.height.equalTo(textView.snp_width).offset(-20)
            
        }
        
        toolBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.leading.equalTo(view)
            make.bottom.equalTo(view)
            make.trailing.equalTo(view)
        }
        
        //  监听键盘的弹起
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardChangeAction:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        //  接受通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveEmoticonListAction:", name: sendEmoticonToTextViewNotification, object: nil)
        
        toolBarAction()

    }
    // MARK: - 键盘弹起监听事件
    @objc private func keyBoardChangeAction(noti: NSNotification) {
        //  获取键盘的frame
        let keyBoardFrame = (noti.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //  获取动画时长
        let duration = (noti.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        toolBar.snp_updateConstraints { (make) -> Void in
            make.bottom.equalTo(view).offset(keyBoardFrame.origin.y - screenHeight)
        }
        
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: -  leftButton
    @objc private func cancelAction() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - rightButton
    @objc private func sendInfosAction() {
    
        let access_token = NRDUserAccountViewModel.sharedUserAccountViewModel.access_token!
        //  发送内容
        let status = textView.emoticonString //textView.text!
        //  发送请求
        if  showPictureView.imageInfos.count > 0 {

            let image = showPictureView.imageInfos.first!
            NRDHTTPSessionManager.sharedHTTPSessionManager().upDateWeiboInfos(image, access_token: access_token, status: status, callBack: { (response, error) -> () in
                if error != nil {
                    return
                }
                print(response)
            })
        }else {
         NRDHTTPSessionManager.sharedHTTPSessionManager().sendWieBoMessage(access_token, status: status) { (response, error) -> () in
            if error != nil {
                return
            }
            print(response)
        }
        }
        
        
    }
    private func toolBarAction() {
        toolBar.callBack = { [weak self] (type: stackType) -> () in
            
            switch type {
            case .Picture:
//                print("图片")
                self?.didSelectedImage()
            case .Mention:
                print("@")
            case .Trend:
                 print("#")
            case .Emoticon:
                print("emoji")
                self?.didSelectedEmoticonAction()
            case .Add:
                print("添加")

            }
            
        }
        //  选择图片
        showPictureView.showPictureBack = {[weak self] in
            self!.didSelectedImage()
        }
        
        
        }

}



// MARK: - boolbar的工作-  选择图片
extension NRDSendWeiBoViewController {
    //  选择图片
    func didSelectedImage() {
        //  图片选择器
        let pickerImageVC = UIImagePickerController()
        //  设置代理对象
        pickerImageVC.delegate = self
        //  判断是否支持相机
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            pickerImageVC.sourceType = .Camera
            print("支持相机")
        }else {
            pickerImageVC.sourceType = .PhotoLibrary
            print("使用图库")
        }
        //  判断是否支持前后摄像头
        if UIImagePickerController.isCameraDeviceAvailable(.Front) {
            print("前置摄像头")
        }else if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
            print("后置摄像头")
        }
        //  推送控制器
        presentViewController(pickerImageVC, animated:true, completion: nil)
        
    }
    // MARK: - emoji 表情
    private func didSelectedEmoticonAction() {
        if textView.inputView == nil {
            //  自定义键盘
            textView.inputView = bgView
            // 修改图片
            toolBar.changeEmojiButtonImage(true)
        }else {
            textView.inputView = nil
            toolBar.changeEmojiButtonImage(false)
        }
        
        //  成为第一响应
        textView.becomeFirstResponder()
 
        //  刷新键盘(切换键盘需要更新)
        textView.reloadInputViews()
    }
    
    @objc private func receiveEmoticonListAction(noti: NSNotification) {
        let emoticon = noti.object as! NRDEmoticonList
        
        textView.insertAttribute(emoticon)
//
//        
//        //
//        if emoticon.type == "0" {
//            //  text = ...//  是能单一文本一只被替换
//            //  插入多个文本,不会被替换
//            //insertText(text!)
//            //  定义个可变的富文本
//            let  originalAttributeStr = NSMutableAttributedString(attributedString: textView.attributedText)
//            //  1.获取图片
//            let imageName = emoticon.path!
//            //  2.创建一个文本附件
//            let attachment = NRDTextAttachment()
//
//            attachment.image = UIImage(named: imageName)
//            //  设置表情模型
//            attachment.emoticonList = emoticon
//            
//            //  获取文本字体的高度
//            let fontHeight = textView.font!.lineHeight
//            //  设置文本附件的高度
//            attachment.bounds = CGRectMake(0, -4, fontHeight, fontHeight)
//            
//            
//            //  3.通过attachment 创建一个富文本(不可变的)
//            let emoticonAttributeStr = NSAttributedString(attachment: attachment)
//            
//            
//            //  4.组合成完整的富文本
////            originalAttributeStr.appendAttributedString(emoticonAttributeStr)
//            
//            //  获取textView被选中的区域
//            var range = textView.selectedRange
//
//            //  根据选中的范围替换富文本
//            originalAttributeStr.replaceCharactersInRange(range, withAttributedString: emoticonAttributeStr)
//            
//            //  5.指定富文本的大小
//            originalAttributeStr.addAttribute(NSFontAttributeName, value: textView.font!, range: NSMakeRange(0, originalAttributeStr.length))
//
//            
//            //  给自己的富文本赋最新的富文本
//            textView.attributedText = originalAttributeStr
//            
//            //  设置光标的位置
//            range.location += 1
//            range.length = 0
//            textView.selectedRange = range
//            
//            
//            
//            
//            //  发送通知textView已经被改变, 隐藏placeHoldel
//            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: nil)
//            //  调用代理方法,开启右边button.enable的状态
//            textView.delegate?.textViewDidChange!(textView)
//            
//        }else {
//
//
//            //  写入文本
//          textView.insertText((emoticon.code! as NSString).emoji())
//        }
        
    }

}

// MARK: -  textview代理
extension NRDSendWeiBoViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        //  看text 是否有值
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    //  滚动过程中取消编辑状态
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    
}

// MARK: -  图片选择器
extension NRDSendWeiBoViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    
    // MARK: - 代理方法实现
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //  自己dismiss自己
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let pickerImage = image.scaleImageWithScaleWidth(200)
        
        showPictureView.image = pickerImage
        
        //  自己dismiss自己
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
}