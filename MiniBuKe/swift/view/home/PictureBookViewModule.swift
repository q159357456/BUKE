//
//  PictureBookViewModel.swift
//  MiniBuKe
//
//  Created by chenheng on 2018/7/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import Foundation
import UIKit
//import MJRefresh

@objc public class PictureBookViewModule : NSObject {
    
    var scrollView : UIScrollView!
    var view : PictureBookView!
    
    let header = MJRefreshNormalHeader()
    
    @objc public func initViewModule(scrollView : UIScrollView,view:PictureBookView) -> Void {
        self.view = view
        self.scrollView = scrollView
        self.header.setRefreshingTarget(self, refreshingAction: #selector(PictureBookViewModule.headerRefresh))
        self.scrollView.mj_header = self.header
    }
    
    @objc func headerRefresh(){
        print("==> headerRefresh <==")
        self.view.loadData()
//        self.header.endRefreshing();
    }
    
    @objc public func onServiceSuccess() -> Void {
        self.header.endRefreshing();
    }
    
    @objc public func onServiceError() -> Void {
        self.header.endRefreshing();
        
    }
}
