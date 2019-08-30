//
//  KidsNameController.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit



class KidsNameController: OJSexBaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{


    var sextype: SexType = SexType.boy
    lazy var picker_controller: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
        
    }()
    lazy var nameLab: UILabel = {
        let templable = UILabel.init()
        templable.text = "宝贝的昵称"
        templable.textAlignment = NSTextAlignment.center
        templable.font = oj_BoldFontWithSize(24)
        
        return templable
    }()
    
    lazy var headImageview: UIImageView = {
        let tempimageview = UIImageView.init()
//        tempimageview.backgroundColor = UIColor.lightGray
        if sextype == SexType.girl{
            
            tempimageview.image = UIImage.init(named: "baby_default image_girl")
        }else
        {
            tempimageview.image = UIImage.init(named: "id_image_default boy")
        }
        tempimageview.layer.cornerRadius = headimaL/2
        tempimageview.layer.masksToBounds = true
        return tempimageview
    }()
    
    lazy var bgimageview: UIImageView = {
        let tempimageview = UIImageView.init()
        tempimageview.image = UIImage.init(named: "id_image_bg")
        return tempimageview
    }()
    
    
    lazy var upbtn: UIButton = {
        let tempbtn = UIButton.init()

        tempbtn.setBackgroundImage(UIImage.init(named: "id_photo_button "), for: UIControlState.normal)
        tempbtn.addTarget(self, action: #selector(alertshow), for: UIControlEvents.touchUpInside)
        return tempbtn
    }()
    
    lazy var namefield: UITextField = {
        let temp = UITextField.init()
        temp.borderStyle = UITextBorderStyle.none
        temp.placeholder = "输入宝宝昵称?"
        temp.textAlignment = NSTextAlignment.center
        temp.addTarget(self, action: #selector(textdidchange), for: UIControlEvents.editingChanged)
        temp.delegate = self
        temp.font = oj_SystemFontWithSize(13)
        return temp
    }()
    
    var length: Int = 0
    var text: String?
    @objc public func textdidchange(textfield: UITextField)  {

        for char in textfield.text!.characters {
            // 判断是否中文，是中文+2 ，不是+1
            length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2 : 1
        }
//
        if length <= 20 {
           text = textfield.text!
        } else {
            textfield.text = text
        }

        print("length ==>" , length)

        length = 0

    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//        for char in textField.text!.characters {
//            // 判断是否中文，是中文+2 ，不是+1
//            length += "\(char)".lengthOfBytes(using: String.Encoding.utf8) == 3 ? 2 : 1
//        }
//
//        if length > 8 {
//
//            return false
//        }
//
//        return true
//    }
   
    lazy var nextbtn: UIButton = {
        let tempbtn = UIButton.init()
        tempbtn .setTitle("下一步", for: UIControlState.normal)
        tempbtn.backgroundColor = btn_select_color
        tempbtn.layer.cornerRadius = bottom_btn_h/2
        tempbtn.layer.masksToBounds = true
        tempbtn.titleLabel?.textColor = UIColor.white
        tempbtn.addTarget(self, action: #selector(pushTonext), for: UIControlEvents.touchUpInside)

        return tempbtn
    }()
    

    
    let headimaL:CGFloat = W_SCALE(A: 140)
    let upbtnL: CGFloat = 50
    
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headview.jumpbtn.isHidden = true
        
        let linview: UIView = UIView.init()
        linview.backgroundColor = UIColor.lightGray
        
        //add
        self.view.addSubview(nameLab)
        self.view.addSubview(headImageview)
        self.view.addSubview(bgimageview)
        self.view.addSubview(upbtn)
        self.view.addSubview(namefield)
        self.view.addSubview(linview)
        self.view.addSubview(nextbtn)
        self.view.bringSubview(toFront: headImageview)
        self.view.bringSubview(toFront: upbtn)
        
        //layout
        nameLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 24))
        }
        
        
        headImageview.snp.makeConstraints { (make) in
            
            make.top.equalTo(nameLab.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: headimaL, height: headimaL))
        }
        bgimageview.snp.makeConstraints { (make) in
            make.center.equalTo(headImageview.snp.center)
            make.size.equalTo(CGSize(width: headimaL + 50, height: headimaL + 50))
        }
        
        
        let radius: CGFloat = headimaL/2
        let angle = OJ_Radian_To_Angle(__RADIAN__: -30)
        var cx: CGFloat = 0;
        var cy: CGFloat = 0;
        cx = radius * sin(angle)
        cy = radius * cos(angle)
        
        upbtn.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(headImageview.snp.centerX).offset(cx)
            make.centerY.equalTo(headImageview.snp.centerY).offset(-cy)
            make.size.equalTo(CGSize(width: upbtnL, height: upbtnL))
        }
      
        namefield.snp.makeConstraints { (make) in
    
            make.top.equalTo(headImageview.snp.bottom).offset(H_SCALE(A: 60))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 30))

        }

        linview.snp.makeConstraints { (make) in

            make.top.equalTo(namefield.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 1))
        }

        nextbtn.snp.makeConstraints { (make) in

            make.bottom.equalToSuperview().offset( -H_SCALE(A: 46))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: bottom_btn_w , height: bottom_btn_h))
            
            
        }

        // Do any additional setup after loading the view.
    }
 
    //下一步
    @objc func pushTonext() {
        
        UpdateBabyInfo.baby.babyNickName = namefield.text ?? ""
        self.navigationController?.pushViewController(OJRelationshipController(), animated: true)
        
        
    }
    
    
    //调用相机
    @objc func alertshow(){
       
        weak var weakself = self
        let alertController = UIAlertController.init(title: "上传宝贝头像", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let action1 = UIAlertAction.init(title: "相册" , style: UIAlertActionStyle.default, handler: { (alert) in
            
            weakself?.photolib()
            
        })
        
        let action2 = UIAlertAction.init(title: "拍照" , style: UIAlertActionStyle.default, handler: { (alert) in
            
            weakself?.camera()
            
        })
        
        let action3 = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self .present(alertController, animated: true, completion: nil)
        
    }

    //相册
    func photolib()  {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            self.picker_controller.sourceType = .photoLibrary
            self.present(self.picker_controller, animated: true, completion: nil)
            
        }else
        {
            print("无法打开相册")
        }
        
    }
    
    
    //相机
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            self.picker_controller.sourceType = .camera
            self.present(self.picker_controller, animated: true, completion: nil)
        }else
        {
            print("无法打开相机")
        }

        
    }
    
    //MARK - didFinishPickingMedide
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.headImageview.image = OJSexChooseUploadImageService().imageByScalingAndCropping(for: CGSize(width: 140 * 3, height: 140 * 3), withSourceImage: image)
        picker .dismiss(animated: true, completion: nil)
        //上传头像
//        UpdateBabyInfo.baby.babyImageUrl = OJSexChooseUploadImageService().save(image)
        UpdateBabyInfo.baby.image = image;
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
