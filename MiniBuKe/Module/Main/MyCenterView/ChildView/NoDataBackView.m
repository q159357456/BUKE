//
//  NoDataBackView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/8/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "NoDataBackView.h"

@interface NoDataBackView()

@property(nonatomic,assign) CGRect imageBound;
@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) UILabel *label;

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,copy) NSString *title;

@end

@implementation NoDataBackView

-(instancetype)initWithImageBound:(CGRect)imageBound WithImage:(UIImage *)image WithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        
        self.image = image;
        self.title = title;
        self.imageBound = imageBound;
        
        if (IS_IPHONE_X) {
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 88);
        }else{
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        }
        
        
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageWidth = self.imageBound.size.width;
    CGFloat imageHeight = self.imageBound.size.height;
    if (IS_IPHONE_X) {
        self.imageView.frame = CGRectMake((self.frame.size.width - imageWidth)*0.5, (self.frame.size.height - imageHeight)*0.5 - 88, imageWidth, imageHeight);
    }else{
        self.imageView.frame = CGRectMake((self.frame.size.width - imageWidth)*0.5, (self.frame.size.height - imageHeight)*0.5 - 64, imageWidth, imageHeight);
    }
    
    
    CGFloat labelHeight;
    if (imageWidth <= 375) {
        labelHeight = 50;
    }else{
        labelHeight = 20;
    }
    self.label.frame = CGRectMake((self.frame.size.width - imageWidth - 20)*0.5, self.imageView.frame.origin.y + self.imageView.frame.size.height + 20, imageWidth + 20, labelHeight);
    
}

#pragma mark - getter&&setter
-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = self.image;
    }
    
    return _imageView;
}

-(UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = COLOR_STRING(@"#9B9B9B");
        _label.font = MY_FONT(15);
        _label.numberOfLines = 0;
//        _label.text = self.title;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.title];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        _label.attributedText = str;
    }
    
    return _label;
}

@end
