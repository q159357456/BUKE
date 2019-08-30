//
//  OJNavigationController.swift
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/8/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import UIKit

class OJNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //去掉线
        self.navigationBar.shadowImage = UIImage()
        //去掉背景颜色
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)

        // Do any additional setup after loading the view.
    }

//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        //重写左侧返回按钮
//        super.pushViewController(viewController, animated: true )
//
//        //创建返回按钮
//        if viewController.navigationItem.leftBarButtonItem==nil&&self.viewControllers.count>1{
//            print("创建返回按钮")
//            let backImg=UIImage(named: "identity_navibar_back")
//            let backBtn=UIBarButtonItem(image: backImg, style: UIBarButtonItemStyle.plain, target:self, action:#selector(popSelf))
//
//            viewController.navigationItem.leftBarButtonItem=backBtn
//
//
//        }
//    }
        
    @objc func popSelf(){
            //返回上一级
        self.popViewController(animated: true)
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
