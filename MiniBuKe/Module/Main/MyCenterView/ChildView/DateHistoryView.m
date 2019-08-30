//
//  DateHistoryView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/24.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "DateHistoryView.h"
#import "UIImageView+WebCache.h"
#import "SeriesBookObject.h"
#import "BooklistObjet.h"
#import "BookDetailViewController.h"
#import "IntensiveReadingController.h"

@interface DateHistoryView ()

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UIImageView *icImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *icImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *icImageView3;

@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property (weak, nonatomic) IBOutlet UILabel *textLabel3;

@property (nonatomic,strong) SeriesBookObject* mSeriesBookObject1;
@property (nonatomic,strong) SeriesBookObject* mSeriesBookObject2;
@property (nonatomic,strong) SeriesBookObject* mSeriesBookObject3;

@end

@implementation DateHistoryView

+(instancetype)xibView {
    return [[[NSBundle mainBundle] loadNibNamed:@"DateHistoryView" owner:nil options:nil] lastObject];
}

-(void) updateDataView:(CGSize ) size setSeriesBookObjects:(NSArray *) mSeriesBookObjects
{
    self.view1.hidden = YES;
    self.view2.hidden = YES;
    self.view3.hidden = YES;
    
    self.icImageView1.layer.cornerRadius = self.icImageView1.frame.size.width/9.9;
    self.icImageView1.layer.masksToBounds = YES;
    
    self.icImageView2.layer.cornerRadius = self.icImageView2.frame.size.width/9.9;
    self.icImageView2.layer.masksToBounds = YES;
    
    self.icImageView3.layer.cornerRadius = self.icImageView3.frame.size.width/9.9;
    self.icImageView3.layer.masksToBounds = YES;
    
    for (int i = 0; i < mSeriesBookObjects.count; i ++) {
        SeriesBookObject* mSeriesBookObject = [mSeriesBookObjects objectAtIndex:i];
        if (i == 0) {
            self.view1.hidden = NO;
            self.textLabel1.text = mSeriesBookObject.bookName;
            self.mSeriesBookObject1 = mSeriesBookObject;
            [self.icImageView1 sd_setImageWithURL:[NSURL URLWithString:[mSeriesBookObject.bookPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"sd_setImageWithURL ===> %@ => %@",error,mSeriesBookObject.bookPath);
                if (image) {
                    [self.icImageView1 setImage:image];
                }
            }];
        } else if (i == 1) {
            self.view2.hidden = NO;
            self.textLabel2.text = mSeriesBookObject.bookName;
            self.mSeriesBookObject2 = mSeriesBookObject;
            
            [self.icImageView2 sd_setImageWithURL:[NSURL URLWithString:[mSeriesBookObject.bookPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"sd_setImageWithURL ===> %@ => %@",error,mSeriesBookObject.bookPath);
                if (image) {
                    [self.icImageView2 setImage:image];
                }
            }];
        } else if (i == 2) {
            self.view3.hidden = NO;
            self.textLabel3.text = mSeriesBookObject.bookName;
            self.mSeriesBookObject3 = mSeriesBookObject;
            
            [self.icImageView3 sd_setImageWithURL:[NSURL URLWithString:[mSeriesBookObject.bookPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"sd_setImageWithURL ===> %@ => %@",error,mSeriesBookObject.bookPath);
                if (image) {
                    [self.icImageView3 setImage:image];
                }
            }];
        }
        
        
        
    }

    
}

-(IBAction) onClickButton1:(id)sender
{
    NSLog(@"====> onClickButton1 <====");
    
    BooklistObjet *mBooklistObjet = [[BooklistObjet alloc] init];
    
    mBooklistObjet.coverPic = self.mSeriesBookObject1.coverPic;
    mBooklistObjet.author = self.mSeriesBookObject1.bookName;
    mBooklistObjet.mid = self.mSeriesBookObject1.bookId;
    mBooklistObjet.name = self.mSeriesBookObject1.bookName;
    
//    BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:mBooklistObjet];
//    [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
    
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = mBooklistObjet.mid;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}

-(IBAction) onClickButton2:(id)sender
{
    NSLog(@"====> onClickButton2 <====");
    
    BooklistObjet *mBooklistObjet = [[BooklistObjet alloc] init];
    
    mBooklistObjet.coverPic = self.mSeriesBookObject2.coverPic;
    mBooklistObjet.author = self.mSeriesBookObject2.bookName;
    mBooklistObjet.mid = self.mSeriesBookObject2.bookId;
    mBooklistObjet.name = self.mSeriesBookObject2.bookName;
    
//    BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:mBooklistObjet];
//    [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
    
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = mBooklistObjet.mid;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}

-(IBAction) onClickButton3:(id)sender
{
    NSLog(@"====> onClickButton3 <====");
    
    BooklistObjet *mBooklistObjet = [[BooklistObjet alloc] init];
    
    mBooklistObjet.coverPic = self.mSeriesBookObject3.coverPic;
    mBooklistObjet.author = self.mSeriesBookObject3.bookName;
    mBooklistObjet.mid = self.mSeriesBookObject3.bookId;
    mBooklistObjet.name = self.mSeriesBookObject3.bookName;
    
//    BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:mBooklistObjet];
//    [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
    
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = mBooklistObjet.mid;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}


@end
