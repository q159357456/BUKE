//
//  TalkPlaceHoderView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/12/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
   Notifaction_Type = 0,
   Talk_Type
    
}TalkType;
NS_ASSUME_NONNULL_BEGIN

@interface TalkPlaceHoderView : UIView
-(instancetype)initWithFrame:(CGRect)frame Talk:(TalkType)talkType;
@end

NS_ASSUME_NONNULL_END
