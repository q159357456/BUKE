//
//  BabyBookCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BabyBookCell.h"
#import "BooklistObjet.h"
#import "BookDetailViewController.h"
#import "IntensiveReadingController.h"

@interface BabyBookCell ()

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIImageView *imageview1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *hintlabel1;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage1;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview2;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *hintlabel2;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage2;

@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *hintlabel3;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage3;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic) BOOL isSelectButton1;
@property (nonatomic) BOOL isSelectButton2;
@property (nonatomic) BOOL isSelectButton3;

@property (strong, nonatomic) BooklistObjet *obj1;
@property (strong, nonatomic) BooklistObjet *obj2;
@property (strong, nonatomic) BooklistObjet *obj3;

@property (nonatomic) BOOL isSelect;

@end

@implementation BabyBookCell

+(instancetype)xibTableViewCell {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BabyBookCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.isSelectButton1 = NO;
    self.isSelectButton2 = NO;
    self.isSelectButton3 = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateViewData:(CGSize ) size setArrayBooklistObjet:(NSArray  *)mBooklistObjets isSelect:(BOOL) isSelect
{
    self.isSelect = isSelect;
    
    self.imageview1.layer.cornerRadius = self.imageview1.frame.size.width/9.9;
    self.imageview1.layer.masksToBounds = YES;
    
    self.imageview2.layer.cornerRadius = self.imageview2.frame.size.width/9.9;
    self.imageview2.layer.masksToBounds = YES;
    
    self.imageview3.layer.cornerRadius = self.imageview3.frame.size.width/9.9;
    self.imageview3.layer.masksToBounds = YES;
    
    if(size.width > 375){
        self.view1.frame = CGRectMake((size.width / 3) * 1 - self.view1.frame.size.width - 10, self.view1.frame.origin.y, self.view1.frame.size.width, self.view1.frame.size.height);
        
        self.view2.frame = CGRectMake((size.width / 3) * 2 - self.view2.frame.size.width -10, self.view2.frame.origin.y, self.view2.frame.size.width, self.view2.frame.size.height);
        
        self.view3.frame = CGRectMake((size.width / 3) * 3 - self.view3.frame.size.width -10, self.view3.frame.origin.y, self.view3.frame.size.width, self.view3.frame.size.height);
    }
    
    self.view1.hidden = YES;
    self.view2.hidden = YES;
    self.view3.hidden = YES;
    
    if (self.isSelect) {
        self.selectedImage1.hidden = NO;
        self.selectedImage2.hidden = NO;
        self.selectedImage3.hidden = NO;
    } else {
        self.selectedImage1.hidden = YES;
        self.selectedImage2.hidden = YES;
        self.selectedImage3.hidden = YES;
    }
    
    
    for (int i = 0; i < mBooklistObjets.count; i++) {
        
        BooklistObjet *obj = [mBooklistObjets objectAtIndex:i];
        
        if (i == 0) {
            
            if (obj.isSelect) {
                self.isSelectButton1 = YES;
                [self.selectedImage1 setImage:[UIImage imageNamed:@"storyManager_selected"]];
                self.imageview1.alpha = 0.5;
                
            } else {
                self.isSelectButton1 = NO;
                [self.selectedImage1 setImage:[UIImage imageNamed:@"storyManager_selec"]];
                self.imageview1.alpha = 1.0;
            }
            
            self.view1.hidden = NO;
            
            self.label1.text = obj.name;
            self.hintlabel1.text = obj.author;
            
            
            [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:[obj.coverPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [self.imageview1 setImage:image];
                }
            }];
            self.obj1 = obj;
            
            
        } else if (i == 1){
            
            if (obj.isSelect) {
                self.isSelectButton2 = YES;
                [self.selectedImage2 setImage:[UIImage imageNamed:@"storyManager_selected"]];
                self.imageview2.alpha = 0.5;
                
            } else {
                self.isSelectButton2 = NO;
                [self.selectedImage2 setImage:[UIImage imageNamed:@"storyManager_selec"]];
                self.imageview2.alpha = 1.0;
            }
            
            self.view2.hidden = NO;
            
            self.label2.text = obj.name;
            self.hintlabel2.text = obj.author;
            
            [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:[obj.coverPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [self.imageview2 setImage:image];
                }
            }];
            
            self.obj2 = obj;
        }  else if (i == 2){
            
            if (obj.isSelect) {
                self.isSelectButton3 = YES;
                [self.selectedImage3 setImage:[UIImage imageNamed:@"storyManager_selected"]];
                self.imageview3.alpha = 0.5;
                
            } else {
                self.isSelectButton3 = NO;
                [self.selectedImage3 setImage:[UIImage imageNamed:@"storyManager_selec"]];
                self.imageview3.alpha = 1.0;
            }
            
            self.view3.hidden = NO;
            
            self.label3.text = obj.name;
            self.hintlabel3.text = obj.author;
            
            [self.imageview3 sd_setImageWithURL:[NSURL URLWithString:[obj.coverPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"首页_丛书系列_图片默认"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"sd_setImageWithURL ===> %@",error);
                if (image) {
                    [self.imageview3 setImage:image];
                }
            }];
            
            self.obj3 = obj;
        }
        
    }
}

-(IBAction)onButtonClick1:(id)sender
{
    NSLog(@"===> button click1 <===");
    
    if (self.isSelect) {
        if (!self.isSelectButton1) {
            self.isSelectButton1 = YES;
            [self.selectedImage1 setImage:[UIImage imageNamed:@"storyManager_selected"]];
            self.imageview1.alpha = 0.5;
            
        } else {
            self.isSelectButton1 = NO;
            [self.selectedImage1 setImage:[UIImage imageNamed:@"storyManager_selec"]];
            self.imageview1.alpha = 1.0;
        }
        
        if (self.delegate != nil) {
            [self.delegate onSelectCell:self.obj1 select:self.isSelectButton1];
        }
    } else {
//        BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:self.obj1];
//        [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
        IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
        vc.bookid = self.obj1.mid;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    }
    
    
}

-(IBAction)onButtonClick2:(id)sender
{
    NSLog(@"===> button click2 <===");
    if (self.isSelect) {
        if (!self.isSelectButton2) {
            self.isSelectButton2 = YES;
            [self.selectedImage2 setImage:[UIImage imageNamed:@"storyManager_selected"]];
            self.imageview2.alpha = 0.5;
            
        } else {
            self.isSelectButton2 = NO;
            [self.selectedImage2 setImage:[UIImage imageNamed:@"storyManager_selec"]];
            self.imageview2.alpha = 1.0;
        }
        
        if (self.delegate != nil) {
            [self.delegate onSelectCell:self.obj2 select:self.isSelectButton2];
        }
    } else {
//        BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:self.obj2];
//        [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
        
        IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
        vc.bookid = self.obj2.mid;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)onButtonClick3:(id)sender
{
    NSLog(@"===> button click3 <===");
    if (self.isSelect) {
        if (!self.isSelectButton3) {
            self.isSelectButton3 = YES;
            [self.selectedImage3 setImage:[UIImage imageNamed:@"storyManager_selected"]];
            self.imageview3.alpha = 0.5;
            
        } else {
            self.isSelectButton3 = NO;
            [self.selectedImage3 setImage:[UIImage imageNamed:@"storyManager_selec"]];
            self.imageview3.alpha = 1.0;
        }
        
        if (self.delegate != nil) {
            [self.delegate onSelectCell:self.obj3 select:self.isSelectButton3];
        }
    } else {
//        BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:self.obj3];
//        [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
        IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
        vc.bookid = self.obj3.mid;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    }
}

@end
