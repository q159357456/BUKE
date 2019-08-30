//
//  OJRelationshipController.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit

class OJRelationshipController: OJSexBaseViewController,ClickImageLableDelegate {
   
    let FATHER_SELECT = "user_selected_ father "
    let MOTHER_SELECT = "user_selected_ mother"
    let Grandpa_SELEC = "user_selected_ grandpa1"
    let Grandma_SELECT = "user_selected_ grandpma1"
    let Grandfather_SELECT = "user_selected_ grandpma11"
    let Grandmather_SELECT = "user_selected_ grandpma12"
    let Other_SELECT = "user_selected_ other"
  
    
    let FATHER_NOMAL = "user_normal_father"
    let MOTHER_NOMAL  = "user_normal_mother"
    let Grandpa_NOMAL  = "user_normal_grandpa"
    let Grandma_NOMAL  = "user_normal_grandma"
    let Grandfather_NOMAL  = "user_normal_grandpa2"
    let Grandmather_NOMAL  = "user_normal_grandma2"
    let Other_NOMAL  = "user_normal_other"
    
    var slect_index: Int = 0
    
    //MARK: -ClickImageLableDelegate
    func ClickImageLable(image_lable: Image_lable_view) {
        self.donebtn.isEnabled = true
        self.donebtn.backgroundColor = btn_select_color
        let tag: Int = image_lable.tag
        let image_slect: UIImage = UIImage.init(named: slect_imarray[tag - 100])!
        let image_nomal: UIImage = UIImage.init(named: nomal_array[tag - 100])!

        if image_lable.imageview.image == image_nomal {
            if slect_index > 0 {
                let old: Image_lable_view = self.relationview.viewWithTag(slect_index) as! Image_lable_view
                
                old.imageview.image = UIImage.init(named: nomal_array[slect_index - 100])!
            }
            image_lable.imageview.image = image_slect
            slect_index = tag
            UpdateBabyInfo.baby.relationship = titlearray[tag - 100]
            
            
        }else
        {
             image_lable.imageview.image = image_nomal
             slect_index = 0
        }
          
        
    }
    lazy var nameLab: UILabel = {
        let templable = UILabel.init()
        templable.text = "您和宝宝的关系？"
        templable.textAlignment = NSTextAlignment.center
        templable.font = oj_BoldFontWithSize(24)
        return templable
    }()
    
    lazy var slect_imarray: [String] = {
     
        let temp: [String] = [FATHER_SELECT,MOTHER_SELECT,Grandpa_SELEC,Grandma_SELECT,Grandfather_SELECT,Grandmather_SELECT,Other_SELECT]
        
         return temp
        
        
    }()
    
    lazy var nomal_array: [String] = {
        let temp: [String] = [FATHER_NOMAL,MOTHER_NOMAL,Grandpa_NOMAL,Grandma_NOMAL,Grandfather_NOMAL,Grandmather_NOMAL,Other_NOMAL]
        
        return temp
    }()
    
    lazy var titlearray: [String] = {
        
        let temp: [String] = ["爸爸","妈妈","爷爷","奶奶","外公/姥爷","外婆/姥姥","其他"]
        
        return temp
    }()
    
    lazy var relationview: UIView = {
        let tempview = UIView.init()
        var x:CGFloat = 0
        var y:CGFloat = 0
        let w:CGFloat = relationW/5
        let h:CGFloat = w * 10/7
        let coloum: CGFloat = relationW/5
        let lineW: CGFloat = relationW/8
        let count: NSInteger = 7
        
        relationH = CGFloat(Float(h) * ceilf(Float(CGFloat(count) / 3)) + Float(lineW) * (ceilf(Float(CGFloat(count) / 3)) - 1))
        for i in 0...(count - 1){
            x = CGFloat(i % 3) * (w + coloum)
            y = CGFloat(i / 3) * (h + lineW)
            let view = Image_lable_view.init(frame: CGRect.zero)
            tempview.addSubview(view)
            view.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(x)
                make.top.equalToSuperview().offset(y)
                make.size.equalTo(CGSize(width: w, height: h))
            }
            view.delegate = self
            view.tag = 100 + i
            view.imageview.image = UIImage.init(named: nomal_array[i])
            view.label.text = titlearray[i]
            view.label.font = UIFont.systemFont(ofSize: 13)
            
        }
        return tempview
    }()
    
    lazy var donebtn: UIButton = {
        let tempbtn = UIButton.init()
        tempbtn .setTitle("下一步", for: UIControlState.normal)
        tempbtn.isEnabled = false
        tempbtn.backgroundColor = btn_nomal_color
        tempbtn.layer.cornerRadius = bottom_btn_h/2
        tempbtn.layer.masksToBounds = true
        tempbtn.titleLabel?.textColor = UIColor.white
        tempbtn.addTarget(self, action: #selector(done), for: UIControlEvents.touchUpInside)
        
        return tempbtn
    }()
    
    let relationW: CGFloat = kScreenWitdh * 0.8
    var relationH: CGFloat = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headview.jumpbtn.isHidden = true
        self.view.addSubview(nameLab)
        self.view.addSubview(relationview)
        self.view.addSubview(donebtn)
        
        
        //layout
        nameLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 24))
        }
        
        
        relationview.snp.makeConstraints { (make) in
          
            make.top.equalTo(nameLab.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: relationW, height: relationH))
        }
        
        
        
        donebtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset( -H_SCALE(A: 46))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: bottom_btn_w , height: bottom_btn_h))
        }
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    
    //MARK: -完成
    @objc func done() {
     
        let vc: RemindBabyTapController = RemindBabyTapController();
        vc.setBabyInfo(UpdateBabyInfo.baby);
        self.navigationController?.pushViewController(vc, animated: true)
        return;
        NotificationCenter.default.addObserver(self, selector: #selector(up_babyinfo_suceced(notifaction:)), name: NSNotification.Name(rawValue: "upbabyinfo_suceced"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(up_babyinfo_fail(notifaction:)), name: NSNotification.Name(rawValue: "upbabyinfo_fail"), object: nil)
        MBProgressHUD.showMessage("上传中")
        if (UpdateBabyInfo.baby.babyImageUrl.count > 0) {
             print("<< ====>>上传图片")
            OJSexChooseUploadImageService().run(UpdateBabyInfo.baby.babyImageUrl)
        }else
        {
            upbays_info()
        }
        


        
        
    }
    
    @objc func up_babyinfo_suceced(notifaction: Notification){
        print("<< ====>>上传图片成功")
        print("suceced" , notifaction.object ?? "none")
        if (notifaction.object != nil) {
            
            UpdateBabyInfo.baby.babyImageUrl = notifaction.object as! String
             upbays_info()
        }
        
        
    }
    @objc func up_babyinfo_fail(notifaction: Notification){
        print("<< ====>>上传图片失败")
        print("fail" , notifaction.object ?? "none")
    }
    
    
    func upbays_info() -> Void {
        
        let dic: [String: Any] = ["babyBirthday": UpdateBabyInfo.baby.babyBirthday,
                   "babyGender": UpdateBabyInfo.baby.babyGender,
                   "babyImageUrl": UpdateBabyInfo.baby.babyImageUrl,
                   "babyNickName": UpdateBabyInfo.baby.babyNickName,
                   "relationship": UpdateBabyInfo.baby.relationship]
        
        UpBabyInfo().upLoad(dic, success: { (Any, string) in
            
            if (UserDefaults.standard.bool(forKey: "OLD_REMIND") ){
                if (self.navigationController?.viewControllers[1] != nil)
                {
                  self.navigationController?.popToRootViewController(animated: true)
                }
                
                UserDefaults.standard.set(false, forKey: "OLD_REMIND")
            }else
            {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHOOSE_SEX_DONE ), object: nil)
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            
        }) { (erroCode, string) in
            
        }
//        UploadBabyInfoDataSource().load(LoadType: .LoadFromNetworkOnly, SuccessCallback: { (data) -> (Void) in
//            print("<< ====>>上传信息成功")
//            MBProgressHUD.hide()
//            MBProgressHUD.showText("保存成功！")
//            if (UserDefaults.standard.bool(forKey: "OLD_REMIND") ){
//                if (self.navigationController?.viewControllers[1] != nil)
//                {
//                    self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
//                }
//
//                UserDefaults.standard.set(false, forKey: "OLD_REMIND")
//            }else
//            {
//
//              NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHOOSE_SEX_DONE ), object: nil)
//                self.navigationController?.popToRootViewController(animated: true)
//
//            }
//
//
//
//        }) { (data, error) -> (Void) in
//            print("<< ====>>上传信息失败")
//            MBProgressHUD.hide()
//            MBProgressHUD.showText(error.descriptor)
//        }
        
    }
    override func didReceiveMemoryWarning() {
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
