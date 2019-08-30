//
//  BookHistoryReadInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/23.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookHistoryReadInfo : NSObject

@property (nonatomic,strong) NSString *readBookNum;
@property (nonatomic,strong) NSString *longTime;

+(BookHistoryReadInfo *) withObject:(NSDictionary *) dic;

@end
