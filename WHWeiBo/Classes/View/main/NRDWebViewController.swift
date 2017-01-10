//
//  NRDWebViewController.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/10.
//  Copyright © 2016年 罗李. All rights reserved.
//
/* appKey:1288147193
 * appSecret:f562ab8f695b197793426e71fc8d4354
 * callBackPage:http://www.baidu.com
 */
import UIKit
import AFNetworking
import SVProgressHUD


//  微博appKey
let weiBoAppKey = "1947916960"
//  微博appsecret
let weiBoAppSecret = "2213f4c3fec04a58dcc8bb70b3c5692d"
//  微博授权回调页
let weiBoCallBackPage = "https://www.baidu.com"



class NRDWebViewController: UIViewController {

    //  webView懒加载
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        //  设置webview的代理
        webView.delegate = self
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNav()
        webViewRequest()
        
    }

    private func setUpNav() {
        
        title = "登入首页"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", obj: self, action: "leftAction")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", obj: self, action: "rightAction")
    }
    
    @objc private func leftAction() {
        
        //  取消
        dismissViewControllerAnimated(true, completion: nil)
        //  dismissSVProgress
        SVProgressHUD.dismiss()
    }
    @objc private func rightAction() {
        
//        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('userId').value = '13342066885',document.getElementById('passwd').value = 'iosweibo'")
        
        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('userId').value = '18186235136'; document.getElementById('passwd').value = 'L98413'")
    }
    
    
    private func webViewRequest() {

        let path = "https://api.weibo.com/oauth2/authorize?client_id=\(weiBoAppKey)&redirect_uri=\(weiBoCallBackPage)"
        //  请求答应
        print("---\(path)---")
        let url = NSURL(string: path)
        
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
        
    }
    
    
}

// MARK -- 代理

extension NRDWebViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
       
        //  移除菊花转
        SVProgressHUD.dismiss()
        //  错误打印
        print("--\(error)")
    }
    
    // 拦截回调
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //  判断链接是否存在
        guard let url = request.URL else {
            return false
        }
        
        //  此处url 一定有值
        //  获取url 的绝对地址
        if !url.absoluteString.hasPrefix(weiBoCallBackPage) {
            return true
        }
        //  执行到code 相关
        //  code 截取
        
        if let query = url.query where query.hasPrefix("code="){
            let code = query.substringFromIndex("code=".endIndex)
            
            //  发送请求
            NRDUserAccountViewModel.sharedUserAccountViewModel.requestAccesstoken(code, callBack: { (isSuccess) -> () in
                if isSuccess {
                    //  登入成功
                    print("登入成功")
                   self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        //  进入欢迎页面
                        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootVCNotification, object: self);
                    })
               
                }else {
                    
                }
            })
        }else {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    
   return false
}
}

    //   请求Accesstoken
//    func requestAccesstoken(code:String) {
//        
//        NRDHTTPSessionManager.sharedHTTPSessionManager().requestAccesstoken(code) { (response, error) -> () in
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            //  转换成字典
//            guard let dic = response as? [String: AnyObject] else {
//                print("这不是一个json格式")
//                return
//            }
//            let userAccount = NRDUserAccount(dic: dic)
//            //            print(userAccount)
//            
//            let AccountDic = [
//                "access_token":dic["access_token"]!,
//                "uid": dic["uid"]!
//                
//            ]
//            
//            print(AccountDic)
//            //  发送用户信息请求
//            self.requestAboutAccountInfos(userAccount, dic: AccountDic)
//            
//        }
    
//        let url = "https://api.weibo.com/oauth2/access_token"
//        
//        let params = [
//            "client_id": weiBoAppKey,
//            "client_secret": weiBoAppSecret,
//            "grant_type": "authorization_code",
//            "code": code,
//            "redirect_uri": weiBoCallBackPage,
//        ]
        
//        //  请求对象
//        let sessionManager = AFHTTPSessionManager()
//        sessionManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
//        sessionManager.POST(url, parameters: params, progress: nil, success: { (_, response) -> Void in
//
//            //  转换成字典
//            guard let dic = response as? [String: AnyObject] else {
//                print("这不是一个json格式")
//                return
//            }
//            let userAccount = NRDUserAccount(dic: dic)
////            print(userAccount)
//            
//            let AccountDic = [
//                "access_token":dic["access_token"]!,
//                "uid": dic["uid"]!
//            
//            ]
//            
//            print(AccountDic)
//            //  发送用户信息请求
//            self.requestAboutAccountInfos(AccountDic)
//            
//            }) { (_, error) -> Void in
//                print(error)
//        }
//    }

    //  请求用户信息
//    func requestAboutAccountInfos(userAccount: NRDUserAccount, dic: [String: AnyObject]) {
//        
//        NRDHTTPSessionManager.sharedHTTPSessionManager().requestAboutAccountInfos(dic) { (response, error) -> () in
//            if error != nil {
//                print(error)
//                return
//            }
//                        //  请求返回值
//                        guard let dic = response as? [String: AnyObject] else {
//                            print("不是一个json格式")
//                            return
//                        }
////                        //  转换成字典
////                        let userAccountInfos = NRDUserAccount(dic: dic)
//                        //  保证同一个对象赋值(所以要把对象传过来)
//                        let userName = dic["name"] as? String
//                        let  userAvatar_large = dic["avatar_large"] as? String
//                        userAccount.name = userName
//                        userAccount.avatar_large = userAvatar_large
//                        //  打印
//                        print(userAccount)
//                        //  数据保存到本地 - <归档>
//                        let result = userAccount.saveInfos()
//            
//                        if result {
//                            print("保存成功")
//                            
//                        }
//                        else{
//                            print("保存失败")
//            
//        }

//        let URLString = "https://api.weibo.com/2/users/show.json"
//        
//        let sessionManager = AFHTTPSessionManager()
//        sessionManager.GET(URLString, parameters: dic, progress: nil, success: { (_, response) -> Void in
//            
//            //  请求返回值
//            guard let dic = response as? [String: AnyObject] else {
//                print("不是一个json格式")
//                return
//            }
//            //  转换成字典
//            let userAccountInfos = NRDUserAccount(dic: dic)
//            //  打印
//            print(userAccountInfos)
//            //  数据保存到本地 - <归档>
//            let result = userAccountInfos.saveInfos()
//            
//            if result {
//                print("保存成功")
//            }
//            else{
//                print("保存失败")
//            }
//            }) { (_, error) -> Void in
//                //  打印错误信息
//                print(error)
        
//        }
//    }



















