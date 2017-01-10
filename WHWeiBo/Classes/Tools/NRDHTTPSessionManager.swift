//
//  NRDHTTPSessionManager.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/11.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
import AFNetworking

//  枚举请求
enum requestType:Int {
    case GET
    case POST
}

class NRDHTTPSessionManager: AFHTTPSessionManager {

    //  取别名
    typealias back = (response: AnyObject?, error: NSError?) -> ()
    //  创建单利对象
    static let sharedHTTPSessionManager = { () -> NRDHTTPSessionManager in
        let manager = NRDHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return manager
    }
    //  发送请求接收参数--取别名
    private func demo(type: requestType, URLString:String, params:AnyObject,callBack: back) {
        if type == .GET {
            self.GET(URLString, parameters: params, progress: nil, success: { (_, response) -> Void in
                callBack(response: response, error: nil)
                }, failure: { (_, error) -> Void in
                    callBack(response: nil, error: error)
            })
        }
        if type == .POST {
            self.POST(URLString, parameters: params, progress: nil, success: { (_, response) -> Void in
                callBack(response: response, error: nil)
                }, failure: { (_, error) -> Void in
                    callBack(response: nil, error: error)
            })
        }
    }
    
    
    // MARK: - 发送微博(带图片)
    private func sendWeiBoRequest(URLString: String, params: AnyObject,imageData: NSData, name: String, callBack: (response: AnyObject?, error: NSError?) -> () ) {
        
    POST(URLString, parameters: params, constructingBodyWithBlock: { (formData) -> Void in
        /**
        imageData : 上传图片所需要二进制数据
        name: 服务端的获取数据的参数
        fileName: 告诉服务端我们的文件名字,服务端一般不会用,他们会自动生成唯一的一个图片名
        mimeType: 资源类型, octet-stream通用的资源类型
        */
        formData.appendPartWithFileData(imageData, name: name, fileName: "test", mimeType: "octet-stream")
    }, progress: nil, success: { (_, response) -> Void in
        callBack(response: response, error: nil)
        }) { (_, error) -> Void in
        callBack(response: nil , error: error)
        }
        
    }
}


extension NRDHTTPSessionManager {
    //   请求token
    func requestAccesstoken(code:String, callBack: (response: AnyObject?, error: NSError?) -> ()) {

        let url = "https://api.weibo.com/oauth2/access_token"
        
        let params = [
            "client_id": weiBoAppKey,
            "client_secret": weiBoAppSecret,
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": weiBoCallBackPage,
        ]
        
        demo(.POST, URLString: url, params: params) { (response, error) -> () in
            callBack(response: response, error: error)
        }
    }
    
    //   请求用户信息
    func requestAboutAccountInfos(dic: [String: AnyObject], callBack: (response: AnyObject?, error: NSError?) -> ()) {
        let URLString = "https://api.weibo.com/2/users/show.json"
        demo(.GET, URLString: URLString, params: dic, callBack: callBack)
    }
    
    //  发送用户的关注请求  获取当前登录用户及其所关注用户的最新微博
    func requestAttention(dic: [String: AnyObject], callBack: (response: AnyObject?, error: NSError?) -> ()){
        //  url
        let urlString = "https://api.weibo.com/2/statuses/friends_timeline.json"
        demo(.GET, URLString: urlString, params: dic, callBack: callBack)
    }
    
    
// MARK: - 写一条微博数据(文字)
    func sendWieBoMessage(access_token: String, status: String,callBack: (response: AnyObject?, error: NSError?) -> ()) {
        let url = "https://api.weibo.com/2/statuses/update.json"
        let params = [
            "access_token": access_token,
            "status": status
        ]
        demo(.POST, URLString: url, params: params, callBack: callBack)
    }
    func upDateWeiboInfos(image: UIImage,access_token: String, status: String,callBack: (response: AnyObject?, error: NSError?) -> ()) {
        let URLString = "https://upload.api.weibo.com/2/statuses/upload.json"
        let params = [
            "access_token": access_token,
            "status": status
        ]
        /*
            UIImage
            图片质量系数1-0 越小质量月底
        */
//        let imageData = UIImagePNGRepresentation(image)
        let imageData = UIImageJPEGRepresentation(image, 2)
        sendWeiBoRequest(URLString, params: params, imageData: imageData!, name: "pic", callBack: callBack)
    }
    
    
    
}

