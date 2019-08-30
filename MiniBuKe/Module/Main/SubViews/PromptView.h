//
//  PromptView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VersionInfo.h"

@protocol PromptViewDelegate <NSObject>

-(void) onCancel;

-(void) onAffirm;

@end

@interface PromptView : UIView

@property (nonatomic ,weak)id <PromptViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

+(instancetype) xibView;

-(void) updateViewData:(VersionInfo *) mVersionInfo setVersionUpdateType:(VersionUpdateType) mVersionUpdateType;

@end
