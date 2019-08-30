//
//  FetchBannerPicObjec.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchBannerPicObjec : NSObject

@property (nonatomic,strong) NSString *mid;
@property (nonatomic,strong) NSString *picURL;
@property (nonatomic,strong) NSString *categoryId;
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *sortNum;

+(FetchBannerPicObjec *) withObject:(NSDictionary *) dic;

@end
