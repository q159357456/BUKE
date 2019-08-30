//
//  UpdateBabyInfo.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/9/6.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit
//import OJDataSourceComponent
@objc open class UpdateBabyInfo: NSObject {
    
  @objc open var  babyBirthday: String = ""
  @objc open  var babyGender: Int = 0
  @objc open  var babyImageUrl: String = ""
  @objc open  var babyNickName: String = ""
  @objc open  var relationship: String = ""
  @objc open  var image: UIImage?
  @objc open  var babyQuestion: String = ""

    
    
    static let baby: UpdateBabyInfo = UpdateBabyInfo()

    
}
