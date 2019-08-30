//
//  BKHomeCellHeadView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomeCellHeadView.h"
@interface BKHomeCellHeadView()
@property(nonatomic, weak) IBOutlet UILabel *themeTitle;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation BKHomeCellHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"BKHomeCellHeadView" owner:nil options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (void)setThemeTitleWith:(NSString*)title{
//    self.themeTitle.text = [NSString stringWithFormat:@"(主题:%@)",title];
    self.title.text = title;
}

@end
