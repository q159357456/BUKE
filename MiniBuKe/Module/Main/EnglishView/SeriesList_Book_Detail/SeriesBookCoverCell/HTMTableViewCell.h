//
//  HTMTableViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/19.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#define HTML_WebView_Height_Event @"HTML_WebView_Height_Event"
#define HTML_WebView_Intens_Event @"HTML_WebView_Intens_Event"
typedef NS_ENUM(NSUInteger, Html_State) {
    Guide_State=0,
    Introduction_State,
};
@protocol HTMTableViewCellDelegate<NSObject>
@optional
-(void)scroDidend:(NSInteger)index;
@end
@interface HTMTableViewCell : UITableViewCell
@property(nonatomic,strong)WKWebView *webview;
@property(nonatomic,strong)WKWebView *webview1;
@property(nonatomic,strong)UIScrollView *scroView;
@property(nonatomic,copy)NSString *introduction;
@property(nonatomic,assign)BOOL  isGuide;
@property(nonatomic,assign)BOOL  isScanningTo;
@property(nonatomic,assign)Html_State html_State;
@property(nonatomic,assign)id<HTMTableViewCellDelegate>delegate;
@end
