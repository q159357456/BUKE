//
//  ClassifyMenuView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ClassifyMenuView.h"
#import "MyCenterView.h"
#import "UIImageView+WebCache.h"
#import "BookListViewController.h"
#import "AppDelegate.h"
#import "StoryListViewController.h"

@interface ClassifyMenuView ()

@property(nonatomic,strong) UIView *roundview;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *textLabel;
@property(nonatomic,strong) UIButton *mBt;
@property(nonatomic,strong) BookListViewController *mBookListViewController;
@end

@implementation ClassifyMenuView


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initView];
    }
    return  self;
}

-(void)initView{
    //[self setBackgroundColor: COLOR_STRING(@"#FFF011")];
    
//    _roundview = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 43/2, 5, 43, 43)];
//    _roundview.layer.cornerRadius = 43/2;
//    _roundview.layer.masksToBounds = YES;
//
//    [_roundview setBackgroundColor: COLOR_STRING(@"#FA7075")];
//    [self addSubview:_roundview];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2 - 43/2, 5, 43, 43)];
//    _imageView.layer.cornerRadius = 43/2;
//    _imageView.layer.masksToBounds = YES;
//    [_imageView setImage:[UIImage imageNamed:@"更多"]];
    //[_imageView setBackgroundColor: COLOR_STRING(@"#FA7075")];
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 70/2, self.frame.size.height - 25 - 5, 70, 25)];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.text = @"...";
    _textLabel.font = MY_FONT(13);
    
    //[_textLabel setBackgroundColor:[UIColor whiteColor] ];
    [self addSubview:_textLabel];
    
    _mBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_mBt addTarget:self action:@selector(onClcik:) forControlEvents:UIControlEventTouchUpInside];
    //[_mBt setBackgroundColor:[UIColor redColor]];
    [self addSubview:_mBt];
}

-(IBAction)onClcik:(id)sender
{
    //NSLog(@"onClcik%@ %@",_textLabel.text,navigationController);
    if (self.categoryType == CategoryBook) {
        BookListViewController *mBookListViewController = [[BookListViewController alloc] init:self.dataArray mBookCategoryObject:self.mBookCategoryObject];
        //mBookListViewController.dataArray = self.dataArray;
        //mBookListViewController.mBookCategoryObject = self.mBookCategoryObject;
        
        [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
    }else if (self.categoryType == CategoryStory){
        //上报统计
        [[BaiduMobStat defaultStat] logEvent:@"c_tCategory100" eventLabel:self.mStoryCategoryObject.categoryName];

        StoryListViewController *storyListController = [[StoryListViewController alloc] init];
        storyListController.storyObject = self.mStoryCategoryObject;
        [APP_DELEGATE.navigationController pushViewController:storyListController animated:YES];
    }
    
}

-(void) show
{
    _textLabel.hidden = NO;
    _imageView.hidden = NO;
    _mBt.hidden = NO;
}

-(void) hide
{
    _textLabel.hidden = YES;
    _imageView.hidden = YES;
    _mBt.hidden = YES;
}

-(void) updateData:(NSString *) str setImageUrl:(NSString *) imageUrl
{
    //[_roundview setBackgroundColor: color];
//    [_imageView setBackgroundColor:color];
    
//    [_imageView setImage:[UIImage imageNamed:@"更多"]];
    
//    NSLog(@"==> self.mBookCategoryObject.categoryId ==> %@ ==> %@",self.mBookCategoryObject.categoryId,self.mBookCategoryObject.categoryName);
    
    
    _textLabel.text = str;
    
    CGFloat w = (43.f/375.f)*SCREEN_WIDTH*[UIScreen mainScreen].scale;
    NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",imageUrl,(int)w];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_绘本_菜单默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"sd_setImageWithURL ===> %@",error);
//        if (image) {
//            [_imageView setImage:image];
//        }
        //        [_imageView setImage:image];
    }];
    
}

@end
