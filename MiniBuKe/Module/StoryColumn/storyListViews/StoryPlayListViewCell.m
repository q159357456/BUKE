//
//  StoryPlayListViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryPlayListViewCell.h"
#import "StoryCollectService.h"
@interface StoryPlayListViewCell()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIView *frontView;

@property(nonatomic,copy) NSString *token;
@property(nonatomic,strong) UIView *line;
@property(nonatomic,strong) UIImageView *bgImageView;
@property(nonatomic,strong) UIImageView *iconImageView;

@end

@implementation StoryPlayListViewCell

-(NSString *)token
{
    if (!_token) {
        _token = [[NSString alloc]init];
    }
    return _token;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubView];
        
    }
    
    return self;
}

-(void)initSubView
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.frame = CGRectMake(23, 18, 44, 44);
    self.iconImageView.userInteractionEnabled = YES;
    self.iconImageView.layer.cornerRadius = 44/2;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.iconImageView.layer.masksToBounds = YES;
    [self addSubview:self.iconImageView];
    self.iconImageView.hidden = YES;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
    [self.bgImageView setImage:[UIImage imageNamed:@"playList_icon_bg"]];
    [self addSubview:self.bgImageView];
    self.bgImageView.hidden = YES;
    
    
    
    UIView *frontView = [[UIView alloc]init];
    frontView.frame = CGRectMake(0, 14, 4, self.frame.size.height - 14*2);
    frontView.backgroundColor = COLOR_STRING(@"#FF5001");
    //默认隐藏
    frontView.hidden = YES;
    self.frontView = frontView;
    [self addSubview:frontView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(14, 14, 230, 20);
    titleLabel.font = MY_FONT(16);
    titleLabel.textColor = COLOR_STRING(@"#212121");
    titleLabel.text = @"两只老虎";//待传值
    [self addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(14);
//        make.top.equalTo(self).with.offset(14);
//        make.right.equalTo(self).with.offset(-self.frame.size.width*0.5 + 20);
//    }];
    self.titleLabel = titleLabel;
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake(14, 32, 300, 25);
    timeLabel.textColor = COLOR_STRING(@"#909090");
    timeLabel.text = @"11:55";//待传值
    timeLabel.font = MY_FONT(12);
    [self addSubview:timeLabel];
//    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(titleLabel);
//        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(4);
//    }];
//    [timeLabel sizeToFit];
    self.timeLabel = timeLabel;
    
    UIButton *praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    praiseButton.frame = CGRectMake(self.frame.size.width - 30 - 15, (self.frame.size.height - 26)*0.5, 30, 26);
    [praiseButton setImage:[UIImage imageNamed:@"playList_collect"] forState:UIControlStateNormal];
    [praiseButton setImage:[UIImage imageNamed:@"playList_collectSelected"] forState:UIControlStateSelected];
//    [praiseButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    self.collectButton = praiseButton;
    self.collectButton.selected = NO;
    [self addSubview:praiseButton];
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.frame = CGRectMake(praiseButton.frame.origin.x - 30 - 10, praiseButton.frame.origin.y, 30, 26);
    [pushButton setImage:[UIImage imageNamed:@"playList_push"] forState:UIControlStateNormal];
    [pushButton setImage:[UIImage imageNamed:@"playList_pushSelected"] forState:UIControlStateSelected];
    self.pushButton = pushButton;
    [self addSubview:pushButton];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(pushButton.frame.origin.x - 30 - 10, pushButton.frame.origin.y, 30, 26);
    [playButton setImage:[UIImage imageNamed:@"playList_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"playList_pause"] forState:UIControlStateSelected];
    self.playButton = playButton;
    [self addSubview:playButton];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(14, self.frame.size.height - 1, self.frame.size.width - 14, 1)];
    self.line.backgroundColor = COLOR_STRING(@"#D3D3D3");
    [self addSubview:self.line];
    
}

-(void)setCellWithStoryPlayListModel:(StoryPlayListModel *)model setStoryPlaySourceType:(StoryPlaySourceType) sourceType
{
    self.title = model.musicName;
    self.time = model.transformTime;
//    self.isCollected = model.isCollect;
    
    if (sourceType == StoryPlaySourceType_Collect) {
        self.titleLabel.frame = CGRectMake(84, 14, 200, 20);
        self.timeLabel.frame = CGRectMake(84, 42, 300, 25);
//        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.titleLabel);
//            make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(50);
//        }];
        self.line.frame = CGRectMake(84, 77 - 1, self.frame.size.width - 84 - 20, 1);
        self.playButton.frame = CGRectMake(31, 77/2 - 26/2 + 2, 30, 26);
        self.pushButton.frame = CGRectMake(self.pushButton.frame.origin.x, 77/2 - 26/2, self.pushButton.frame.size.width, self.pushButton.frame.size.height);
        self.collectButton.frame = CGRectMake(self.collectButton.frame.origin.x, 77/2 - 26/2, self.collectButton.frame.size.width, self.collectButton.frame.size.height);
        [self.playButton setImage:[UIImage imageNamed:@"playList_icon_play"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"playList_icon_pause"] forState:UIControlStateSelected];
        self.bgImageView.hidden = NO;
        
        self.frontView.frame = CGRectMake(0, 77/2 - 40/2, 4,40);
        self.iconImageView.hidden = NO;
        
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[model.albumImgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
        
//        if (sourceType == StoryPlaySourceType_Recent) {
//            //收藏bug 暂时收藏
//            self.pushButton.frame = self.collectButton.frame;
//            self.collectButton.hidden = YES;
//        }
        
        
    } else if (sourceType == StoryPlaySourceType_Recent) {
        
        self.titleLabel.frame = CGRectMake(84, 14, 200, 20);
        self.timeLabel.frame = CGRectMake(84, 42, 300, 25);
        //        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.titleLabel);
        //            make.top.mas_equalTo(self.titleLabel.mas_bottom).with.offset(50);
        //        }];
        self.line.frame = CGRectMake(84, 77 - 1, self.frame.size.width - 84 - 20, 1);
        self.playButton.frame = CGRectMake(31, 77/2 - 26/2 + 2, 30, 26);
        
        self.collectButton.frame = CGRectMake(self.collectButton.frame.origin.x, 77/2 - 26/2, self.collectButton.frame.size.width, self.collectButton.frame.size.height);
        self.collectButton.hidden = YES;
        
        self.pushButton.frame = CGRectMake(self.collectButton.frame.origin.x - 10, 77/2 - 26/2, self.pushButton.frame.size.width, self.pushButton.frame.size.height);
        
        [self.playButton setImage:[UIImage imageNamed:@"playList_icon_play"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"playList_icon_pause"] forState:UIControlStateSelected];
        self.bgImageView.hidden = NO;
        
        self.frontView.frame = CGRectMake(0, 77/2 - 40/2, 4,40);
        self.iconImageView.hidden = NO;
        
        
//        NSLog(@"model.picUrl==>: %@",model.picUrl);
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[model.albumImgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
    }
    
}

-(void)setIsSelected:(NSNumber *)isSelected
{
    _isSelected = isSelected;
    if ([isSelected isEqualToNumber:@(1)]) {
        
        self.titleLabel.textColor = COLOR_STRING(@"#FF5001");
        self.timeLabel.textColor = COLOR_STRING(@"#FF5001");
        self.frontView.hidden = NO;
        self.playButton.selected = YES;
        
    }else{
        
        self.titleLabel.textColor = COLOR_STRING(@"#212121");
        self.timeLabel.textColor = COLOR_STRING(@"#909090");
        self.frontView.hidden = YES;
        self.playButton.selected = NO;
    }
}

//-(void)setIsCollected:(BOOL)isCollected
//{
//    _isCollected = isCollected;
//    self.collectButton.selected = isCollected;
//}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

-(void)setTime:(NSString *)time
{
    _time = time;
    self.timeLabel.text = time;
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
