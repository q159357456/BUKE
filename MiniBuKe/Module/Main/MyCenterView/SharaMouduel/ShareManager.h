//
//  ShareManager.h
//  MiniBuKe
//
//  Created by chenheng on 2019/7/24.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareManager : NSObject
+(instancetype)singleton;
-(void)getTemplate:(NSInteger)tag WebView:(WKWebView*)webView;
-(void)showShareTemplate:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
