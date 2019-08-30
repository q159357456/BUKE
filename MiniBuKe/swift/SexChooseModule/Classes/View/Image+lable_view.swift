//
//  Image+lable_view.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit

@objc protocol ClickImageLableDelegate: NSObjectProtocol{
    func ClickImageLable(image_lable: Image_lable_view)
}

class Image_lable_view: UIView {
    
   
    @objc var imageview: UIImageView
    @objc var label: UILabel
    @objc weak var delegate: ClickImageLableDelegate?
    
    
    override init(frame: CGRect) {
        self.imageview = UIImageView.init()
        self.label = UILabel.init()
        label.textAlignment = .center
        super.init(frame: frame)
       self.addSubview(self.imageview)
       self.addSubview(self.label)
        let gesturetap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(click(tap:)))
        self.addGestureRecognizer(gesturetap)
    }
    
    @objc func click(tap: UITapGestureRecognizer){
        
        self.delegate?.ClickImageLable(image_lable: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.imageview = UIImageView.init()
        self.label = UILabel.init()
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        self.imageview.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: self.frame.size.width * 0.8, height: self.frame.size.width * 0.8))
            make.top.equalToSuperview()
            
            
        }
        
        self.label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: self.frame.size.width , height: self.frame.size.width * 0.2))
            make.top.equalTo(self.imageview.snp.bottom);
            
        }
    }
 

}
