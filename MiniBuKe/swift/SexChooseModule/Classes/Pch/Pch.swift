//
//  Pch.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//
import UIKit
import Foundation
//通知
public let CHOOSE_SEX_DONE = "CHOOSE_SEX_DONE"

// 比例
let  SCALE_W = UIScreen.main.bounds.size.width/375.00
let  SCALE_H = UIScreen.main.bounds.size.height/667.00
func W_SCALE(A: CGFloat) ->CGFloat{
    
    return CGFloat(A) * SCALE_W
}

func H_SCALE(A: CGFloat) ->CGFloat{
    
    return CGFloat(A) * SCALE_H
}


let kScreenWitdh = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
/**颜色**/
func XH_RGBA_Color(R:Float,G:Float,B:Float,A:Float) ->UIColor {
    return UIColor.init(red: CGFloat(R/255.0), green: CGFloat(G/255.0), blue: CGFloat(B/255.0), alpha: CGFloat(A))
}

func XH_RGB_Color(R:Float,G:Float,B:Float) ->UIColor {
    return XH_RGBA_Color(R: R, G: G, B: B, A: 1.0)
}

// 通过 十六进制与alpha来设置颜色值  （ 样式： 0xff00ff ）
public let HexRGBAlpha:((Int,Float) -> UIColor) = { (rgbValue : Int, alpha : Float) -> UIColor in
    return UIColor(red: CGFloat(CGFloat((rgbValue & 0xFF0000) >> 16)/255), green: CGFloat(CGFloat((rgbValue & 0xFF00) >> 8)/255), blue: CGFloat(CGFloat(rgbValue & 0xFF)/255), alpha: CGFloat(alpha))
}
public let HexRGB:((Int) -> UIColor) = { (rgbValue : Int) -> UIColor in
    return UIColor(red: CGFloat(CGFloat((rgbValue & 0xFF0000) >> 16)/255), green: CGFloat(CGFloat((rgbValue & 0xFF00) >> 8)/255), blue: CGFloat(CGFloat(rgbValue & 0xFF)/255), alpha: CGFloat(1))
}

/**字体*/
// 系统加粗字体
var oj_BoldFontWithSize: (CGFloat) -> UIFont = {size in
    return UIFont.boldSystemFont(ofSize: size)
}

var oj_SystemFontWithSize : (CGFloat) -> UIFont = {size in
    
    return UIFont.systemFont(ofSize: size)
    
}

/**
 图片获取
 */
var get_bunld_image: (String) -> UIImage = { image_nmae in
    let bunld: Bundle = Bundle.main
    let image: UIImage = UIImage.init(named: image_nmae, in: bunld, compatibleWith: nil)!
    
    return image
    
    
}



/**角度弧度互转*/
// 角度转弧度
/// - Parameter __ANGLE__: 角度
/// - Returns: 弧度值
func OJ_Angle_To_Radian(__ANGLE__:CGFloat) ->CGFloat {
    return (.pi * __ANGLE__ / 180.0)
}

// 弧度转角度
/// - Parameter __RADIAN__: 弧度
/// - Returns: 角度
func OJ_Radian_To_Angle(__RADIAN__:CGFloat) ->CGFloat {
    return (CGFloat(__RADIAN__ * 180 / .pi))
}



