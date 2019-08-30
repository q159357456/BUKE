//
//  OldUserRemindView.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/9/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit

@objc protocol Goto_Record_delegate: NSObjectProtocol{
    
  @objc optional func Goto_Record()
}

@objc  open class OldUserRemindView: UIView {

    
    var remindViewblock = {}
    
    
    lazy var funView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor.init(white: 0.8, alpha: 0.5)
        temp.frame = CGRect(x: 0, y: 0, width: 300, height: 360)
        temp.layer.cornerRadius = 21.0
        temp.layer.masksToBounds = true
        temp.center = self.center
        temp.backgroundColor = UIColor.white
        
   

        return temp
        
    }()
    
    lazy var close:UIButton = {
        let temp = UIButton()
      
        temp.setImage(UIImage.init(named: "entry_close"), for: UIControlState.normal)
        temp.frame = CGRect(x: funView.frame.maxX - 10, y: funView.frame.origin.y - 35 , width: 35, height: 35)
        temp.addTarget(self, action: #selector(close_ri), for: UIControlEvents.touchUpInside)
        return temp
        
    }()
    
    
    lazy var imageview: UIImageView = {
        let temp: UIImageView = UIImageView()
        temp.image = UIImage.init(named: "entry_image")!
        temp.frame = CGRect(x: 0, y: 0, width: funView.frame.size.width, height: 216)
        return temp
        
    }()
    
    lazy var title_label: UILabel = {
        
        let temp: UILabel = UILabel()
        temp.textAlignment = NSTextAlignment.center
        temp.numberOfLines = 0
        temp.text = "完善宝宝性别和年龄,\n看看小布壳为你推荐了啥"
        temp.textColor = HexRGB(Int(0xFF666666 as UInt32))
        temp.frame = CGRect(x: 0, y: imageview.frame.maxY + 10, width: imageview.frame.width, height: funView.frame.height/6)
        temp.font = UIFont.systemFont(ofSize: 14)
        return temp
    }()
    
    lazy var go_record: UIButton = {
        let temp = UIButton()
        
        temp.frame = CGRect(x: funView.frame.width/2 - 100, y: title_label.frame.maxY + 10, width: 200, height: 44)
        temp.backgroundColor = btn_select_color
        temp.layer.cornerRadius = bottom_btn_h/2
        temp.layer.masksToBounds = true
        temp.titleLabel?.textColor = UIColor.white
        temp.setTitle("去录入", for: .normal)
        temp.addTarget(self, action: #selector(record), for: UIControlEvents.touchUpInside)
        return temp
    }()

    @objc  weak var delegate:Goto_Record_delegate?
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.addSubview(self.funView)
        self.addSubview(self.close)
        funView.addSubview(self.imageview)
        funView.addSubview(title_label)
        funView.addSubview(go_record)
        self.backgroundColor = HexRGBAlpha(Int(0xFF202020 as UInt32),0.7)
        
     
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    
   
    
    @objc func close_ri(){
        self.removeFromSuperview()
    }

    @objc func record(){
        self.removeFromSuperview()
        self.delegate?.Goto_Record!()
        
    }
    
}
