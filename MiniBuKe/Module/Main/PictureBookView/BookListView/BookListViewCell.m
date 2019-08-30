//
//  BookListViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookListViewCell.h"
#import "BookDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "BooklistObjet.h"
#import "BKMoreNewBookListModel.h"
#import "IntensiveReadingController.h"

@interface BookListViewCell ()

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel2;

@property (weak, nonatomic) BooklistObjet *obj1;
@property (weak, nonatomic) BooklistObjet *obj2;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BookListViewCell

+(instancetype)xibTableViewCell {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BookListViewCell" owner:nil options:nil] lastObject];
}

-(void) updateData:(CGSize ) size setArrayBooklistObjet:(NSArray *) mBooklistObjets
{
//    CGFloat collectW = (size.width - 15*2 - 20)*0.5;
//    //NSLog(@"size = %f = %f",size.width,size.height);
//    self.view1.frame = CGRectMake(self.view1.frame.origin.x + 15, self.view1.frame.origin.y, collectW, self.view1.frame.size.height);

//    self.view2.frame = CGRectMake(size.width - self.view2.frame.size.width - 15, self.view2.frame.origin.y, collectW, self.view2.frame.size.height);

//    self.mTextLabel.text = mSeriesBookObject.bookName;
    self.view1.hidden = YES;
    self.view2.hidden = YES;
    
    for (int i = 0; i < mBooklistObjets.count; i++) {
        
        BooklistObjet *obj = [mBooklistObjets objectAtIndex:i];
        
        if (i % 2 == 0) {
            self.view1.hidden = NO;
            
            self.textLabel1.text = obj.name;
            self.hintLabel1.text = obj.author;
            
            self.imageView1.layer.cornerRadius = 10;
            self.imageView1.layer.masksToBounds = YES;
            
            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[obj.coverPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                NSLog(@"sd_setImageWithURL ===> %@",error);
//                if (image) {
//                    [self.imageView1 setImage:image];
//                }
            }];
            self.obj1 = obj;
            
            
        } else {
            self.view2.hidden = NO;
            
            self.textLabel2.text = obj.name;
            self.hintLabel2.text = obj.author;
            
            self.imageView2.layer.cornerRadius = 10;
            self.imageView2.layer.masksToBounds = YES;
            
            [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[obj.coverPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                NSLog(@"sd_setImageWithURL ===> %@",error);
//                if (image) {
//                    [self.imageView2 setImage:image];
//                }
            }];
            
            self.obj2 = obj;
        }
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(IBAction)onButtonClick1:(id)sender
{
    if (self.dataArray == nil && self.obj1) {
        
        NSLog(@"btton click 1");
//        BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:self.obj1];
//        [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
        
        IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
        vc.bookid = self.obj1.mid;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(NewbookClickWithBookId:)]) {
            BKNewBookData *obj = [self.dataArray objectAtIndex:0];
            [self.delegate NewbookClickWithBookId:obj.bookId];
        }
    }
}

-(IBAction)onButtonClick2:(id)sender
{
    if (self.dataArray == nil && self.obj2) {

    NSLog(@"btton click 2");
//    BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:self.obj2];
//    [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
        IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
        vc.bookid = self.obj2.mid;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(NewbookClickWithBookId:)]) {
            BKNewBookData *obj = [self.dataArray objectAtIndex:1];
            [self.delegate NewbookClickWithBookId:obj.bookId];
        }

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)NewBookUpdateData:(CGSize ) size setArrayBooklistObjet:(NSArray *) mBooklistObjets{
    self.view1.hidden = YES;
    self.view2.hidden = YES;
    self.dataArray = mBooklistObjets;
    for (int i = 0; i < mBooklistObjets.count; i++) {
        
        BKNewBookData *obj = [mBooklistObjets objectAtIndex:i];

        if (i % 2 == 0) {
            self.view1.hidden = NO;
            
            self.textLabel1.text = obj.name;
            self.hintLabel1.text = obj.author;
            
            self.imageView1.layer.cornerRadius = 10;
            self.imageView1.layer.masksToBounds = YES;
            
            CGFloat width = ((SCREEN_WIDTH-3*15)/2.0)*[UIScreen mainScreen].scale;
            NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",obj.coverPic,(int)width];
            NSLog(@"%@",picurl);

            [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                NSLog(@"sd_setImageWithURL ===> %@",error);
//                if (image) {
//                    [self.imageView1 setImage:image];
//                }
            }];
            
            
        } else {
            self.view2.hidden = NO;
            
            self.textLabel2.text = obj.name;
            self.hintLabel2.text = obj.author;
            
            self.imageView2.layer.cornerRadius = 10;
            self.imageView2.layer.masksToBounds = YES;
            
            CGFloat width = ((SCREEN_WIDTH-3*15)/2.0)*[UIScreen mainScreen].scale;
            NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",obj.coverPic,(int)width];
            
            [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if (image) {
//                    [self.imageView2 setImage:image];
//                }
            }];
            
        }
        
    }
}

@end
