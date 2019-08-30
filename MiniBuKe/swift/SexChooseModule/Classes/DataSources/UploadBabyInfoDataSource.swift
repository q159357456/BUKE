////
////  UploadBabyInfoDataSource.swift
////  OJDataSourceComponent
////
////  Created by chenheng on 2018/9/7.
////  Copyright © 2018年 Lucky. All rights reserved.
////
//
//import Foundation
////import OJDataSourceComponent
//
//class UploadBabyInfoDataSource : DataSource {
//
//    var id = 0
//
//    override func load(LoadType type:LoadType,SuccessCallback successCallback: @escaping (_ dataSource : DataSource) -> (Void),
//              FailCallback failCallback: @escaping (_ dataSource : DataSource,_ error:DataError) -> (Void)) {
//        self.successCallback = successCallback
//        self.failCallback = failCallback
//
//        load(LoadType: type)
//    }
//    
//    @objc dynamic override func buildParams() {
//
//
//        self.showLog = true
//        self.operationType = .POST_JSON
//        self.domain = Tools.sharedTools().getServerHost()
//        self.portal = "/user/uploadBabyInfo"
//        self.url = "\(self.domain)\(self.portal)"
//         print("self.url<<====>>",  self.url)
//
//        if let temp :AppDelegate =  UIApplication.shared.delegate as? AppDelegate {
//            if let loginResult:LoginResult = temp.mLoginResult {
//                self.token = loginResult.token
//            }
//        }
//
//        print("self.token<<====>>",  self.token)
//
//        self.params = ["babyBirthday": UpdateBabyInfo.baby.babyBirthday,
//                   "babyGender": UpdateBabyInfo.baby.babyGender,
//                   "babyImageUrl": UpdateBabyInfo.baby.babyImageUrl,
//                   "babyNickName": UpdateBabyInfo.baby.babyNickName,
//                   "relationship": UpdateBabyInfo.baby.brelationship] as [String : Any]
//
//
////        let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
////        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
////        self.params = ["xbkBabyInfoDTO": strJson ?? ""]
//
//    }
//
//
//
//    @objc dynamic override func parserJson(Json json: AnyObject) {
//
//    }
//}
