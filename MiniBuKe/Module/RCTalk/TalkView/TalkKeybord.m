//
//  TalkKeybord.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TalkKeybord.h"

#define TALK_HEIGHT 60

@interface TalkKeybord()<UIScrollViewDelegate>


@end

@implementation TalkKeybord

-(instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self createChildView];
    }
    
    return self;
}

-(void)createChildView
{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 1, self.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    NSInteger lineNum = 2;
    NSInteger rowNum = 4;
    
//    float marginX = 15;
//    float marginY = 10;
//    float spaceX = 10;
//    float spaceY = 10;
    
//    float buttonW = (self.frame.size.width - marginX*2 - (rowNum - 1)*spaceX)/rowNum;
//    float buttonH = (self.frame.size.height - marginY*2 - (lineNum - 1)*spaceY)/lineNum;
    
//    for (int i = 0; i < 8 ; i++) {
//        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        emojiButton.frame = CGRectMake(marginX + (buttonW + spaceX)*(i%rowNum), marginY + (buttonH + spaceY)*(i/rowNum), buttonW, buttonH);
//        emojiButton.tag = i;
//        [emojiButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"emoji_0%d",i+1]] forState:UIControlStateNormal];
//        [emojiButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"emoji_0%d",i+1]] forState:UIControlStateSelected];
//        [emojiButton addTarget:self action:@selector(sendEmoji:) forControlEvents:UIControlEventTouchUpInside];
//        [self.scrollView addSubview:emojiButton];
//    }
    
    
    float buttonW = 57;
    float buttonH = 57;
    
    float marginY = 13;
    float spaceY = 13;
    float marginX = (self.frame.size.width - buttonW * rowNum)/(rowNum + 1);
    float spaceX = marginX;
//    float labelW = self.frame.size.width / rowNum;
    
    for (int i = 0; i < 8; i++) {
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emojiButton.frame = CGRectMake(marginX + (buttonW + spaceX)*(i%rowNum), marginY + (buttonH + spaceY + 7 + 15)*(i/rowNum), buttonW, buttonH);
        emojiButton.tag = i;
        [emojiButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"emoji_0%d",i+1]] forState:UIControlStateNormal];
        [emojiButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"emoji_0%d",i+1]] forState:UIControlStateSelected];
        [emojiButton addTarget:self action:@selector(sendEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [emojiButton addTarget:self action:@selector(sendEmojiBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
        [self.scrollView addSubview:emojiButton];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(emojiButton.frame.origin.x, emojiButton.frame.origin.y + emojiButton.frame.size.height + 7, emojiButton.frame.size.width, 15);
        label.textColor = COLOR_STRING(@"#999999");
        label.textAlignment = NSTextAlignmentCenter;
        label.font = MY_FONT(12);
        [self.scrollView addSubview:label];
        switch (i) {
            case 0:
                label.text = @"绘本";
                break;
            case 1:
                label.text = @"不看电视";
                break;
            case 2:
                label.text = @"不看手机";
                break;
            case 3:
                label.text = @"吃饭";
                break;
            case 4:
                label.text = @"洗手";
                break;
            case 5:
                label.text = @"刷牙";
                break;
            case 6:
                label.text = @"睡觉";
                break;
            case 7:
                label.text = @"多喝水";
                break;
                
            default:
                break;
        }
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

//发送表情语音
-(void)sendEmoji:(UIButton *)sender
{
    sender.backgroundColor = [UIColor whiteColor];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSendEmoji:)]) {
        [self.delegate clickSendEmoji:sender];
    }
}
-(void)sendEmojiBackGroundHighlighted:(UIButton *)sender{
    sender.backgroundColor = COLOR_STRING(@"#F7F9FB");
    
}
#pragma mark - UIScrollViewDelegate


@end
