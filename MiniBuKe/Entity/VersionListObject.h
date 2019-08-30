//
//  VersionListObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionListObject : NSObject

@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *value;
@property (nonatomic) bool checked;

+(VersionListObject *) withObject:(NSDictionary *) dic;

@end
