//
//  StoryManagerCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryManagerCell.h"

@interface StoryManagerCell()

@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UIImageView *bgImageView;


@property(nonatomic,strong) UIView *line;

@end

@implementation StoryManagerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
    }
    
    return self;
}

-(void)initView
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.frame = CGRectMake(48, 18, 44, 44);
    self.iconImageView.userInteractionEnabled = YES;
    self.iconImageView.layer.cornerRadius = 44/2;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.iconImageView.layer.masksToBounds = YES;
    [self addSubview:self.iconImageView];
    self.iconImageView.hidden = YES;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 60, 60)];
    [self.bgImageView setImage:[UIImage imageNamed:@"playList_icon_bg"]];
    [self addSubview:self.bgImageView];
    self.bgImageView.hidden = YES;
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(12, 18, 24, 24);
    [selectButton setImage:[UIImage imageNamed:@"storyManager_selec"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"storyManager_selected"] forState:UIControlStateSelected];
//    [selectButton addTarget:self action:@selector(clickSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.selectButton = selectButton;
    [self addSubview:selectButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectButton.frame.origin.x + selectButton.frame.size.width + 12, 14, self.frame.size.width - selectButton.frame.origin.x - selectButton.frame.size.width - 12 - 10, 15)];
    titleLabel.font = MY_FONT(16);
    titleLabel.text = @"hahahahha";
    titleLabel.textColor = COLOR_STRING(@"#202020");
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 8, 60, 12)];
    timeLabel.font = MY_FONT(12);
    timeLabel.textColor = COLOR_STRING(@"#909090");
    timeLabel.text = @"15:38";
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    
    self.line = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, self.frame.size.height - 1, self.frame.size.width - titleLabel.frame.origin.x, 1)];
    self.line.backgroundColor = COLOR_STRING(@"#D3D3D3");
    [self addSubview:self.line];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(31, 77/2 - 26/2 + 2, 30, 26);
    [playButton setImage:[UIImage imageNamed:@"playList_play"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"playList_pause"] forState:UIControlStateSelected];
    self.playButton = playButton;
    [self addSubview:playButton];
    self.playButton.hidden = YES;
    
}

-(void)setDisplayValueByData:(StoryPlayListModel *)model setStoryPlaySourceType:(StoryPlaySourceType) sourceType
{
    self.titleName = model.musicName;
    self.timeString = model.transformTime;
    
    if (sourceType == StoryPlaySourceType_Collect || sourceType == StoryPlaySourceType_Recent) {
        self.titleLabel.frame = CGRectMake(104, 14, 300, 20);
        self.timeLabel.frame = CGRectMake(104, 42, 300, 25);
        
        self.line.frame = CGRectMake(104, 77 - 1, self.frame.size.width - 104 - 20, 1);
        
        self.playButton.hidden = NO;
        self.playButton.frame = CGRectMake(56, 77/2 - 26/2 + 2, 30, 26);
        [self.playButton setImage:[UIImage imageNamed:@"playList_icon_play"] forState:UIControlStateNormal];
        [self.playButton setImage:[UIImage imageNamed:@"playList_icon_pause"] forState:UIControlStateSelected];
        self.bgImageView.hidden = NO;
        
//        self.frontView.frame = CGRectMake(0, 77/2 - 40/2, 4,40);
        self.iconImageView.hidden = NO;
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[model.albumImgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
        
        self.selectButton.frame = CGRectMake(12, 77/2 - 24/2, 24, 24);
        
    }
}


-(void)setTitleName:(NSString *)titleName
{
    _titleName = titleName;
    self.titleLabel.text = titleName;
}

-(void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
    self.timeLabel.text = timeString;
}

-(void)setIsAllSelected:(BOOL)isAllSelected
{
    _isAllSelected = isAllSelected;
    self.selectButton.selected = isAllSelected;
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
