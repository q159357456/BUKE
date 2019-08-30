//
//  BKWalletFriendBuyView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKWalletFriendBuyView.h"

@interface BKWalletFriendBuyView()

@property(nonatomic, weak) IBOutlet UILabel *showLabel;
@property(nonatomic, weak) IBOutlet UIView *botomView;

@end

@implementation BKWalletFriendBuyView

- (instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"BKWalletFriendBuyView" owner:nil options:nil] lastObject];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 94);
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.botomView.layer.cornerRadius = 4.f;
    self.botomView.clipsToBounds = YES;
}

- (void)reloadContentShow:(NSInteger)count and:(NSInteger)registCount{
    self.showLabel.text = [NSString stringWithFormat:@"%ld个好友注册，%ld次成功推荐购买",registCount,count];
}

@end
