//
//  PromptView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PromptView.h"

@interface PromptView ()

@property (nonatomic,strong) IBOutlet UILabel *title;
@property (nonatomic,strong) IBOutlet UITextView *contentTextView;
@property (nonatomic,strong) IBOutlet UIButton *leftButton;
@property (nonatomic,strong) IBOutlet UIButton *rightButton;

@property (nonatomic,strong) VersionInfo *mVersionInfo;
@property (nonatomic) VersionUpdateType mVersionUpdateType;

@end

@implementation PromptView

+(instancetype) xibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PromptView" owner:nil options:nil] lastObject];
}

-(void) updateViewData:(VersionInfo *) mVersionInfo setVersionUpdateType:(VersionUpdateType) mVersionUpdateType
{
    self.mVersionInfo = mVersionInfo;
    self.mVersionUpdateType = mVersionUpdateType;
    
    self.title.text = [NSString stringWithFormat:@"%@版本发布了",mVersionInfo.version];
    self.contentTextView.text = mVersionInfo.mDescription;
    
    switch (self.mVersionUpdateType) {
        case VersionUpdateTypeForce:
        {
            [self.leftButton setTitle:@"退出" forState:UIControlStateNormal];
        }
            break;
        case VersionUpdateTypeGray:
        {
            [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
        }
            break;
        case VersionUpdateTypeRecommend:
        {
            
        }
            break;
        default:
            break;
    }
}

-(IBAction)onCancel:(id) sender
{
    NSLog(@"===> onCancel <===");
    switch (self.mVersionUpdateType) {
        case VersionUpdateTypeForce:
        {
            exit(0);
        }
            break;
        case VersionUpdateTypeGray:
        {
            
        }
            break;
        case VersionUpdateTypeRecommend:
        {
            
        }
            break;
        default:
            break;
    }
    if (self.delegate != nil) {
        [self.delegate onCancel];
    }
}

-(IBAction)onAffirm:(id) sender
{
    NSLog(@"===> onAffirm <===");
    switch (self.mVersionUpdateType) {
        case VersionUpdateTypeForce:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.mVersionInfo.path]];
            
        }
            break;
        case VersionUpdateTypeGray:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.mVersionInfo.path]];
        }
            break;
        case VersionUpdateTypeRecommend:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.mVersionInfo.path]];
        }
            break;
        default:
            break;
    }
    
}


@end
