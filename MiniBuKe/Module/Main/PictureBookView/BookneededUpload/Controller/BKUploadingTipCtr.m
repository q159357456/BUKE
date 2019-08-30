//
//  BKUploadingTipCtr.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/15.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKUploadingTipCtr.h"
#import "BKuploadTipView.h"

@interface BKUploadingTipCtr ()

@property(nonatomic, copy) NSString *des;
@property(nonatomic, copy) NSString *toptitle;
@property(nonatomic, copy) NSString *leftBtnTitle;
@property(nonatomic, copy) NSString *rightBtnTitle;
@property(nonatomic, copy) NSString *iconName;

@property(nonatomic, strong) BKuploadTipView *tipView;

@end

@implementation BKUploadingTipCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithTitle:(NSString*)title andDes:(NSString*)des andleftBtnTitle:(NSString*)leftBtnTitle andrightBtnTitle:(NSString*)rightBtnTitle andIconName:(NSString*)iconName{
    if (self = [super init]) {
        self.toptitle = title;
        self.des = des;
        self.leftBtnTitle = leftBtnTitle;
        self.rightBtnTitle = rightBtnTitle;
        self.iconName = iconName;
        
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    self.tipView = [[BKuploadTipView alloc]init];
    [self.tipView setTitle:self.toptitle des:self.des andImage:self.iconName andLeftBtnTitle:self.leftBtnTitle andRightBtnTitle:self.rightBtnTitle];
    __weak typeof(self) weakSelf = self;

    [self.tipView setLeftBtnClick:^{
        if (weakSelf.uploadTipLeftBtnClick) {
            weakSelf.uploadTipLeftBtnClick();
        }
        [weakSelf dissMissCtr];
    }];
    [self.tipView setRightBtnClick:^{
        if (weakSelf.uploadTipRightBtnClick) {
            weakSelf.uploadTipRightBtnClick();
        }
        [weakSelf dissMissCtr];
    }];
    self.tipView.center = self.view.center;
    [self.view addSubview:self.tipView];
}

- (void)dissMissCtr{
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.backgroundColor = [UIColor clearColor];
//    }completion:^(BOOL finished) {
//        [self dismissViewControllerAnimated:NO completion:^{
//
//        }];
//    }];
    [self dismissViewControllerAnimated:NO completion:^{

    }];

}


@end
