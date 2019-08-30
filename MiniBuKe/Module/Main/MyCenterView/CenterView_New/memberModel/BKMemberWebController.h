//
//  BKMemberWebController.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BKMemberWebController : UIViewController
@property(nonatomic,strong)MemberInfo *memberInfo;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong) WKWebView *webview;
@property (nonatomic, strong) UIButton *backBtn;
@property(nonatomic,copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
