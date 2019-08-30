//
//  MyCenterCenterView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookHistoryReadInfo;

@protocol MyCenterCenterViewDelegate <NSObject>

-(void) onViewFrameChange;

@end

@interface MyCenterCenterView : UIView

+(instancetype) xibView;

-(void) updateDataView:(CGSize ) size setBookHistoryReadInfo:(BookHistoryReadInfo *) mBookHistoryReadInfo setDelegate:(id<MyCenterCenterViewDelegate>) delegate;

-(float) getHeight;
@end
