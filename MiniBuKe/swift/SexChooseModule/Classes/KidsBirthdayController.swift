//
//  KidsBirthdayController.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit

class KidsBirthdayController: OJSexBaseViewController {
    
    
    
    var birthday: String?
    var sextype: SexType = SexType.boy
    lazy var datePicker: UIDatePicker = {
        let temppicker = UIDatePicker.init()
        temppicker.datePickerMode = UIDatePickerMode.date
        temppicker.locale = NSLocale.init(localeIdentifier: "zh_CN") as Locale
        //设置最大、最小、默认时间 2010 8 1   2010 8 1  2017 8 1
        let dateFomatter = DateFormatter.init()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        
      
        let dateComponents = NSCalendar.current.dateComponents([.year, .month, .day], from: NSDate() as Date)
        let year = dateComponents.year!
        let maxyear: Int = year + 1
        let datestring : String = String(maxyear) + "-" + String(dateComponents.month!) + "-" + String(dateComponents.day!)
     
        //最大时间
        let maxdate = dateFomatter.date(from: datestring)
        //默认时间
        let defaultdate = dateFomatter.date(from: "2010-08-01")
          temppicker.date = defaultdate!
        temppicker.maximumDate = maxdate
        temppicker.addTarget(self, action: #selector(choosedate(_picker:)), for: UIControlEvents.valueChanged)
        
        return temppicker
        
    }()
    
    lazy var nextbtn: UIButton = {
        let tempbtn = UIButton.init()
        tempbtn .setTitle("下一步", for: UIControlState.normal)
        tempbtn.isEnabled = false
        tempbtn.backgroundColor = btn_nomal_color
        tempbtn.layer.cornerRadius = bottom_btn_h/2
        tempbtn.layer.masksToBounds = true
        tempbtn.titleLabel?.textColor = UIColor.white
        tempbtn.addTarget(self, action: #selector(pushTonext), for: UIControlEvents.touchUpInside)
        //初始状态

        
        return tempbtn
    }()
    
    lazy var sexImageview: UIImageView = {
        
        let tempimageview = UIImageView.init()
        tempimageview.backgroundColor = UIColor.white
        if sextype == SexType.boy{
            
            tempimageview.image = UIImage.init(named: "age6+_image5_boy studern")
        }else
        {
            tempimageview.image = UIImage.init(named: "age6+_image6_girl student")
        }
        return  tempimageview
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headview.jumpbtn.isHidden = true
        self.view.backgroundColor = UIColor.white
        let lab1: UILabel = UILabel.init()
        lab1.text = "宝贝的生日?"
        lab1.font = oj_BoldFontWithSize(24)
        lab1.textAlignment = NSTextAlignment.center
        
        let lab2: UILabel = UILabel.init()
        lab2.text = "小布壳将推荐适龄的绘本、课程"
        lab2.font = UIFont.systemFont(ofSize: 14)
        lab2.textColor = UIColor.lightGray
        lab2.textAlignment = NSTextAlignment.center
        

        //sub
        self.view.addSubview(lab1)
        self.view.addSubview(lab2)
        self.view.addSubview(sexImageview)
        self.view.addSubview(datePicker)
        self.view.addSubview(nextbtn)
        
        //layo
        lab1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 24))
        }
        
        lab2.snp.makeConstraints { (make) in
            make.top.equalTo(lab1.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 250, height: 24))
        }
        
        sexImageview.snp.makeConstraints { (make) in
            make.top.equalTo(lab2.snp.bottom).offset(27)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: W_SCALE(A: 135), height: W_SCALE(A: 165)))

        }


        datePicker.snp.makeConstraints { (make) in
            make.top.equalTo(sexImageview.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(48)
            make.right.equalToSuperview().offset(-48)
            make.height.equalTo(180)
        }
//
        nextbtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset( -H_SCALE(A: 46))
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: bottom_btn_w , height: bottom_btn_h))
        }
        
    
        
            // Do any additional setup after loading the view.
    }
    
    @objc func pushTonext() {
        let kids = KidsNameController()
        kids.sextype = self.sextype
        UpdateBabyInfo.baby.babyBirthday = birthday ?? ""
        self.navigationController?.pushViewController(kids, animated: true)
        
    }
  

    @objc func choosedate(_picker: UIDatePicker) {
        
        self.nextbtn.backgroundColor = btn_select_color
        self.nextbtn.isEnabled = true
        let  chooseDate = datePicker.date
        let  dateFormater = DateFormatter.init()
            dateFormater.dateFormat = "YYYY-MM-dd"
        birthday = dateFormater.string(from: datePicker.date)
        //与当前时间比较 0-2  2-6  6 +  <0
       
        let cha: Float = timeCompare(date: chooseDate as NSDate)
        
        
        if cha >= 0
        {
            if cha < 2
            {
                sexImageview.image = UIImage.init(named: "age0~2_image2_chrld")
                
            }else if cha >= 2 && cha < 6
            {
                
                sexImageview.image = self.sextype == .boy ? UIImage.init(named: "image3_boy") :UIImage.init(named: "age3~6_image4_girl")
                
            }else
            {
                

                sexImageview.image = self.sextype == .boy ? UIImage.init(named: "age6+_image5_boy studern") :UIImage.init(named: "age6+_image6_girl student")
                
            }
            
        }else
        {
               sexImageview.image = UIImage.init(named: "age_image_woman")
            
        }
        
        
        
        
        
        
  
        
    }


    func timeCompare(date: NSDate) -> Float {

       
        let  dateFormater = DateFormatter.init()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let  now = dateFormater.string(from: NSDate() as Date)
        let nowdate: Date = dateFormater.date(from: now)!
        let one_year = 365 * 24 * 60 * 60
        let mince = Int(date.timeIntervalSince1970 - nowdate.timeIntervalSince1970)
        return -Float( Float(mince) / Float(one_year))
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation
temppicker.locale = NSLocale.init(localeIdentifier: "zh_CN") as Locale
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
