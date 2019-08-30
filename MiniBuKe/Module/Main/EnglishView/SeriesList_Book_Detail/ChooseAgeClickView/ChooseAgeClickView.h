//
//  ChooseAgeClickView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ChooseAgeClickView_Event @"ChooseAgeClickView_Event"
#import "English_Header.h"
typedef enum _Position_State{
    Top_State = 0,
    Down_State
    
}position_State;
@interface ChooseAgeClickView : UIView
+(instancetype)get_chooseage_viewTitle:(NSString*)title Font:(UIFont*)font Frame:(CGRect)frame;
@property(nonatomic,strong)UILabel *lable;
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,assign)position_State positionState;
-(void)remakeConstraintsTitle:(NSString*)title PositionState:(NSInteger)postionSate;
-(void)unfold;
-(void)packup;
@end
