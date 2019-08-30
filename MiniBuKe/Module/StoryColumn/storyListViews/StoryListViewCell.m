//
//  StoryListViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "StoryListViewCell.h"

@interface StoryListViewCell()

@property(nonatomic,copy) NSString *iconString;
@property(nonatomic,copy) NSString *titleString;
@property(nonatomic,copy) NSString *totalTime;
@property(nonatomic,copy) NSString *pageCount;

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *totalTimeLabel;
@property(nonatomic,strong) UILabel *pageLabel;

@end

@implementation StoryListViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setSubView];
    }
    
    return self;
}

-(void)setSubView
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(14, 20, 60, 60)];
    icon.layer.cornerRadius = 4;
    icon.layer.masksToBounds = YES;
    icon.image = [UIImage imageNamed:@"首页_丛书系列_图片默认"];//设置默认图
    self.iconImageView = icon;
    [self addSubview:icon];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = kSystemFont(16);
    titleLabel.textColor = COLOR_STRING(@"#202020");
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).with.offset(8);
        make.top.equalTo(icon).with.offset(-1);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
    }];
    self.titleLabel = titleLabel;
    
    UILabel *authorLabel = [[UILabel alloc]init];
    authorLabel.font = kSystemFont(14);
    authorLabel.textColor = COLOR_STRING(@"#909090");
    [authorLabel sizeToFit];
    [self addSubview:authorLabel];
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(5);
    }];
    //把原 作者label 换成 时间总长                                                                                                                                                                     
    self.totalTimeLabel = authorLabel;
    
    /**
    UIView *verticalLine = [[UIView alloc]init];
    verticalLine.backgroundColor = COLOR_STRING(@"#808080");
    [self.contentView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 6));
        make.left.equalTo(authorLabel).with.offset(4);
        make.top.equalTo(authorLabel).with.offset(4);
    }];
    
    UILabel *totalLabel = [[UILabel alloc]init];
    totalLabel.font = authorLabel.font;
    totalLabel.textColor = authorLabel.textColor;
    [totalLabel sizeToFit];
    [self.contentView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalLine).with.offset(4);
        make.top.equalTo(authorLabel);
    }];
     
    */
    
    UILabel *pageLabel = [[UILabel alloc]init];
    pageLabel.font = authorLabel.font;
    pageLabel.textColor = authorLabel.textColor;
    pageLabel.numberOfLines = 1;
    [self addSubview:pageLabel];
    [pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(authorLabel);
        make.top.mas_equalTo(authorLabel.mas_bottom).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-11);
    }];
    self.pageLabel = pageLabel;
    
    UIView *horizontalLine = [[UIView alloc]init];
    horizontalLine.backgroundColor = COLOR_STRING(@"#D3D3D3");
    [self addSubview:horizontalLine];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel).with.offset(-2);
        make.right.equalTo(self);
        make.top.mas_equalTo(self.mas_bottom).offset(-1);
        make.height.equalTo(@1);
    }];
}

-(void)setCellWithStoryListModel:(StoryListModel *)model
{
    self.titleString = model.name;
    self.iconString = model.picUrl;
    self.totalTime = model.sumTime;
    self.pageCount = [NSString stringWithFormat:@"%ld 集",(long)model.storyCount];
}

-(void)setIconString:(NSString *)iconString
{
    _iconString = iconString;
    if (iconString) {
        CGFloat width = (60)*[UIScreen mainScreen].scale;
        NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",iconString,(int)width];
        //url 编码
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"]];
    }
}

-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    if (titleString) {
        self.titleLabel.text = titleString;
    }
}

-(void)setTotalTime:(NSString *)totalTime
{
    _totalTime = totalTime;
    self.totalTimeLabel.text = totalTime;
}

-(void)setPageCount:(NSString *)pageCount
{
    _pageCount = pageCount;
    self.pageLabel.text = pageCount;
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
