//
//  BookTableCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/8.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookTableCell.h"
#import "SeriesBookObject.h"
#import "UIImageView+WebCache.h"
#import "BookListViewController.h"
#import "BookCategoryObject.h"
#import "StoryPlayListViewController.h"
#import "StoryListModel.h"
#import "BookTableCell.h"
#import "BookDetailViewController.h"
#import "BooklistObjet.h"
#import "IntensiveReadingController.h"

@interface BookTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTextLabel;

@property (nonatomic,strong) SeriesBookObject *mSeriesBookObject;

@end

@implementation BookTableCell

//实现类方法
+(instancetype)xibTableViewCell {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BookTableCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateData:(SeriesBookObject *)mSeriesBookObject
{
    NSLog(@"mSeriesBookObject.bookName ==> %@",mSeriesBookObject.bookName);
    
    self.mSeriesBookObject = mSeriesBookObject;
    
    self.mTextLabel.text = mSeriesBookObject.bookName;
    
    self.imageLabel.layer.cornerRadius = self.imageLabel.frame.size.width/9.0;
    self.imageLabel.layer.masksToBounds = YES;
    
    [self.imageLabel sd_setImageWithURL:[NSURL URLWithString:[mSeriesBookObject.bookPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"sd_setImageWithURL ===> %@ => %@",error,mSeriesBookObject.bookPath);
        if (image) {
            [self.imageLabel setImage:image];
        }
        //        [_imageView setImage:image];
    }];
}

-(IBAction) onClick:(id)sender
{
    
    NSLog(@"===> BookTableCell <=== %@ %i",self.mSeriesBookObject.bookType,[@"1" isEqualToString: [NSString stringWithFormat:@"%@",self.mSeriesBookObject.bookType ]]);
    
    if ([@"1" isEqualToString: [NSString stringWithFormat:@"%@",self.mSeriesBookObject.bookType]]) {
//        BookCategoryObject *mBookCategoryObject = [[BookCategoryObject alloc] init];
//        mBookCategoryObject.categoryId = self.mSeriesBookObject.bookId;
//        mBookCategoryObject.categoryName = self.mSeriesBookObject.bookName;
//
//        BookListViewController *mBookListViewController = [[BookListViewController alloc] init:nil mBookCategoryObject:mBookCategoryObject];
//        [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
        
//        BooklistObjet
        
        BooklistObjet *mBooklistObjet = [[BooklistObjet alloc] init];
        
        mBooklistObjet.coverPic = self.mSeriesBookObject.coverPic;
        mBooklistObjet.author = self.mSeriesBookObject.bookName;
        mBooklistObjet.mid = self.mSeriesBookObject.bookId;
        mBooklistObjet.name = self.mSeriesBookObject.bookName;
        
//        BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:mBooklistObjet];
//        [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
        
        IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
        vc.bookid = mBooklistObjet.mid;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];

        
    } else if ([@"2" isEqualToString: [NSString stringWithFormat:@"%@",self.mSeriesBookObject.bookType]]){
        //故事播放列表
        StoryListModel *listModel = [[StoryListModel alloc]init];
        //缺少 时间参数
        listModel.storyId = [self.mSeriesBookObject.bookId integerValue];
        listModel.name = self.mSeriesBookObject.bookName;
        listModel.picUrl = self.mSeriesBookObject.bookPath;
        listModel.sumTime = self.mSeriesBookObject.sumTime;
        
        if ([self.mSeriesBookObject.storyCount isKindOfClass:[NSNumber class]]) {
            listModel.storyCount = self.mSeriesBookObject.storyCount.intValue;
        } else {
            listModel.storyCount = 0;
        }
        
        
        
        StoryPlayListViewController *playListViewController = [[StoryPlayListViewController alloc]init];
        playListViewController.listModel = listModel;
        
        [APP_DELEGATE.navigationController pushViewController:playListViewController animated:YES];
        
    } else if ([@"3" isEqualToString: [NSString stringWithFormat:@"%@",self.mSeriesBookObject.bookType]]){
        
    }
}

@end
