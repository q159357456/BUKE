//
//  QRCodePromptView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "QRCodePromptView.h"

@interface QRCodePromptView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@end

@implementation QRCodePromptView

+(instancetype)xibView {
    QRCodePromptView *view = [[[NSBundle mainBundle] loadNibNamed:@"QRCodePromptView" owner:nil options:nil] lastObject];
    view.layer.borderWidth = 0.5;
    //边框颜色
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [view updateData];
    return view;
}

-(void) updateData
{
    [self.imageview setBackgroundColor: COLOR_STRING(@"#FAF2E8")];
}

-(IBAction) onClickPerparedButton:(id)sender
{
    self.superview.hidden = YES;
}

@end
