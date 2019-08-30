//
//  VersionInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VersionUpdateType) {
    VersionUpdateTypeNone,
    VersionUpdateTypeForce,
    VersionUpdateTypeGray,
    VersionUpdateTypeRecommend
};

@interface VersionRange : NSObject

@property (nonatomic,strong) NSString *startVersion;
@property (nonatomic,strong) NSString *endVersion;

+(VersionRange *) withObject:(NSDictionary *) dic;

@end

@interface UpdateTypeObject : NSObject

@property (nonatomic,strong) NSArray *versionRanges;
@property (nonatomic,strong) NSString *option;

+(UpdateTypeObject *) withObject:(NSDictionary *) dic;

@end

@interface VersionInfo : NSObject

@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *mDescription;
@property (nonatomic,strong) NSString *path;

@property (nonatomic,strong) UpdateTypeObject *forces;
@property (nonatomic,strong) UpdateTypeObject *grays;
@property (nonatomic,strong) UpdateTypeObject *recommends;

+(VersionInfo *) withObject:(NSDictionary *) dic;

-(VersionUpdateType) getVersionUpdateType:(NSString *) currentVersionStr;

@end


