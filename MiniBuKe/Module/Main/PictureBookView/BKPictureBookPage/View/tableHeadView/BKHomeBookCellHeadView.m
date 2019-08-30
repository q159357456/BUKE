//
//  BKHomeBookCellHeadView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomeBookCellHeadView.h"

@interface BKHomeBookCellHeadView()

@property (nonatomic, weak) IBOutlet UIButton *moreBtn;
@property (nonatomic, weak) IBOutlet UIImageView *moreImageFlag;
@property (nonatomic, weak) IBOutlet UILabel *moreImageLabel;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation BKHomeBookCellHeadView
- (instancetype)initWithFrame:(CGRect)frame andTitleStr:(NSString*)titleStr andSection:(NSInteger)section andisHideLine:(BOOL)ishide{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"BKHomeBookCellHeadView" owner:nil options:nil].lastObject;
        self.frame = frame;
        self.tag = section;
        [self setupUIwith:titleStr andisHideLine:ishide];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"BKHomeBookCellHeadView" owner:nil options:nil].lastObject;
        self.frame = frame;
    }
    return self;
}

- (void)setupUIwith:(NSString*)titleStr  andisHideLine:(BOOL)ishide{
    self.titleLabel.text = titleStr;
    self.moreBtn.hidden = ishide;
    self.moreImageLabel.hidden = ishide;
    self.moreImageFlag.hidden = ishide;
    
    if (self.tag == 44) {
        self.moreImageLabel.text = @"全部";
    }else{
        self.moreImageLabel.text = @"更多";
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (IBAction)MoreBtnClick:(UIButton*)btn{
    NSLog(@"MorebtnClick-tag=%ld",self.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeTableHeaderViewRightBtnAction:)]) {
        [self.delegate homeTableHeaderViewRightBtnAction:self.tag];
    }
}
@end
