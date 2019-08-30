//
//  BaseViewController.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit
//import OJDataSourceComponent

enum SexType {
    case boy
    case girl
}
let bottom_btn_w: CGFloat = 200
let bottom_btn_h: CGFloat = 44
let btn_select_color: UIColor = HexRGB(Int(0xFFF6922D as UInt32))
let btn_nomal_color:UIColor = HexRGB(Int(0xFFD7D7D7 as UInt32))
@objc open class OJSexBaseViewController: UIViewController {
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    
    lazy var headview: HeadView = {
        let temp: HeadView = HeadView.init(frame: CGRect(x: 0, y: 0, width: kScreenWitdh, height: 64))
        
        weak var weakSelf = self
        temp.backclosure = {
            weakSelf?.back()
           
        }
        
        temp.jumpclosure = {
            weakSelf?.jump()
        }
        return temp
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        
   
        self.view.addSubview(headview)
        
        // Do any additional setup after loading the view.
        
//        CallApi().run()
    }
    
    
    @objc func jump(){
        
      
        if (UserDefaults.standard.bool(forKey: "OLD_REMIND") ){
            if (self.navigationController?.viewControllers[1] != nil)
            {
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
            }
            
            UserDefaults.standard.set(false, forKey: "OLD_REMIND")
        }else
        {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHOOSE_SEX_DONE ), object: nil)
            UserDefaults.standard.set(true, forKey: "HasJumped")
            UserDefaults.standard.synchronize()
            self.navigationController?.popToRootViewController(animated: true)
           
        }
    
       print("跳过")
        
    }
    
    @objc func back(){
        
        self.navigationController?.popViewController(animated: true)
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
