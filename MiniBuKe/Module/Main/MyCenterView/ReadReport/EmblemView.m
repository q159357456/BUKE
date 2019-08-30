//
//  EmblemView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/3/29.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "EmblemView.h"
@interface EmblemView()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation EmblemView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.label2.textColor = COLOR_STRING(@"#999999");
    self.doneBtn.backgroundColor = COLOR_STRING(@"#F6922D");
    self.doneBtn.layer.cornerRadius = 22;
    self.doneBtn.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 24;
    self.bgView.layer.masksToBounds = YES;
}
+(void)ShowEmblemNotice:(XG_NoticeModel*)model
{

    EmblemView *em = [[NSBundle mainBundle] loadNibNamed:@"EmblemView" owner:nil options:nil].firstObject;
    em.frame = APP_DELEGATE.window.bounds;
    em.label1.text = model.title;
    em.label2.text = [NSString stringWithFormat:@"%@",model.content];
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([model.msgPic hasPrefix:@"http"] || [model.msgPic hasPrefix:@"https"]) {
           image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.msgPic]]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            em.imageview.image = image;
            [APP_DELEGATE.window addSubview:em];
        });
    });
    
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        self.backgroundColor = [UIColor colorWithHexStr:@"#2F2F2F" alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)dismiss:(UITapGestureRecognizer*)tap{

    CGPoint point = [tap locationInView:self];
    if (!CGRectContainsPoint(self.bgView.frame, point)) {
        [self removeFromSuperview];
    }

}
@end
