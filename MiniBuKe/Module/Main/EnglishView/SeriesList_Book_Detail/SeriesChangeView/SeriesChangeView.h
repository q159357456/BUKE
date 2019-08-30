//
//  SeriesChangeView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Section_Height 50
#define SeriesChangeView_Event @"SeriesChangeView_Event"
typedef enum _Teaching_State{
    Introduce_State = 0,
    Atalogue_State
}Teaching_State;
@interface SeriesChangeView : UIView
+(instancetype)sectionView;
@end
