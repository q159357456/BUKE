//
//  Tools.swift
//  MiniBuKe
//
//  Created by chenheng on 2018/7/5.
//  Copyright © 2018年 lucky. All rights reserved.
//

import Foundation
import UIKit

class Tools: NSObject {
    
    static let instance: Tools = Tools()
    
    class func sharedTools() -> Tools {
        return instance
    }
    
    func getServerHost() -> String {
        return AppDelegate.getServerHost()
    }
}
