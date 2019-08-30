//
//  KBookBottomView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookBottomView.h"

@implementation KBookBottomView

+(instancetype)xibView {
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"KBookBottomView" owner:nil options:nil] lastObject];
    view.layer.borderWidth = 0.5;
    //边框颜色
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    return view;
}

-(IBAction) onChangeVoiceClick:(id)sender
{
    NSLog(@"==> onChangeVoiceClick <==");
}

-(IBAction) onTranscribeClick:(id)sender
{
    NSLog(@"==> onTranscribeClick <==");
}

-(IBAction) onDeleteClick:(id)sender
{
    NSLog(@"==> onDeleteClick <==");
}

-(IBAction) onCancelClick:(id)sender
{
    NSLog(@"==> onCancelClick <==");
    
}

@end
