//
//  ShareModel.h
//  MiniBuKe
//
//  Created by chenheng on 2019/1/24.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareModel : NSObject
@property(nonatomic,copy)NSString *auth;
@property(nonatomic,copy)NSString *saying;
@property(nonatomic,copy)NSString *shareImage;
@property(nonatomic,copy)NSString *shareUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *shareType;
@property(nonatomic,copy)NSString *templateType;
@property(nonatomic,copy)NSString *templateID;


+(ShareModel*)getShareModelWithDic:(NSDictionary*)dic;
@end

@interface ShareURLModel : NSObject
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * mdescription;
@property(nonatomic,copy)NSString * thumbImage;
@end
@interface ShareImageModel : NSObject
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * image;
@end
@interface ShareMinProjModel : NSObject
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * mdescription;
@property(nonatomic,copy)NSString * webpageUrl;
@property(nonatomic,copy)NSString * path;
@property(nonatomic,copy)NSString * thumbImage;
@property(nonatomic,copy)NSString * hdThumbImage;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic,copy)NSString * withShareTicket;
@property(nonatomic,assign)NSInteger  type;
@end
NS_ASSUME_NONNULL_END
