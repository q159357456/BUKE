//
//  KBookListCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookListCell.h"

@interface  KBookListCell()

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *identityLabel;

@end



@implementation KBookListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake(0, 0, self.frame.size.width, 78);
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 23, 48, 48)];
        iconImageView.layer.cornerRadius = iconImageView.frame.size.width*0.5;
        iconImageView.layer.masksToBounds = YES;
        self.iconImageView = iconImageView;
        [self addSubview:iconImageView];
        
        UIImageView *maskImageView = [[UIImageView alloc] init];
        maskImageView.frame = CGRectMake(16, 20, 54, 54);
        self.maskImageView = maskImageView;
        [self addSubview:maskImageView];
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = CGRectMake(16, 20, 52, 52);
        [playButton addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
        self.playButton = playButton;
        [self addSubview:playButton];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + 13, iconImageView.frame.origin.y, self.frame.size.width - iconImageView.frame.origin.x - iconImageView.frame.size.width - 13 - 30 - 3, 20)];
        nameLabel.textColor = COLOR_STRING(@"#666666");
        nameLabel.font = MY_FONT(16);
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel *identityLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 12, nameLabel.frame.size.width, 20)];
        identityLabel.textColor = COLOR_STRING(@"#9B9B9B");
        identityLabel.font = MY_FONT(14);
        self.identityLabel = identityLabel;
        [self addSubview:identityLabel];
        
        UIImageView *indicateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 29 - 3, (self.frame.size.height - 16)*0.5, 3, 16)];
        indicateImgView.image = [UIImage imageNamed:@"kBookList_indicate"];
        [self addSubview:indicateImgView];
        
        UIButton *indicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        indicateButton.frame = CGRectMake(self.frame.size.width - 65, 0, 65, self.frame.size.height);
        [indicateButton addTarget:self action:@selector(isShowBottom:) forControlEvents:UIControlEventTouchUpInside];
        self.indicateButton = indicateButton;
        [self addSubview:indicateButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, self.frame.size.height - 0.8, self.frame.size.width - nameLabel.frame.origin.x - 14, 0.8)];
        line.backgroundColor = COLOR_STRING(@"#DEDEDE");
        line.hidden = NO;
        self.line = line;
        [self addSubview:line];
    }
    
    return self;
}

-(void)clickPlay:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.status == 1) {
        //完整音频,可以播放
        if (sender.selected == YES) {
            self.maskImageView.image = [UIImage imageNamed:@"kBookList_pause"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(playKbookAudio:)]) {
                [self.delegate playKbookAudio:sender];
            }
        }else{
            self.maskImageView.image = [UIImage imageNamed:@"kBookList_play"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(kBookAudioPause:)]) {
                [self.delegate kBookAudioPause:sender];
            }
        }
        
    }else{
        //跳出提示框
        self.maskImageView.image = [UIImage imageNamed:@"kBookList_notFull"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(isShowAlertView:)]) {
            [self.delegate isShowAlertView:sender];
        }
    }
}

-(void)isShowBottom:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showBottom:)]) {
        [self.delegate showBottom:sender];
    }
}

-(void)setStatus:(NSInteger)status
{
    _status = status;
    if (status == 1) {
        //完整的音频
        if (self.selected)
        {
           self.maskImageView.image = [UIImage imageNamed:@"kBookList_pause"];
        }else
        {
            self.maskImageView.image = [UIImage imageNamed:@"kBookList_play"];
            
        }
        
    }else{
        self.maskImageView.image = [UIImage imageNamed:@"kBookList_notFull"];
    }
}

-(void)setIconUrl:(NSString *)iconUrl
{
    _iconUrl = iconUrl;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[iconUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
}

-(void)setBookName:(NSString *)bookName
{
    _bookName = bookName;
    self.nameLabel.text = bookName;
}

-(void)setIdentity:(NSString *)identity
{
    _identity = identity;
    self.identityLabel.text = identity;
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected == YES) {
        self.maskImageView.image = [UIImage imageNamed:@"kBookList_pause"];
        self.playButton.selected = YES;
    }else{
        self.maskImageView.image = [UIImage imageNamed:@"kBookList_play"];
        self.playButton.selected = NO;
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
