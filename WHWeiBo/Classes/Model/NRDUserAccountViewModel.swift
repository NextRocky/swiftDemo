//
//  NRDUserAccountViewModel.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/12.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDUserAccountViewModel: NSObject {
    
    var userInfos:NRDUserAccount? {
        return NRDUserAccount().loadUserInfos()
    }

    static let sharedUserAccountViewModel = NRDUserAccountViewModel()
    
    //  先加载数据access_token 看有没有值
    var access_token: String? {
        //  先判断是否能加载数据
        guard let access_token = NRDUserAccount().loadUserInfos()?.access_token else {
            return nil
        }
        //  能加载数据
        //  判断过期天数
        let result = NRDUserAccount().loadUserInfos()?.expiresDate?.compare(NSDate())
        //  判断是否是降序
        if result == NSComparisonResult.OrderedDescending {
            
            //  返回access_token
            return access_token
        }else {
            return nil
        }

    }
    
    //  登入状态
    var isLogin: Bool {
        return access_token != nil
    }
    
    //  构造函数私有化不让外界使用,只能通过单利才能创建对象
    private override init() {
        super.init()
    }
    
    //  通过授权码获取access_token
    func requestAccesstoken(code:String, callBack: (isSuccess: Bool)->()) {
        
        NRDHTTPSessionManager.sharedHTTPSessionManager().requestAccesstoken(code) { (response, error) -> () in
            if error != nil {
                print(error)
                callBack(isSuccess: false)
                return
            }
            
            //  转换成字典
            guard let dic = response as? [String: AnyObject] else {
                print("这不是一个json格式")
                callBack(isSuccess: false)
                return
            }
            let userAccount = NRDUserAccount(dic: dic)
            //            print(userAccount)
            
            let AccountDic = [
                "access_token":dic["access_token"]!,
                "uid": dic["uid"]!
                
            ]
            
            print(AccountDic)
            //  发送用户信息请求
            self.requestAboutAccountInfos(userAccount, dic: AccountDic, callBack: callBack);
            
        }
    }
    
    func requestAboutAccountInfos(userAccount: NRDUserAccount, dic: [String: AnyObject], callBack: (isSuccess: Bool)->()) {
        
        NRDHTTPSessionManager.sharedHTTPSessionManager().requestAboutAccountInfos(dic) { (response, error) -> () in
            if error != nil {
                print(error)
                callBack(isSuccess: false)
                return
            }
            //  请求返回值
            guard let dic = response as? [String: AnyObject] else {
                print("不是一个json格式")
                callBack(isSuccess: false)
                return
            }
            //                        //  转换成字典
            //                        let userAccountInfos = NRDUserAccount(dic: dic)
            //  保证同一个对象赋值(所以要把对象传过来)
            let userName = dic["name"] as? String
            let  userAvatar_large = dic["avatar_large"] as? String
            userAccount.name = userName
            userAccount.avatar_large = userAvatar_large
            //  打印
            print(userAccount)
            
          
            //  数据保存到本地 - <归档>
            let result = userAccount.saveInfos()
            
            if result {
                // 保存成功
                //  数据请求成功
                callBack(isSuccess: true)
            }
            else{
                print("保存失败")
                callBack(isSuccess: false)
            }
        }
    }
    
    //  home控制器发送请
    func sendRequest(maxId:Int64 = 0, since_Id:Int64 = 0, callBack: (response: AnyObject?, error: NSError?) -> () ) {
        // 请求参数
        let dic:[String: AnyObject] = [
            "access_token": access_token!,
            "max_id": "\(maxId)",
            "since_id": "\(since_Id)"
        ]
        let url = "https://api.weibo.com/2/statuses/friends_timeline.json"
        let urlString = url + "?access_token=\(access_token!)"
        print(urlString)
        NRDHTTPSessionManager.sharedHTTPSessionManager().requestAttention(dic, callBack: callBack)
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
