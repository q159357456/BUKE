//
//  ChooseAgeClickView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ChooseAgeClickView.h"
#define AngleToRadius(angle) (angle)* M_PI / 180
@implementation ChooseAgeClickView
{
    BOOL _is;
}
+(instancetype)get_chooseage_viewTitle:(NSString*)title Font:(UIFont*)font Frame:(CGRect)frame
{
   
    ChooseAgeClickView *view = [[ChooseAgeClickView alloc]initWithTitle:title Font:font Frame:frame];
    return view;
}

-(instancetype)initWithTitle:(NSString*)title Font:(UIFont*)font Frame:(CGRect)frame
{
    self = [super init];
    if (self) {
        _is =NO;
        self.lable = [[UILabel alloc]init];
        self.lable.text = title;
        self.lable.font = font;
        __block CGSize size = [self.lable sizeThatFits:CGSizeZero];
        self.imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down_icon"]];
        self.imageview.contentMode = UIViewContentModeCenter;
        [self addSubview:self.lable];
        [self addSubview:self.imageview];
        [self.lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(size.width, 20));
            make.left.mas_equalTo(self.mas_left).offset(8);
            
        }];
        
        [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            make.left.mas_equalTo(self.lable.mas_right).offset(5);
            
        }];
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width + 16+22+5, 32);
        self.layer.cornerRadius =4;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        
        
        
    }
    return self;
}
-(void)click:(UITapGestureRecognizer*)tap{
    
  
    if (!_is) {
        [self unfold];
        
    }else
    {
      
        [self packup];
    }
    [self eventName:ChooseAgeClickView_Event Params:self];
    
}

-(void)remakeConstraintsTitle:(NSString*)title PositionState:(NSInteger)postionSate
{
    self.lable.text = title;
    self.lable.font = postionSate == Top_State?[UIFont boldSystemFontOfSize:15]:[UIFont boldSystemFontOfSize:12];
    CGSize size = [self.lable sizeThatFits:CGSizeZero];
    [self.lable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size.width, 20));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(8);
    }];
    if (postionSate == Top_State) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }else
    {
        self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    
     self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width + 16+22+5, 32);
    
}
-(void)unfold
{
    
//    [UIView animateWithDuration:0.5 animations:^{
    
        
//        self.imageview.transform = CGAffineTransformMakeRotation(AngleToRadius(-180));
        self.imageview.image = [UIImage imageNamed:@"down_icon_g"];
        self.lable.textColor =  COLOR_STRING(@"#54BB51");
    if (self.positionState == Down_State) {
       self.layer.borderColor = COLOR_STRING(@"#54BB51").CGColor;
    }
    
        
        
//    }];
    _is = YES;
}

-(void)packup
{
//    [UIView animateWithDuration:0.5 animations:^{
    
        self.imageview.transform = CGAffineTransformIdentity;
        self.imageview.image = [UIImage imageNamed:@"down_icon"];
        self.lable.textColor = [UIColor blackColor];
    if (self.positionState == Top_State) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }else
    {
       self.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    
        
//    }];
    _is = NO;
}
@end
