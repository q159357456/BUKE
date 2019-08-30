//
//  TalkVoiceCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TalkVoiceCell.h"
#import "TalkMessageModel.h"
#import "DataBaseTool.h"
#import "TencentIMManager.h"

#define LEFT_WITH ([UIScreen mainScreen].bounds.size.width > 750 ? 55:52.5)
#define RIGHT_WITH ([UIScreen mainScreen].bounds.size.width > 750 ? 89:73)

#define MAX_IMAGE_WH 100.0

#define LEFT_ICON @"voiceIcon_left"
#define RIGHT_ICON @"voiceIcon_right"

@interface TalkVoiceCell()

@property(nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UIImageView* voiceAnimationImageView;
@property (nonatomic,strong) UIImageView* coversImageView;
@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UIImageView *contextBack;
@property(nonatomic,strong) UILabel *nickLabel;
@property(nonatomic,strong) UILabel *secondsLabel;

@property(nonatomic,strong) UIImageView *rightLogoImgView;
@property(nonatomic,strong) UIImageView *rightContext;
@property(nonatomic,strong) UIImageView *rightAnimationImg;
@property(nonatomic,strong) UILabel *rightSecondsLabel;
@property(nonatomic,strong) UIImageView *rightCoverImg;

@property (nonatomic,strong) UIView *readView;
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation TalkVoiceCell

+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(TalkMessageModel *)model
{
    static NSString *identifier = @"voiceCell";
    TalkVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[TalkVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        for (UIView *v  in [self.contentView subviews]) {
            [v removeFromSuperview];
        }
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.frame = CGRectMake((self.frame.size.width - 120)*0.5, 10, 120, 17);
        self.timeLabel.backgroundColor = COLOR_STRING(@"#CECECE");
        self.timeLabel.textColor = COLOR_STRING(@"#FFFFFF");
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.layer.cornerRadius = 4;
        self.timeLabel.layer.borderColor = (COLOR_STRING(@"#CECECE")).CGColor;
        self.timeLabel.layer.borderWidth = 1;
        self.timeLabel.layer.masksToBounds = YES;
        [self addSubview:self.timeLabel];
        
        //左边
        UIImageView *logoImage = [[UIImageView alloc] init];
        logoImage.frame = CGRectMake(10, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 10, 40, 40);
        logoImage.layer.cornerRadius = logoImage.frame.size.width * 0.5;
        logoImage.layer.masksToBounds = YES;
        self.logoImageView = logoImage;
        [self addSubview:logoImage];
        
        UILabel *nickLabel = [[UILabel alloc]init];
        nickLabel.frame = CGRectMake(LEFT_WITH + 3, self.logoImageView.frame.origin.y, 200, 17);
        nickLabel.font = MY_FONT(14);
        nickLabel.textColor = COLOR_STRING(@"#999999");
        self.nickLabel = nickLabel;
        [self addSubview:nickLabel];
            
        self.contextBack = [[UIImageView alloc]init];
        self.contextBack.frame = CGRectMake(LEFT_WITH, self.nickLabel.frame.origin.y + self.nickLabel.frame.size.height, 100, 40);//宽度待model传值更新
        self.contextBack.image = [[UIImage imageNamed:@"voiceMsg_backleft"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        self.contextBack.userInteractionEnabled = YES;
        [self addSubview:self.contextBack];
        
        self.voiceAnimationImageView = [[UIImageView alloc]init];
        self.voiceAnimationImageView.frame = CGRectMake(12, 12, 12, 16);
        self.voiceAnimationImageView.animationRepeatCount = 0;
        self.voiceAnimationImageView.animationDuration = 2;
        self.voiceAnimationImageView.image = [UIImage imageNamed:@"voiceMsgLeft3"];
        self.voiceAnimationImageView.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"voiceMsgLeft3"],[UIImage imageNamed:@"voiceMsgLeft2"],[UIImage imageNamed:@"voiceMsgLeft1"],[UIImage imageNamed:@"voiceMsgLeft2"],[UIImage imageNamed:@"voiceMsgLeft3"],nil];
        [self.contextBack addSubview:self.voiceAnimationImageView];
        
        self.secondsLabel = [[UILabel alloc]init];
        self.secondsLabel.textColor = COLOR_STRING(@"#999999");
        self.secondsLabel.font = MY_FONT(15);
        [self.contextBack addSubview:_secondsLabel];
//        [self.secondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contextBack);
//            make.left.mas_equalTo(self.contextBack.mas_right).offset(5);
//        }];
//
        self.coversImageView = [[UIImageView alloc]init];
        self.coversImageView.frame = self.contextBack.frame;
        self.coversImageView.image = [[UIImage imageNamed:@"voiceMsg_backleftCover"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        self.coversImageView.hidden = YES;
        [self addSubview:self.coversImageView];
        
        //右边(不显示自己昵称)
        self.rightLogoImgView = [[UIImageView alloc] init];
        self.rightLogoImgView.frame = CGRectMake(self.frame.size.width - 10 - 40, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 10, 40, 40);
        self.rightLogoImgView.layer.cornerRadius = logoImage.frame.size.width * 0.5;
        self.rightLogoImgView.layer.masksToBounds = YES;
        [self addSubview:self.rightLogoImgView];
        
        self.rightContext = [[UIImageView alloc] init];
        self.rightContext.frame = CGRectMake(self.frame.size.width - LEFT_WITH - 100, self.rightLogoImgView.frame.origin.y, 100, 40);//待确定语音长度后更新
        self.rightContext.image = [[UIImage imageNamed:@"voiceMsg_backRight"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        self.rightContext.userInteractionEnabled = YES;
        [self addSubview:self.rightContext];
        
        self.rightAnimationImg = [[UIImageView alloc] init];
        self.rightAnimationImg.frame = CGRectMake(100-12-11, 12, 11, 16);//待确定语音长度后更新
        self.rightAnimationImg.animationRepeatCount = 0;
        self.rightAnimationImg.animationDuration = 2;
        self.rightAnimationImg.image = [UIImage imageNamed:@"voiceMsgRight3"];
        self.rightAnimationImg.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"voiceMsgRight3"],[UIImage imageNamed:@"voiceMsgRight2"],[UIImage imageNamed:@"voiceMsgRight1"],[UIImage imageNamed:@"voiceMsgRight2"],[UIImage imageNamed:@"voiceMsgRight3"],nil];
        [self.rightContext addSubview:self.rightAnimationImg];
        
        self.rightSecondsLabel = [[UILabel alloc] init];
        self.rightSecondsLabel.textColor = COLOR_STRING(@"#999999");
        self.rightSecondsLabel.font = MY_FONT(15);
        self.rightSecondsLabel.textAlignment = NSTextAlignmentRight;
        [self.rightContext addSubview:self.rightSecondsLabel];
//        [self.rightSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.rightContext);
//            make.right.mas_equalTo(self.rightContext.mas_left).offset(-5);
//        }];
        
        self.rightCoverImg = [[UIImageView alloc] init];
        self.rightCoverImg.frame = self.rightContext.frame;
        self.rightCoverImg.image = [[UIImage imageNamed:@"voiceMsg_backRightCover"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        self.rightCoverImg.hidden = YES;
        [self addSubview:self.rightCoverImg];
        
        
        //添加点击事件
        [self contextBackAddGesture];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.messageModel.messageSenderType == MessageSenderTypeOther) {
        
    }else if (self.messageModel.messageSenderType == MessageSenderTypeSelf){
        
    }
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier messageModel:(TalkMessageModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        
        for (UIView *v  in [self.contentView subviews]) {
            [v removeFromSuperview];
        }
        
//        _masTop = 10;
        
        if (model.showMessageTime) {
            
//            _masTop = 37;
            //初始化 系统提示时间
//            [self initMessageTimeUIWithModel:model];
        }
        
        _contextBack = [[UIImageView alloc] init];
        _contextBack.userInteractionEnabled = YES;
        
        _secondsLabel = [[UILabel alloc]init];
        
        self.voiceAnimationImageView = [[UIImageView alloc] init];
        self.voiceAnimationImageView.animationRepeatCount = 0;
        self.voiceAnimationImageView.animationDuration = 2;
        
        self.coversImageView = [[UIImageView alloc] init];
        self.coversImageView.userInteractionEnabled = YES;
        
        if (model.messageType == MessageTypeVoice) {
            
//            [self initVoiceMessageWithModel:model];
        }
        
        //添加手势
        [self contextBackAddGesture];
        
        //设置 消息覆盖
//        [self initCoversImageViewWithModel:model];
        
        //设置送达状态(只有其他人才会出现送达状态)
        if (model.messageSenderType == MessageSenderTypeOther) {
            [self setSendStatusWithModel:model];
        }
        
        //监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuCotrollerWillHidden:) name:UIMenuControllerWillHideMenuNotification object:nil];
    }
    
    return self;
}


+(CGFloat)tableHeightWithModel:(TalkMessageModel *)model
{
    CGFloat masTop = 10;
    if (model.showMessageTime) {
        masTop = 37;
    }
    
    if (model.messageType == MessageTypeText) {
        
        CGFloat maxWith = [UIScreen mainScreen].bounds.size.width - LEFT_WITH-RIGHT_WITH -14 -12 -4;
        
        UIFont *textFont = MY_FONT(16);
        NSDictionary *attributes = @{NSFontAttributeName: textFont};
        CGRect rect = [model.messageText boundingRectWithSize:CGSizeMake(maxWith, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        return rect.size.height + 26 + masTop + 20;
        
    }else if (model.messageType == MessageTypeVoice){
        
        CGFloat height = model.showNickName ? 40 + masTop + 15 + 17 : 40 + masTop + 15;
        
        NSLog(@"TalkVoiceCell---height====>%f",height);
        
        return height;
    }
    
    return 0;
}

-(void)setSendStatusWithModel:(TalkMessageModel *)model
{
    // 只有送达成功 才会出现 已读 和 未读的情况  text
    if (model.messageSentStatus == MessageSentStatusSended)
    {
        UILabel *readStatusLabel = [[UILabel alloc] init];
        readStatusLabel.font = MY_FONT(12);
        
        if (model.messageReadStatus == MessageReadStatusRead) {
            readStatusLabel.text = @"已读";
            readStatusLabel.textColor = COLOR_STRING(@"#BABABA");
        }else if (model.messageReadStatus == MessageReadStatusUnRead){
            readStatusLabel.text = @"未读";
            readStatusLabel.textColor = COLOR_STRING(@"#C00000");
        }
        
        [self addSubview:readStatusLabel];
        
        if (model.messageType == MessageTypeVoice) {
            
            [readStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_contextBack);
                make.right.mas_equalTo(_secondsLabel.mas_left).offset(-10);;
            }];
            
        }else{
            
            [readStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_contextBack);
                make.right.mas_equalTo(_contextBack.mas_left).offset(-10);
            }];
        }
    }
    else if(model.messageSentStatus == MessageSentStatusUnSended)
    {
        UIButton *unsendButton = [[UIButton alloc] init];
        [unsendButton setImage:[UIImage imageNamed:@"voiceMsg_resendBtn"] forState:UIControlStateNormal];
        [unsendButton addTarget:self action:@selector(reSendAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:unsendButton];
        
        if (model.messageType == MessageTypeVoice) {
            
            [unsendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_contextBack);
                make.right.mas_equalTo(_secondsLabel.mas_left).offset(-10);;
            }];
            
        }else{
            [unsendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_contextBack);
                make.right.mas_equalTo(_contextBack.mas_left).offset(-10);;
            }];
        }
    }
    else if(model.messageSentStatus == MessageSentStatusSending)
    {
        UIActivityIndicatorView *acview = [[UIActivityIndicatorView alloc] init];
        [acview setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:acview];
        [acview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_contextBack);
            make.right.mas_equalTo(_contextBack.mas_left).offset(-10);;
        }];
        [acview startAnimating];
    }
}

-(void)showLeftWithModel:(TalkMessageModel *)model Time:(NSString *)messageTime
{
    self.rightLogoImgView.hidden = YES;
    self.rightContext.hidden = YES;
    self.rightSecondsLabel.hidden = YES;
    
    self.logoImageView.hidden = NO;
    self.contextBack.hidden = NO;
    self.secondsLabel.hidden = NO;
    
    if (model.showMessageTime) {
        self.timeLabel.hidden = NO;
        UIFont *font = MY_FONT(12);
        self.timeLabel.font = font;
        self.timeLabel.text = messageTime;
        CGSize size = [self.timeLabel.text sizeWithAttributes:@{NSFontAttributeName:font}];
        //ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
        CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        self.timeLabel.frame = CGRectMake((self.frame.size.width - labelSize.width - 10)*0.5, 10, labelSize.width + 10, 17);
        
        self.logoImageView.frame = CGRectMake(10, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 10, 40, 40);
    }else{
        self.timeLabel.hidden = YES;
        self.logoImageView.frame = CGRectMake(10, 10, 40, 40);
    }
    NSLog(@"talk message model ==> %i ==>%@",model.mId,model.nickName);
//    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:LEFT_ICON]];
    
//    if (model.messageSenderType == MessageSenderTypeRobot) {
//        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[@"" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:LEFT_ICON]];
////        self.nickLabel.text = @"小布壳";
//    } else {
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[model.logoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:LEFT_ICON]];
//    }
    
    if (model.showNickName) {
        self.nickLabel.hidden = NO;
        self.nickLabel.frame = CGRectMake(LEFT_WITH + 3, self.logoImageView.frame.origin.y, 200, 17);
        self.nickLabel.text = model.nickName;
        
        self.contextBack.frame = CGRectMake(LEFT_WITH, self.nickLabel.frame.origin.y + self.nickLabel.frame.size.height, [self voiceLength:model.duringTime], 40);
    }else{
        self.nickLabel.hidden = YES;
        self.contextBack.frame = CGRectMake(LEFT_WITH, self.logoImageView.frame.origin.y, [self voiceLength:model.duringTime], 40);
    }
    self.voiceAnimationImageView.frame = CGRectMake(12, 12, 12, 16);
    self.secondsLabel.text = [NSString stringWithFormat:@"%lu ''",(unsigned long)model.duringTime];
    [self.secondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contextBack);
        make.left.mas_equalTo(self.voiceAnimationImageView.mas_right).offset(5);
    
    }];
    
    self.coversImageView.frame = self.contextBack.frame;
    
    if (self.readView == nil) {
        //添加已读/未读 红点
        self.readView = [[UIView alloc] init];
        self.readView.layer.cornerRadius = 8*0.5;
        self.readView.backgroundColor = [UIColor redColor];
//        [self.contextBack addSubview:self.readView];
//        [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.contextBack).offset(2);
//            make.right.mas_equalTo(self.contextBack).offset(-4);
//            make.size.mas_equalTo(CGSizeMake(8, 8));
//        }];
        [self.contentView addSubview:self.readView];
        [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contextBack.mas_centerY);
            make.left.mas_equalTo(self.contextBack.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    
    
    if (model.messageReadStatus == MessageReadStatusUnRead ) {
        self.readView.hidden = NO;
    }else if (model.messageReadStatus == MessageReadStatusRead ){
        self.readView.hidden = YES;
    }
    
    
    
    NSLog(@"====> self.readView.hidden init <====");
}

-(void)showRightWithModel:(TalkMessageModel *)model Time:(NSString *)messageTime
{
    self.readView.hidden = YES;
    self.logoImageView.hidden = YES;
    self.nickLabel.hidden = YES;
    self.contextBack.hidden = YES;
    self.secondsLabel.hidden = YES;
    
    self.rightLogoImgView.hidden = NO;
    self.rightContext.hidden = NO;
    self.rightSecondsLabel.hidden = NO;
    if (model.showMessageTime) {
        self.timeLabel.hidden = NO;
        UIFont *font = MY_FONT(12);
        self.timeLabel.font = font;
        self.timeLabel.text = messageTime;
        CGSize size = [self.timeLabel.text sizeWithAttributes:@{NSFontAttributeName:font}];
        //ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
        CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        self.timeLabel.frame = CGRectMake((self.frame.size.width - labelSize.width - 10)*0.5, 10, labelSize.width + 10, 17);
        
        self.rightLogoImgView.frame = CGRectMake(self.frame.size.width - 10 - 40, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 10, 40, 40);
    }else{
        self.timeLabel.hidden = YES;
        self.rightLogoImgView.frame = CGRectMake(self.frame.size.width - 10 - 40, 10, 40, 40);
    }
    [self.rightLogoImgView sd_setImageWithURL:[NSURL URLWithString:[model.logoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:RIGHT_ICON]];
    
    
    self.rightContext.frame = CGRectMake(self.frame.size.width - LEFT_WITH - [self voiceLength:model.duringTime], self.rightLogoImgView.frame.origin.y, [self voiceLength:model.duringTime], 40);
    self.rightAnimationImg.frame = CGRectMake([self voiceLength:model.duringTime]-12-11, 12, 11, 16);
    self.rightSecondsLabel.text = [NSString stringWithFormat:@"%lu ''",(unsigned long)model.duringTime];
    [self.rightSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightContext);
        make.right.mas_equalTo(self.rightAnimationImg.mas_left).offset(-5);
  
    }];
    
    self.rightCoverImg.frame = self.rightContext.frame;

}

-(CGFloat)voiceLength:(NSInteger)seconds{
    
    if (seconds == 0) {
        return 60;
    }
    
    //    6~197 6p~230
    // 60
    
    CGFloat max = [UIScreen mainScreen].bounds.size.width > 375 ? 200:167;
    NSLog(@"max === %f",max);
    CGFloat lenth = 60 + (seconds-1)*(max-60)*1.0/60.0;
        
    if ([UIScreen mainScreen].bounds.size.width <= 320) {
        if (lenth > 200.0) {
            lenth = 200.0;
        }
        
    }else if ([UIScreen mainScreen].bounds.size.width < 375){
        if (lenth > 230.0) {
            lenth = 230.0;
        }
        
    }else{
        if (lenth > 263.0) {
           lenth = 263.0;
        }
    }
    
    return lenth;
}

-(void)contextBackAddGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.contextBack addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap:)];
    [self.rightContext addGestureRecognizer:rightTap];
}

-(void)reSendAction:(UIButton *)sender
{
    if (self.resendblock) {
        self.resendblock(self.messageModel);
    }
}

#pragma mark - 点击事件
-(void)handleSingleTap:(id)sender
{
    NSLog(@"====> handleSingleTap <====");
    if (self.messageModel.messageType != MessageTypeText) {
        NSLog(@"====> handleSingleTap 2 <====");
        
        if (self.singleblock) {
            self.singleblock(self.messageModel);
        }
        
        if (self.messageModel.messageType == MessageTypeVoice) {
            NSLog(@"====> handleSingleTap 3 <====");
            
            __block TalkVoiceCell/*主控制器*/ *weakSelf = self;
            //已读状态 隐藏小红点
            self.readView.hidden = YES;
//            self.readView.backgroundColor = [UIColor clearColor];
            
            self.messageModel.messageReadStatus = MessageReadStatusRead;
//            [self startVoiceAnimation];
            //已读/未读
            [DataBaseTool updateMessageModel:self.messageModel];
//            [[TencentIMManager defautManager] setMessageRead:[NSString stringWithFormat:@"%d",self.messageModel.mId]];
            
            self.coversImageView.hidden = NO;
            dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
                weakSelf.coversImageView.hidden = YES;
            });
            
//            dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.messageModel.duringTime * NSEC_PER_SEC));
//            dispatch_after(delayTime2, dispatch_get_main_queue(), ^{
//                if (self.voiceAnimationImageView.isAnimating) {
//                    NSLog(@"===> dispatch_after(delayTime2, dispatch_get_main_queue() <===");
//                    [weakSelf stopVoiceAnimation];
//                }
//            });
            if (self.timer != nil) {
                [self.timer invalidate];
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:[[NSString stringWithFormat:@"%tu",self.messageModel.duringTime] floatValue] target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
        }
    }
}

-(void)rightTap:(id)sender
{
    NSLog(@"====> rightTap <====");
    if (self.singleblock) {
        self.singleblock(self.messageModel);
    }
    
    self.rightCoverImg.hidden = NO;
    
    __block TalkVoiceCell/*主控制器*/ *weakSelf = self;
    dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
        weakSelf.rightCoverImg.hidden = YES;
    });
//    dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.messageModel.duringTime * NSEC_PER_SEC));
//    dispatch_after(delayTime2, dispatch_get_main_queue(), ^{
//        if (weakSelf.rightAnimationImg.isAnimating) {
//            NSLog(@"===> weakSelf.rightAnimationImg <===");
//            [weakSelf.rightAnimationImg stopAnimating];
//        }
//    });
    if (self.timer != nil) {
        [self.timer invalidate];
    }
    
    NSLog(@"rightTap ====> %f => %f",[[NSString stringWithFormat:@"%tu",self.messageModel.duringTime] floatValue],([[NSString stringWithFormat:@"%tu",self.messageModel.duringTime] floatValue] / 10.0f ));
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[[NSString stringWithFormat:@"%tu",self.messageModel.duringTime] floatValue] target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
}

-(void)timerAction:(NSTimer * )sender
{
    [self stopVoiceAnimation];
}

-(void)menuCotrollerWillHidden:(id)sender
{
    if (!self.coversImageView.isHidden) {
        self.coversImageView.hidden = YES;
    }
}

-(void)setResendClickBlock:(ClickBlock )resendClickBlock
{
    self.resendblock = resendClickBlock;
}

-(void)setSingleClickBlock:(ClickBlock )singleClickBlock
{
    self.singleblock = singleClickBlock;
}

-(void)setDoubleClickBlock:(ClickBlock )doubleClickBlock
{
    self.doubleblock = doubleClickBlock;
}

#pragma mark - 动画相关
-(void)startVoiceAnimation
{
    if (self.rightAnimationImg != nil) {
        [self.rightAnimationImg startAnimating];
    }
    if (self.voiceAnimationImageView != nil) {
        [self.voiceAnimationImageView startAnimating];
    }
    
}
-(void)stopVoiceAnimation
{
    NSLog(@"===> stopVoiceAnimation <===");
    if (self.rightAnimationImg != nil) {
        if ([self VoiceAnimationing]) {
             [self.rightAnimationImg stopAnimating];
        }
       
    }
    if (self.voiceAnimationImageView != nil) {
        if ([self VoiceAnimationing]) {
             [self.voiceAnimationImageView stopAnimating];
        }
       
    }
}

-(void)startSentMessageAnimation
{
    
}
-(void)stopSentMessageAnimation
{
    
}


#pragma mark - getter/setter
-(void)setMessageModel:(TalkMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    //与当前时间进行比对 --> 显示时间
    
    NSString *time = [self compareTimeWith:messageModel.messageTime];
    
    
    switch (messageModel.messageSenderType) {
        case MessageSenderTypeOther:
            
            [self showLeftWithModel:messageModel Time:time];
            
            break;
            
        case MessageSenderTypeSelf:
            
            [self showRightWithModel:messageModel Time:time];
            
            break;
            
        default:
            break;
    }
    
}

-(NSString *)compareTimeWith:(NSString *)creatTimeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [formatter dateFromString:creatTimeStr];
    //得到与当前时间差
//    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
//    timeInterval = -timeInterval;
    
//    long temp = 0;
//    NSString *result;
    
//    if (timeDate.isToday) {
//        result = [creatTimeStr substringWithRange:NSMakeRange(creatTimeStr.length - 8, 5)];
//    }else{
//        if (timeDate.isThisYear) {
//            result = [creatTimeStr substringWithRange:NSMakeRange(5, 11)];//显示日期时间(月份)
//        }else{
//            result = [creatTimeStr substringToIndex:creatTimeStr.length - 3];
//        }
//    }
    
    
//    if ((temp = timeInterval/3600) < 24){
//        result = [creatTimeStr substringWithRange:NSMakeRange(creatTimeStr.length - 8, 5)];
//    }else if ((temp = timeInterval/3600) > 24 && (temp = timeInterval/3600) < 48){
//        result = [NSString stringWithFormat:@"昨天 %@",[creatTimeStr substringWithRange:NSMakeRange(creatTimeStr.length - 8, 5)]];
//    }else if ((temp = timeInterval/(3600 * 24)) < 365){
//        result = [creatTimeStr substringWithRange:NSMakeRange(5, 11)];//显示日期时间(月份)
//        NSLog(@"result == > %@",result);
//    }else{
//        result = [creatTimeStr substringToIndex:creatTimeStr.length - 3];
//    }
    
    return [timeDate DateTransformTimeShuoshuoStr];
}

-(BOOL)VoiceAnimationing
{
    if (self.messageModel.messageSenderType == MessageSenderTypeSelf)
    {
        return self.rightAnimationImg.animating;
    }else
    {
        return self.voiceAnimationImageView.animating;
    }
}

-(void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
