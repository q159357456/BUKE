//
//  BkHomeCategory.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BkHomeCategory.h"

@interface BkHomeCategory()
@property(nonatomic, weak) IBOutlet UIImageView *imageView;
@property(nonatomic, weak) IBOutlet UILabel *title;
@property(nonatomic, weak) IBOutlet UIButton *btn;


@end

@implementation BkHomeCategory
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"BkHomeCategory" owner:nil options:nil].lastObject;
        self.frame = frame;

    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setImageURl:(NSString*)url andTitle:(NSString*)title{
    
    CGFloat w = (42.f/375.f)*SCREEN_WIDTH*[UIScreen mainScreen].scale;
    NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",url,(int)w];

    [self.imageView  sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:[UIImage imageNamed:@"place_icon_imagec"] options:SDWebImageRetryFailed];
    self.title.text = title;
    
}

- (IBAction)btnClick:(id)sender{
    NSLog(@"caegory Click- %ld",self.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(CategoryBtnClick:)]) {
        [self.delegate CategoryBtnClick:self.tag];
    }

}
@end
