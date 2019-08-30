//
//  TalkImageCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TalkImageCell.h"
#import "TalkMessageModel.h"
#import "DataBaseTool.h"
#import "TencentIMManager.h"
#define LEFT_WITH ([UIScreen mainScreen].bounds.size.width > 750 ? 55:52.5)
#define RIGHT_WITH ([UIScreen mainScreen].bounds.size.width > 750 ? 89:73)

#define MAX_IMAGE_WH 120.0

#define LEFT_ICON @"voiceIcon_left"
#define RIGHT_ICON @"voiceIcon_right"

@interface TalkImageCell()

@property(nonatomic,strong) UILabel *timeLabel;

@property(nonatomic,strong) UIImageView *logoImageView;
@property(nonatomic,strong) UILabel *nickLabel;
@property(nonatomic,strong) UIImageView *leftImgView;
@property (nonatomic,strong) UIImageView* voiceAnimationImageView;
@property (nonatomic,strong) UIImageView* coversImageView;
@property(nonatomic,strong) UIImageView *contextBack;
@property(nonatomic,strong) UILabel *secondsLabel;

@property(nonatomic,strong) UIImageView *rightLogoImgView;
@property(nonatomic,strong) UIImageView *rightContext;
@property(nonatomic,strong) UIImageView *rightImgView;
@property(nonatomic,strong) UIImageView *rightAnimationView;
@property(nonatomic,strong) UILabel *rightSecondsLabel;
@property(nonatomic,strong) UIImageView *rightCoverImg;

@property (nonatomic,strong) UIView *readView;
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation TalkImageCell

+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(TalkMessageModel *)model
{
    static NSString *identifier = @"imageCell";
    TalkImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {

        cell = [[TalkImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        
        self.contextBack = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"voiceMsg_backleft"] stretchableImageWithLeftCapWidth:10 topCapHeight:25]];
        self.contextBack.frame = CGRectMake(LEFT_WITH, self.nickLabel.frame.origin.y + self.nickLabel.frame.size.height, 90, 90 + 20);
        self.contextBack.userInteractionEnabled = YES;
        [self addSubview:self.contextBack];
        
        self.leftImgView = [[UIImageView alloc] init];
        self.leftImgView.frame = CGRectMake(0, 0, self.contextBack.frame.size.width - 20, self.contextBack.frame.size.height - 20);
        self.leftImgView.userInteractionEnabled = YES;
        [self.contextBack addSubview:self.leftImgView];
        
        //添加时长和动画
        self.secondsLabel = [[UILabel alloc] init];
        self.secondsLabel.font = MY_FONT(15);
        self.secondsLabel.textAlignment = NSTextAlignmentRight;
        self.secondsLabel.textColor = COLOR_STRING(@"#999999");
        [self.contextBack addSubview:self.secondsLabel];
        [self.secondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contextBack.mas_right).offset(-5);
            make.top.mas_equalTo(self.contextBack.mas_bottom).offset(-21);
        }];
        
        self.voiceAnimationImageView = [[UIImageView alloc] init];
        self.voiceAnimationImageView.animationRepeatCount = 0;
        self.voiceAnimationImageView.animationDuration = 2;
        self.voiceAnimationImageView.image = [UIImage imageNamed:@"voiceMsgLeft3"];
        self.voiceAnimationImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"voiceMsgLeft3"],[UIImage imageNamed:@"voiceMsgLeft2"],[UIImage imageNamed:@"voiceMsgLeft1"],[UIImage imageNamed:@"voiceMsgLeft2"],[UIImage imageNamed:@"voiceMsgLeft3"],nil];
        [self.contextBack addSubview:self.voiceAnimationImageView];
        [self.voiceAnimationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.secondsLabel.mas_left).offset(-5);
            make.top.mas_equalTo(self.contextBack.mas_bottom).offset(-20);
            make.size.mas_equalTo(CGSizeMake(12, 16));
        }];
        
        //设置消息覆盖
        self.coversImageView = [[UIImageView alloc]init];
        self.coversImageView.frame = self.contextBack.frame;
        self.coversImageView.image = [[UIImage imageNamed:@"voiceMsg_backleftCover"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        self.coversImageView.hidden = YES;
        [self addSubview:self.coversImageView];
        
        //右边
        self.rightLogoImgView = [[UIImageView alloc] init];
        self.rightLogoImgView.frame = CGRectMake(self.frame.size.width - 10 - 40, self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height + 10, 40, 40);
        self.rightLogoImgView.layer.cornerRadius = logoImage.frame.size.width * 0.5;
        self.rightLogoImgView.layer.masksToBounds = YES;
        [self addSubview:self.rightLogoImgView];
        
        self.rightContext = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"voiceMsg_backRight"] stretchableImageWithLeftCapWidth:10 topCapHeight:25]];
        self.rightContext.frame = CGRectMake(self.frame.size.width - LEFT_WITH - 90, self.rightLogoImgView.frame.origin.y, 90, 90 + 20);//宽高待传入图片来定
        self.rightContext.userInteractionEnabled = YES;
        [self addSubview:self.rightContext];
        
        self.rightImgView = [[UIImageView alloc] init];
        self.rightImgView.frame = CGRectMake(0, 0, self.rightContext.frame.size.width, self.rightContext.frame.size.height - 20);
        self.rightImgView.userInteractionEnabled = YES;
        [self.rightContext addSubview:self.rightImgView];
        
        self.rightSecondsLabel = [[UILabel alloc] init];
        self.rightSecondsLabel.font = MY_FONT(15);
        self.rightSecondsLabel.textColor = COLOR_STRING(@"#999999");
        [self.rightContext addSubview:self.rightSecondsLabel];
        [self.rightSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rightContext).offset(5);
            make.top.mas_equalTo(self.rightContext.mas_bottom).offset(-21);
        }];
        
        self.rightAnimationView = [[UIImageView alloc] init];
        self.rightAnimationView.animationRepeatCount = 0;
        self.rightAnimationView.animationDuration = 2;
        self.rightAnimationView.image = [UIImage imageNamed:@"voiceMsgRight3"];
        self.rightAnimationView.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"voiceMsgRight3"],[UIImage imageNamed:@"voiceMsgRight2"],[UIImage imageNamed:@"voiceMsgRight1"],[UIImage imageNamed:@"voiceMsgRight2"],[UIImage imageNamed:@"voiceMsgRight3"],nil];
        [self.rightContext addSubview:self.rightAnimationView];
        [self.rightAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.rightSecondsLabel.mas_right).offset(5);
            make.top.mas_equalTo(self.rightContext.mas_bottom).offset(-20);
            make.size.mas_equalTo(CGSizeMake(12, 16));
        }];
        
        //设置消息覆盖
        self.rightCoverImg = [[UIImageView alloc] init];
        self.rightCoverImg.frame = self.rightContext.frame;
        self.rightCoverImg.image = [[UIImage imageNamed:@"voiceMsg_backRightCover"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
        self.rightCoverImg.hidden = YES;
        [self addSubview:self.rightCoverImg];
        
        //添加手势
        [self contextBackAddGesture];
        
    }
    
    return self;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier messageModel:(TalkMessageModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.messageModel = model;
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
        
        if (model.messageType == MessageTypeImage) {
            
//            [self initImageMessageWithModel:model];
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
    
    if (model.messageType == MessageTypeImage) {
        
        CGSize imageSize = [[self alloc] imageShowSize:model.imageSmall];
        CGFloat height = model.showNickName ? imageSize.height + masTop + 20 + 17 + 15: imageSize.height + masTop + 20 + 15;
        
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
        
        if (model.messageType == MessageTypeImage) {
            
            [readStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_contextBack);
                make.right.mas_equalTo(_secondsLabel.mas_left).offset(-10);;
            }];
        }
    }
    else if(model.messageSentStatus == MessageSentStatusUnSended)
    {
        UIButton *unsendButton = [[UIButton alloc] init];
        [unsendButton setImage:[UIImage imageNamed:@"voiceMsg_resendBtn"] forState:UIControlStateNormal];
        [unsendButton addTarget:self action:@selector(reSendAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:unsendButton];
        
        if (model.messageType == MessageTypeImage) {
            
            [unsendButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_contextBack);
                make.right.mas_equalTo(_secondsLabel.mas_left).offset(-10);;
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


#pragma mark - getter/setter
-(void)setMessageModel:(TalkMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    NSString *time = [self compareTimeWith:messageModel.messageTime];
//    NSLog(@"image_time====>%@",time);
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

-(void)showLeftWithModel:(TalkMessageModel *)model Time:(NSString *)messageTime
{
    self.rightLogoImgView.hidden = YES;
    self.rightContext.hidden = YES;
    
    self.logoImageView.hidden = NO;
    self.contextBack.hidden = NO;
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
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:[model.logoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:LEFT_ICON]];
    
    CGSize imageSize = [self imageShowSize:model.imageSmall];
    
    if (model.showNickName) {
        self.nickLabel.hidden = NO;
        self.nickLabel.frame = CGRectMake(LEFT_WITH + 3, self.logoImageView.frame.origin.y, 200, 17);
        self.nickLabel.text = model.nickName;
        
        self.contextBack.frame = CGRectMake(LEFT_WITH, self.nickLabel.frame.origin.y + self.nickLabel.frame.size.height, 100, 100);
    }else{
        self.nickLabel.hidden = YES;
        self.contextBack.frame = CGRectMake(LEFT_WITH, self.logoImageView.frame.origin.y, 100, 100);
    }
    
    self.leftImgView.frame = CGRectMake(10, 10, 67, 67);
    self.leftImgView.image = model.imageSmall;
    
    self.secondsLabel.text = [NSString stringWithFormat:@"%lu ''",(unsigned long)model.duringTime];
    [self.secondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contextBack.mas_right).offset(-5);
        make.top.mas_equalTo(self.contextBack.mas_bottom).offset(-21);
    }];
    [self.secondsLabel sizeToFit];
    
    [self.voiceAnimationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.secondsLabel.mas_left).offset(-5);
        make.top.mas_equalTo(self.contextBack.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(12, 16));
    }];
    
    self.coversImageView.frame = self.contextBack.frame;
    
    //添加已读/未读 红点
    if (self.readView == nil) {
        self.readView = [[UIView alloc] init];
        self.readView.layer.cornerRadius = 8*0.5;
        self.readView.backgroundColor = [UIColor redColor];
        [self.contextBack addSubview:self.readView];
        [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contextBack).offset(2);
            make.right.mas_equalTo(self.contextBack).offset(-4);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    
    if (model.messageReadStatus == MessageReadStatusUnRead) {
        self.readView.hidden = NO;
    }else if (model.messageReadStatus == MessageReadStatusRead){
        self.readView.hidden = YES;
    }
    
}

-(void)showRightWithModel:(TalkMessageModel *)model Time:(NSString *)messageTime
{
    self.logoImageView.hidden = YES;
    self.nickLabel.hidden = YES;
    self.contextBack.hidden = YES;
    
    self.rightLogoImgView.hidden = NO;
    self.rightContext.hidden = NO;
    
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
    
    CGSize imageSize = [self imageShowSize:model.imageSmall];
    self.rightContext.frame = CGRectMake(self.frame.size.width - LEFT_WITH - imageSize.width - 33, self.rightLogoImgView.frame.origin.y, 100, 100);
    
    self.rightImgView.frame = CGRectMake(100-10-67, 10, 67, 67);
    self.rightImgView.image = model.imageSmall;
    
    self.rightSecondsLabel.text = [NSString stringWithFormat:@"%lu ''",(unsigned long)model.duringTime];
    [self.rightSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightContext).offset(5);
        make.top.mas_equalTo(self.rightContext.mas_bottom).offset(-21);
    }];
    [self.rightSecondsLabel sizeToFit];
    
    [self.rightAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightSecondsLabel.mas_right).offset(5);
        make.top.mas_equalTo(self.rightContext.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(12, 16));
    }];
    
    self.rightCoverImg.frame = self.rightContext.frame;
    
}


-(CGSize )imageShowSize:(UIImage *)image
{
//    CGFloat imageWidth = image.size.width;
//    CGFloat imageHeight = image.size.height;
//
//    //宽度大于高度
//    if (imageWidth > imageHeight) {
//
//        return CGSizeMake(MAX_IMAGE_WH, imageHeight * MAX_IMAGE_WH/imageWidth);
//    }else{
//        return CGSizeMake(imageWidth * MAX_IMAGE_WH/imageHeight, MAX_IMAGE_WH);
//    }
    
    return CGSizeMake(67, 67);
}

-(CGFloat)voiceLength:(NSInteger)seconds{
    
    if (seconds == 0) {
        return 60;
    }
    
    //    6~197 6p~230
    // 60
    
    CGFloat max = [UIScreen mainScreen].bounds.size.width > 750 ? 230:197;
    
    return 60 + (seconds-1)*(max-60)*1.0/60.0;
}

-(void)contextBackAddGesture
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.contextBack addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightSingleTap:)];
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
    if (self.messageModel.messageType != MessageTypeText) {
        
        if (self.singleblock) {
            self.singleblock(self.messageModel);
        }
        
        if (self.messageModel.messageType == MessageTypeImage) {

            self.readView.hidden = YES;
            self.messageModel.messageReadStatus = MessageReadStatusRead;
            //已读/未读
            [DataBaseTool updateMessageModel:self.messageModel];
//            [[TencentIMManager defautManager] setMessageRead:[NSString stringWithFormat:@"%d",self.messageModel.mId]];
            
//            [self startVoiceAnimation];
            
            __block TalkImageCell/*主控制器*/ *weakSelf = self;
            
            self.coversImageView.hidden = NO;
            dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
                weakSelf.coversImageView.hidden = YES;
            });
            
//            dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.messageModel.duringTime * NSEC_PER_SEC));
//            dispatch_after(delayTime2, dispatch_get_main_queue(), ^{
//                [weakSelf stopVoiceAnimation];
//            });
            
            if (self.timer != nil) {
                [self.timer invalidate];
            }
            self.timer = [NSTimer scheduledTimerWithTimeInterval:[[NSString stringWithFormat:@"%tu",self.messageModel.duringTime] floatValue] target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
        }
    }
}

-(void)rightSingleTap:(id)sender
{
    if (self.messageModel.messageType != MessageTypeText) {
        
      
        
        if (self.messageModel.messageType == MessageTypeImage) {
            
            [self.rightAnimationView startAnimating];
            self.rightCoverImg.hidden = NO;
            
            __block TalkImageCell/*主控制器*/ *weakSelf = self;
            
            dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
                weakSelf.rightCoverImg.hidden = YES;
            });
            
//            dispatch_time_t delayTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.messageModel.duringTime * NSEC_PER_SEC));
//            dispatch_after(delayTime2, dispatch_get_main_queue(), ^{
//                [weakSelf.rightAnimationView stopAnimating];
//            });
            
            if (self.timer != nil) {
                [self.timer invalidate];
            }
            
            NSLog(@"rightTap ====> %f => %f",[[NSString stringWithFormat:@"%tu",self.messageModel.duringTime] floatValue],([[NSString stringWithFormat:@"%tu",self.messageModel.duringTime] floatValue] / 10.0f ));
            self.timer = [NSTimer scheduledTimerWithTimeInterval:[[NSString stringWithFormat:@"%tu",self.messageModel.duringTime] floatValue] target:self selector:@selector(timerAction:) userInfo:nil repeats:NO];
            if (self.singleblock) {
                self.singleblock(self.messageModel);
            }
        }
    }
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
    if (self.rightAnimationView != nil) {
        [self.rightAnimationView startAnimating];
    }
    
    if (self.voiceAnimationImageView != nil) {
        [self.voiceAnimationImageView startAnimating];
    }
    
}
-(void)stopVoiceAnimation
{
    if (self.rightAnimationView != nil) {
        if ([self VoiceAnimationing]) {
            [self.rightAnimationView stopAnimating];
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
//
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
//    }else{
//        result = [creatTimeStr substringToIndex:creatTimeStr.length - 3];
//    }

    return [timeDate DateTransformTimeShuoshuoStr];
}

-(void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [super setFrame:frame];
}
-(BOOL)VoiceAnimationing
{
    if (self.messageModel.messageSenderType == MessageSenderTypeSelf)
    {
        return self.rightAnimationView.animating;
    }else
    {
        return self.voiceAnimationImageView.animating;
    }
    
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
