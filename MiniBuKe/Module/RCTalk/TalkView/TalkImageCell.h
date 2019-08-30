//
//  TalkImageCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TalkMessageModel;

typedef void  (^ClickBlock) (TalkMessageModel * model);

@interface TalkImageCell : UITableViewCell

//@property(nonatomic,strong) UIView *readView;

@property (nonatomic,strong) TalkMessageModel* messageModel;
@property(nonatomic,copy) ClickBlock doubleblock;
@property(nonatomic,copy) ClickBlock singleblock;
@property(nonatomic,copy) ClickBlock resendblock;


+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(TalkMessageModel *)model;

+(CGFloat)tableHeightWithModel:(TalkMessageModel *)model;

-(void)setDoubleClickBlock:(ClickBlock )doubleClickBlock;
-(void)setSingleClickBlock:(ClickBlock )singleClickBlock;
-(void)setResendClickBlock:(ClickBlock )resendClickBlock;

-(void)stopVoiceAnimation;
-(void)startVoiceAnimation;
-(void)startSentMessageAnimation;
-(void)stopSentMessageAnimation;
-(BOOL)VoiceAnimationing;
@end
