//
//  BookMenuView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookMenuView.h"
#import "BookCategoryObject.h"
#import "BookListViewController.h"

@interface BookMenuView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UILabel *label5;

@property (weak, nonatomic) IBOutlet UIImageView *imageView6;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@property (nonatomic,strong) NSArray *array;

@end

@implementation BookMenuView

+(instancetype)xibView {
    return [[[NSBundle mainBundle] loadNibNamed:@"BookMenuView" owner:nil options:nil] lastObject];
}

-(void) updateDataView:(NSArray *) array
{
    NSLog(@"BookCategoryObject updateDataView ==> %lu",(unsigned long)array.count);
    self.array = array;
    for (int i = 0; i < array.count; i ++) {
        BookCategoryObject *mBookCategoryObject = [array objectAtIndex:i];
        if(i == 0){
            _label1.text = mBookCategoryObject.categoryName;
            
            [_imageView1 sd_setImageWithURL:[NSURL URLWithString:[mBookCategoryObject.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_菜单_胎教"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [_imageView1 setImage:image];
                }
            }];
        } else if(i == 1){
            _label2.text = mBookCategoryObject.categoryName;
            [_imageView2 sd_setImageWithURL:[NSURL URLWithString:[mBookCategoryObject.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_菜单_胎教"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [_imageView2 setImage:image];
                }
            }];
        } else if(i == 2){
            _label3.text = mBookCategoryObject.categoryName;
            [_imageView3 sd_setImageWithURL:[NSURL URLWithString:[mBookCategoryObject.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_菜单_胎教"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [_imageView3 setImage:image];
                }
            }];
        } else if(i == 3){
            _label4.text = mBookCategoryObject.categoryName;
            [_imageView4 sd_setImageWithURL:[NSURL URLWithString:[mBookCategoryObject.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_菜单_胎教"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [_imageView4 setImage:image];
                }
            }];
        } else if(i == 4){
            _label5.text = mBookCategoryObject.categoryName;
            [_imageView5 sd_setImageWithURL:[NSURL URLWithString:[mBookCategoryObject.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_菜单_胎教"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [_imageView5 setImage:image];
                }
            }];
        } else if(i == 5){
            _label6.text = mBookCategoryObject.categoryName;
            [_imageView6 sd_setImageWithURL:[NSURL URLWithString:[mBookCategoryObject.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_菜单_胎教"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [_imageView6 setImage:image];
                }
            }];
        }
    }
    
    
}

-(IBAction) onButtonClick1:(id)sender
{
    
    BookListViewController *mBookListViewController = [[BookListViewController alloc] init:nil mBookCategoryObject:[self.array objectAtIndex:0]];
    
    [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
}

-(IBAction) onButtonClick2:(id)sender
{
    BookListViewController *mBookListViewController = [[BookListViewController alloc] init:nil mBookCategoryObject:[self.array objectAtIndex:1]];
    
    [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
}

-(IBAction) onButtonClick3:(id)sender
{
    BookListViewController *mBookListViewController = [[BookListViewController alloc] init:nil mBookCategoryObject:[self.array objectAtIndex:2]];
    
    [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
}

-(IBAction) onButtonClick4:(id)sender
{
    BookListViewController *mBookListViewController = [[BookListViewController alloc] init:nil mBookCategoryObject:[self.array objectAtIndex:3]];
    
    [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
}

-(IBAction) onButtonClick5:(id)sender
{
    BookListViewController *mBookListViewController = [[BookListViewController alloc] init:nil mBookCategoryObject:[self.array objectAtIndex:4]];
    
    [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
}

-(IBAction) onButtonClick6:(id)sender
{
    BookListViewController *mBookListViewController = [[BookListViewController alloc] init:nil mBookCategoryObject:[self.array objectAtIndex:5]];
    
    [APP_DELEGATE.navigationController pushViewController:mBookListViewController animated:YES];
}

@end
