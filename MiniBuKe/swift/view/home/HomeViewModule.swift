//
//  HomeViewModel.swift
//  MiniBuKe
//
//  Created by chenheng on 2018/7/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import Foundation
import UIKit
import OJSearchComponent
//import OJDataSourceComponent

@objc public class HomeViewModule: NSObject {
    
    @objc public func showAlert(vc: UIViewController) -> Void {
        let alertController = UIAlertController(title: "系统提示",
                                                message: "网络异常,重试加载数据", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            print("点击了确定")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    @objc public func addSearchEnterView(homeViewController:HomeViewController) -> Void {
        let searchEnterView:OJSearchEnterView = OJSearchEnterView()
        searchEnterView.isHidden = true
        searchEnterView.frame = CGRect(x: homeViewController.view.frame.size.width/2 - 220/2, y: 80/2 - 30/2 + 15, width: 220, height: 30)
        homeViewController.topView.addSubview(searchEnterView)

//        CallApi().run()
    }
    
//    func updateTopChildrenLayout(homeViewController:HomeViewController) -> Void {
//        homeViewController.moveButton.frame = CGRect(x: 0, y: 0, width: homeViewController.moveButton.frame.size.width, height: homeViewController.moveButton.frame.size.height)
//    }
    
}
