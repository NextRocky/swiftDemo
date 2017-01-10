//
//  NRDUserAccount.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/10.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDUserAccount: NSObject,NSCoding {

    private lazy var path = { () -> String in
        let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("userInfos.archiver")
        return path
    }()
    
    //  用户名字
    var name: String?
    
    var avatar_large: String?
    
    //  用户授权的唯一票据
    var access_token: String?
    
    
    //  access_token的生命周期
    var expires_in: NSTimeInterval = 0 {
        didSet {
            //  赋值的同事也给过期时间付完值
            expiresDate = NSDate().dateByAddingTimeInterval(expires_in)
        }
    }
    //  过期时间
    var expiresDate: NSDate?
    //  授权用的uid
    var uid: Int64 = 0
    
    override init() {
        super.init()
    }
    
    //  重载
    init (dic: [String: AnyObject]){
        super.init()
        
        setValuesForKeysWithDictionary(dic)
    }
    //  防止崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    //  重写description方法
    override var description:String {
        let keys = ["name", "avatar_large", "expires_in", "expiresDate", "uid", "access_token"]
        
        return dictionaryWithValuesForKeys(keys).description
    }
    // MARK: -- 解档/归档
    
     func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeInt64(uid, forKey: "uid")
    }
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeInt64ForKey("uid")
    }
    
    func saveInfos() -> Bool {

        print(path)
        //  归档
        let result = NSKeyedArchiver.archiveRootObject(self, toFile: path)
        return result
    }
    func loadUserInfos() -> NRDUserAccount? {
        //  解档 返回值是对象
        let result = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        return result as? NRDUserAccount
    }
}
