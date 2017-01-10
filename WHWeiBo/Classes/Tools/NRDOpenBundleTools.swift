//
//  NRDOpenBundleTools.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/20.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
private let numberOfPages = 20
class NRDOpenBundleTools: NSObject {

    // 单利
    static let sharedOpenBundleTools: NRDOpenBundleTools = {
    
        let shared = NRDOpenBundleTools()
        return shared
        
    }()
    private override  init() {
        super.init()
    }
    
    //  创建bundle对象 
    private lazy var emoticonBundle: NSBundle = {
        //  获取path
        let path = NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")
        //  path 转成bundle对象
        let emoticonBundle = NSBundle(path: path!)!
        
        return emoticonBundle
    }()
    
    private lazy var defaultEmoticon:[NRDEmoticonList] = {
        return self.arrayWithEmojiType("default/info.plist")
    }()
    
    private lazy var emojiEmoticon:[NRDEmoticonList] = {
        return self.arrayWithEmojiType("emoji/info.plist")
    }()
    
    private lazy var lxhEmoticon:[NRDEmoticonList] = {
        return self.arrayWithEmojiType("lxh/info.plist")
    }()
    
    //  三维数据嵌套数组
    lazy var emotionAllDataArr:[[[NRDEmoticonList]]] = {
       let data = [

        self.changeArrToOtherArr(self.defaultEmoticon),
        self.changeArrToOtherArr(self.emojiEmoticon),
        self.changeArrToOtherArr(self.lxhEmoticon)
    
        ]
        return data
        
    }()
    
    
    
    private func arrayWithEmojiType(emojiType: String) -> [NRDEmoticonList] {
        let bundle = self.emoticonBundle
        //  获取响应的plist文件
        let path = bundle.pathForResource(emojiType, ofType: nil)
        //  emojiArr
        let emojiArr = NSArray(contentsOfFile: path!)!
        var tempArr:[NRDEmoticonList] = [NRDEmoticonList]()
        
        for emojiArrSub in emojiArr as![[String: AnyObject]]{
            
            //  字典转模型
            let emoticonList = NRDEmoticonList(dic: emojiArrSub)
            
            if emoticonList.type == "0" {
                let lastPath = (path! as NSString).stringByDeletingLastPathComponent
                emoticonList.path = lastPath + "/" + emoticonList.png!
            }
            
            //  添加到临时数组中
            tempArr.append(emoticonList)
        }
        return tempArr
    }
    
    
    
    // MARK: - 切成数组
    private func changeArrToOtherArr(arr:[NRDEmoticonList]) -> [[NRDEmoticonList]] {
        //  数组需要切成数组的个数
        let arrCount = (arr.count-1) / numberOfPages + 1
        //  临时存放数组
        var tempArr = [[NRDEmoticonList]]()
        //  开始截取数组
        for i in 0..<arrCount  {
            //  起始位置
            let rangeStartPos = i * numberOfPages
            //  长度
            var len = numberOfPages
            //  最后一组会越界
            if rangeStartPos + len > arr.count {
                len = arr.count - rangeStartPos
            }
            //  将数组转化成NSArray
            let otherArr = (arr as NSArray).subarrayWithRange(NSMakeRange(rangeStartPos, len)) as! [NRDEmoticonList]
            
            tempArr.append(otherArr)
        }
        return tempArr
    }
    //  根据描述字符串查找表情
    func findEmoticnByString(chs: String) -> NRDEmoticonList? {
        
        
        //  方法一
        for value in NRDOpenBundleTools.sharedOpenBundleTools.defaultEmoticon {
            if value.chs == chs {
                return value
            }
        }
        for value in NRDOpenBundleTools.sharedOpenBundleTools.lxhEmoticon {
            if value.chs == chs {
                return value
            }
        }
        
        return nil
    }
    
    
    
    
    //
}
