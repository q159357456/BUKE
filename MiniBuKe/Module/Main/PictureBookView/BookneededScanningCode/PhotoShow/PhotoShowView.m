//
//  PhotoShowView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PhotoShowView.h"
#import "UIResponder+Event.h"
@implementation PhotoShowView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.ShowPhotoImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.ShowPhotoImageView];
        UIButton *button1= [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setImage:[UIImage imageNamed:@"remake_btn"] forState:UIControlStateNormal];

        [button1 addTarget:self action:@selector(upLoadPhoto:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 1;

        
        UIButton *button2= [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setImage:[UIImage imageNamed:@"confirm_btn"] forState:UIControlStateNormal];
   
        [button2 addTarget:self action:@selector(upLoadPhoto:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 2;
        
        [self addSubview:button1];
        [self addSubview:button2];
        
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.mas_left).offset(61);
            make.size.mas_equalTo(CGSizeMake(86, 86));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-120);
            
        }];
        
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.mas_right).offset(-61);
            make.size.mas_equalTo(CGSizeMake(86, 86));
            make.bottom.mas_equalTo(self.mas_bottom).offset(-120);
        }];
    }
    return self;
}

-(void)upLoadPhoto:(UIButton*)btn{
    
    
    [self eventName:PhotoShowView_Event Params:[NSNumber numberWithInteger:btn.tag]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
