//
//  StoryViewModel.swift
//  MiniBuKe
//
//  Created by chenheng on 2018/7/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

import Foundation
import UIKit

@objc public class StoryViewModule : NSObject {
    
    var scrollView : UIScrollView!
    var view : StoryView!
    
    let header = MJRefreshNormalHeader()
    
    @objc public func initViewModule(scrollView : UIScrollView,view:StoryView) -> Void {
        self.view = view
        self.scrollView = scrollView
        self.header.setRefreshingTarget(self, refreshingAction: #selector(PictureBookViewModule.headerRefresh))
        self.scrollView.mj_header = self.header
    }
    
    @objc public func headerRefresh(){
        print("==> he@objc aderRefresh <==")
        self.view.loadData()
    }
    
    @objc public func onServiceSuccess() -> Void {
        self.header.endRefreshing();
    }
    
    @objc public func onServiceError() -> Void {
        self.header.endRefreshing();
        
    }
}
