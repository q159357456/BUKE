//
//  OJSexChooseController.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit
import SnapKit
import OJCategorylibs

@objc open class OJSexChooseController: OJSexBaseViewController {
    
    
    open var token: String = ""
    lazy var boybtn: UIButton = {
        let tempbtn = UIButton.init(type: UIButtonType.custom)
        let image = UIImage.init(named:"identity_image_boy")
//        let image = UIImage.ff_imagePath(withName: "identity_image_boy", bundle: "OJSexChooseComponentBundle", targetClass: object_getClass(self))
        tempbtn .setImage(image, for: UIControlState.normal)
        tempbtn.addTarget(self, action: #selector(pushToBirth(_btn:)), for: UIControlEvents.touchUpInside)
        tempbtn.tag = 1
        return tempbtn
    }()
    
    lazy var girlebtn: UIButton = {
        let tempbtn = UIButton.init(type: UIButtonType.custom)
        let image = UIImage.init(named:"identity_image_girl")
//        let image = UIImage.ff_imagePath(withName: "identity_image_girl",bundle:"OJSexChooseComponentBundle",targetClass:object_getClass(self))
        
        tempbtn .setImage(image, for: UIControlState.normal)
        tempbtn.addTarget(self, action: #selector(pushToBirth(_btn:)), for: UIControlEvents.touchUpInside)
        tempbtn.tag = 2
        return tempbtn
    }()
    
    lazy var uplable: UILabel = {
        let templab = UILabel.init()
        templab.text = "很高兴遇到您"
        templab.textAlignment = NSTextAlignment.center
        templab.font = oj_BoldFontWithSize(23)
        templab.textColor = HexRGBAlpha(Int(0xFF1D1D1D as UInt32),1)
        return templab
        
    }()
    
    lazy var downlable: UILabel = {
        let templab = UILabel.init()
        templab.textAlignment = NSTextAlignment.center
        templab.text = "您的宝贝是?"
        templab.font = oj_SystemFontWithSize(13)
        templab.textColor = HexRGB(Int(0xFF7B7B7B as UInt32))
        return templab
    }()
    
    
//    @objc func sex_choose_done() {
//
//         print("完成")
//    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
//   NotificationCenter.default.addObserver(self, selector: #selector(sex_choose_done), name: NSNotification.Name(rawValue: CHOOSE_SEX_DONE), object: nil)
        self.headview.backbtn.isHidden = true
       //addsub
         self.view.addSubview(uplable)
         self.view.addSubview(downlable)
         self.view.addSubview(boybtn)
         self.view.addSubview(girlebtn)
        

        //layout
        uplable.snp.makeConstraints { (make) in

            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(25)
            make.top.equalTo(H_SCALE(A: 104))

        }

        downlable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(25)
            make.top.equalTo(uplable.snp.bottom).offset(5)
            
        }
        
        boybtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(80)
            make.size.equalTo(CGSize(width: W_SCALE(A: 115), height: W_SCALE(A: 115)))
            make.top.equalToSuperview().offset(H_SCALE(A: 335))
            
        }
        
        girlebtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-80)
            make.size.equalTo(CGSize(width: W_SCALE(A: 115), height: W_SCALE(A: 115)))
            make.top.equalToSuperview().offset(H_SCALE(A: 335))
            
        }
        
 
        // Do any additional setup afƒter loading the view.
    }

    @objc func pushToBirth(_btn: UIButton) {
        let kids = KidsBirthdayController()
       kids.sextype = _btn.tag == 1 ? SexType.boy : SexType.girl
        if kids.sextype == .boy {
            UpdateBabyInfo.baby.babyGender = 0
        }else
        {
            UpdateBabyInfo.baby.babyGender = 1
        }
        
       self.navigationController?.pushViewController(kids, animated: true)
//        let remind: OldUserRemindView = OldUserRemindView(frame: self.view.bounds)
//        remind.delegate = self
//        self.view .addSubview(remind)
        
        
    
    }
    
    
    

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
