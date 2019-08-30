//
//  TalkPlaceHoderView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TalkPlaceHoderView.h"
#import "BKMessageNODataBackView.h"
#import "DeviceManageViewController.h"
#import "BKSelectRobotModelCtr.h"

@implementation TalkPlaceHoderView

-(instancetype)initWithFrame:(CGRect)frame Talk:(TalkType)talkType
{
    self = [super initWithFrame:frame];
    if (self) {
        if (talkType == Talk_Type) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCALE(65), SCALE(239),SCALE(245), 38)];
            label.text = @"通过小布壳给宝贝发送消息吧";
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:SCALE(12)];
            label.backgroundColor = COLOR_STRING(@"#EAEAEA");
            label.layer.cornerRadius = 19;
            label.layer.masksToBounds = YES;
            [self addSubview:label];
            
        }else
        {
            CGRect imageBound = CGRectMake(0, 0, 375, 200);
            UIImage *backImage = [UIImage imageNamed:@"talkPlacehoder"];
            NSString *title = @"哎呀，这个功能需要\n绑定小布壳机器人才能使用哦!";
            BKMessageNODataBackView *backView = [[BKMessageNODataBackView alloc]initWithImageBound:imageBound WithImage:backImage WithTitle:title andPicOffset:-100 andLableOffset:-15];
            backView.frame = self.bounds;
            backView.backgroundColor = COLOR_STRING(@"#F7F9FB");
            backView.titlefont = [UIFont systemFontOfSize:13.f];
            backView.titlefontColor = COLOR_STRING(@"#999999");
            [self addSubview:backView];
            UIButton *buton = [[UIButton alloc] initWithFrame:CGRectMake(SCALE(88), self.bounds.size.height-92, SCALE(200), 44)];
            buton.backgroundColor = COLOR_STRING(@"#F6922D");
            buton.layer.cornerRadius=22;
            buton.layer.masksToBounds=YES;
            [buton setTitle:@"绑定设备" forState:UIControlStateNormal];
            [buton addTarget:self action:@selector(bindMachain) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview : buton];
        }
       
    }
    return self;
}
-(void)bindMachain{
    
//    DeviceManageViewController *mDeviceManageViewController = [[DeviceManageViewController alloc] init];
//    [APP_DELEGATE.navigationController pushViewController:mDeviceManageViewController animated:YES];
    
    BKSelectRobotModelCtr *ctr = [[BKSelectRobotModelCtr alloc]init];
    [APP_DELEGATE.navigationController pushViewController:ctr animated:YES];

}
@end
