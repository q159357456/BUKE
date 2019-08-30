//
//  HomeViewController.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2018/3/25.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
typedef enum TabIndex {
    TabIndex_pictureBookView  = 0,
    TabIndex_myCenterView,
    TabIndex_storyView,
    TabIndex_EnglishView
}TabIndex;
@protocol HomeDelegate <NSObject>

-(void) updateVersion;

@end

@interface HomeViewController : BaseViewController
@property (nonatomic) TabIndex currentTabIndex;
@property(nonatomic,strong) UIView *topView;
@property (nonatomic ,weak)id <HomeDelegate> customDelegate;

@end
