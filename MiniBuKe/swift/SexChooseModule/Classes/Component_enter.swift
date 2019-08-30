//
//  Component_enter.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/9/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit

class Component_enter: NSObject {

    
    var myclosure: (() -> ())? = nil
    
    
    
    init(Name name: @escaping () -> () ) {
        super.init()
        self.myclosure = name
    }
    

    
}
