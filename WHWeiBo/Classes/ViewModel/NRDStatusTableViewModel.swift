//
//  NRDStatusTableViewModel.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/13.
//  Copyright © 2016年 罗李. All rights reserved.
//




/*
 *  发送请求
 */
import UIKit

//  全局数组


class NRDStatusTableViewModel: NSObject {
    
    
    
lazy var statusList: [NRDStatusViewModel] = [NRDStatusViewModel]()
    
    
    
    // MARK: - HomeTable view Controller
    func loadWebData(isPullUp: Bool,callBack: (isSuccess: Bool, messageText: String?) -> ()) {
        
        /*
          第一次请求
        */
        var maxId: Int64 = 0
        var sinceId: Int64 = 0
        if isPullUp {
            if statusList.last?.status?.id > 0 {
                maxId = (statusList.last?.status?.id)! - 1  //可以强制解包
            }
        }else {
            sinceId = statusList.first?.status?.id ?? 0  //
        }
        
        NRDUserAccountViewModel.sharedUserAccountViewModel.sendRequest(maxId, since_Id: sinceId) { (response, error) -> () in
        
            if error != nil {
                
                //  返回请求错误信息
                callBack(isSuccess: false,messageText: nil)
                print(error)
                return
            }
            //请求成功
            guard let dic = response as? [String: AnyObject] else {

                //  返回错误请求
                callBack(isSuccess: false,messageText:  nil)
                print("不是一个正确的Json")
                return
            }
            guard let statusArray = dic["statuses"] as? [[String: AnyObject]] else {

                //  返回错误请求
                callBack(isSuccess: false,messageText: nil)
                return
            }
            var muArr = [NRDStatusViewModel]()
            for dic in statusArray {
                let status = NRDStatus(Dic: dic)
                let statusViewModel = NRDStatusViewModel(status: status)
                muArr.append(statusViewModel)

            }
            
            if isPullUp {
                //  上拉加载-<添加到尾部
                self.statusList.appendContentsOf(muArr)
            }else {
                //  下拉刷新-<插入在前面
                self.statusList.insertContentsOf(muArr, at:0)
            }
            var messageText = String()
            if muArr.count == 0 {
                messageText = "没有更新内容"
            }else {
                messageText = "更新了\(muArr.count)条数据"
            }

            callBack(isSuccess: true, messageText: messageText)
        }
        
    }
    

    
}
