//
//  HeadView.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit



class HeadView: UIView {

    var backbtn: UIButton
    var jumpbtn: UIButton
    var backclosure = {}
    var jumpclosure = {}
    

    
    override init(frame: CGRect) {
        backbtn = UIButton.init(type: UIButtonType.custom)
        jumpbtn = UIButton.init()

        jumpbtn.backgroundColor = HexRGBAlpha(Int(0xf8f9fb as UInt32),1)
        jumpbtn.layer.cornerRadius = 15
        jumpbtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        jumpbtn.layer.masksToBounds = true
        backbtn.setImage(UIImage.init(named: "identity_navibar_back"), for: UIControlState.normal)
        jumpbtn.setTitle("跳出", for: UIControlState.normal)
        super.init(frame: frame)
        self.addSubview(backbtn)
        self.addSubview(jumpbtn)
        
        backbtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        jumpbtn.addTarget(self, action: #selector(jump), for: UIControlEvents.touchUpInside)
        jumpbtn.setTitleColor(HexRGBAlpha(Int(0xFF999999 as UInt32),1), for: UIControlState.normal)
        jumpbtn.layer.borderColor = HexRGBAlpha(Int(0xE0E0E0 as UInt32),1).cgColor
        jumpbtn.layer.borderWidth = 1.0
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        backbtn = UIButton.init()
        jumpbtn = UIButton.init()
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        self.backbtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(H_SCALE(A: 23))
            make.left.equalToSuperview().offset(0)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        self.jumpbtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(H_SCALE(A: 28))
            make.right.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 66, height: 25))
        }
        
        
    }
    
    @objc func back(){
        backclosure()
        
    }
    
    @objc func jump(){
        
        jumpclosure()
    }

}
