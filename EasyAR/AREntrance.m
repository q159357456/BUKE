//
//  AREntrance.m
//  MiniBuKe
//
//  Created by chenheng on 2019/4/26.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "AREntrance.h"
#import "EasyarViewController.h"
#import "ARAudioManager.h"
@implementation AREntrance

+(instancetype)initialEntranceWithFrame:(CGRect)frame
{
    
    return [[AREntrance alloc]initWithFrame:frame];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        [self setImage:[UIImage imageNamed:@"easyar_enter_icon"] forState:UIControlStateNormal];
        
        [self addTarget:self action:@selector(comeToEasyAR) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)comeToEasyAR{
  
    EasyarViewController *vc = [[EasyarViewController alloc]init];
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
//    [[ARAudioManager singleton] palyUnableVoice];
    
}
@end
