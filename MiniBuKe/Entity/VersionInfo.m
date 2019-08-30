//
//  VersionInfo.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "VersionInfo.h"

@implementation VersionRange

+(VersionRange *) withObject:(NSDictionary *) dic
{
//    version
//    start
    VersionRange *obj = nil;
    if (dic != nil) {
        obj = [[VersionRange alloc] init];
        
        obj.startVersion = ![[dic objectForKey:@"startVersion"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"startVersion"] : @"";
        obj.endVersion = ![[dic objectForKey:@"endVersion"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"endVersion"] : @"";
        
        NSLog(@"VersionRange obj.version ==> %@ obj.start ==> %@",obj.startVersion,obj.endVersion);
    }
    
    
    return obj;
}

@end

@implementation UpdateTypeObject

+(UpdateTypeObject *) withObject:(NSDictionary *) dic
{
//    versionRanges
//    option
    
    UpdateTypeObject *obj = nil;
    if (dic != nil) {
        obj = [[UpdateTypeObject alloc] init];
        
        id versionRanges = ![[dic objectForKey:@"versionRanges"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"versionRanges"] : @"";
        
        if ([versionRanges isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *) versionRanges;
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < array.count; i ++) {
                NSDictionary *dic = [array objectAtIndex:i];
                VersionRange *vr = [VersionRange withObject:dic];
                [tempArray addObject:vr];
            }
            obj.versionRanges = tempArray;
        }
        
        obj.option = ![[dic objectForKey:@"option"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"option"] : @"";
        
        NSLog(@"UpdateTypeObject obj.versionRanges ==> %@ obj.option ==> %@",obj.versionRanges,obj.option);
    }
    
    
    return obj;
}

@end

@implementation VersionInfo

+(VersionInfo *) withObject:(NSDictionary *) dic
{
    VersionInfo *obj = nil;
    if (dic != nil) {
        obj = [[VersionInfo alloc] init];
        
        obj.version = ![[dic objectForKey:@"version"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"version"] : @"";
        obj.mDescription = ![[dic objectForKey:@"description"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"description"] : @"";
        obj.path = ![[dic objectForKey:@"path"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"path"] : @"";
        
        id updateDic = ![[dic objectForKey:@"update"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"update"] : @"";
        
        if ([updateDic isKindOfClass:[NSDictionary class]]) {
            
            id forcesDic = ![[updateDic objectForKey:@"force"] isKindOfClass:[NSNull class]] ? [updateDic objectForKey:@"force"] : @"";
            
            if ([forcesDic isKindOfClass:[NSDictionary class]]) {
                obj.forces = [UpdateTypeObject withObject:forcesDic];
            }
            
            id grayDic = ![[updateDic objectForKey:@"gray"] isKindOfClass:[NSNull class]] ? [updateDic objectForKey:@"gray"] : @"";
            
            if ([grayDic isKindOfClass:[NSDictionary class]]) {
                obj.grays = [UpdateTypeObject withObject:grayDic];
            }
            
            id recommendDic = ![[updateDic objectForKey:@"recommend"] isKindOfClass:[NSNull class]] ? [updateDic objectForKey:@"recommend"] : @"";
            
            if ([recommendDic isKindOfClass:[NSDictionary class]]) {
                obj.recommends = [UpdateTypeObject withObject:recommendDic];
            }
            
        }
        NSLog(@"VersionInfo == obj.version => %@, obj.mDescription => %@, obj.path => %@, obj.forces => %@, obj.grays => %@, obj.recommends => %@",obj.version,obj.mDescription,obj.path,obj.forces,obj.grays,obj.recommends);
        
    }
    
    return obj;
}

-(VersionUpdateType) getVersionUpdateType:(NSString *) currentVersionStr;
{
    VersionUpdateType result = VersionUpdateTypeNone;
    NSArray *currentVersion = [currentVersionStr componentsSeparatedByString:@"."];
//    int currentVersion = [[currentVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
//    int newVersion = [[self.version stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
//    NSLog(@"currentVersion ==> %i = %@ = %i",currentVersion,currentVersionStr,newVersion);
    if ([self isNeedUpdateWithCurrent:currentVersionStr andServer:self.version]) {
        NSLog(@"NeedUpdate");
        if (self.forces != nil) {
            result = [self isEqualVersion:currentVersion setUpdateTypeObject:self.forces];
            if (result) {
                return VersionUpdateTypeForce;
            }
        }
        
        if (self.grays != nil) {
            result = [self isEqualVersion:currentVersion setUpdateTypeObject:self.grays];
            if (result) {
                return VersionUpdateTypeGray;
            }
        }
        
        if (self.recommends != nil) {
            result = [self isEqualVersion:currentVersion setUpdateTypeObject:self.recommends];
            if (result) {
                return VersionUpdateTypeRecommend;
            }
        }
        
    }
    
    return result;
}

-(BOOL) isEqualVersion:(NSArray*) currentVersion setUpdateTypeObject:(UpdateTypeObject *) mUpdateTypeObject
{
    BOOL result = NO;
    
    if (mUpdateTypeObject != nil) {
        if (mUpdateTypeObject.versionRanges != nil && mUpdateTypeObject.versionRanges.count > 0)
        {
            
            for (int i = 0; i < mUpdateTypeObject.versionRanges.count; i ++) {
                VersionRange *mVersionRange = [mUpdateTypeObject.versionRanges objectAtIndex:i];
                NSArray *startarray = [mVersionRange.startVersion componentsSeparatedByString:@"."];
                NSArray *endarray = [mVersionRange.endVersion componentsSeparatedByString:@"."];
                NSString *startStr=@"" ;
                NSString *endStr=@"";
                NSString *currentStr=@"";
                for (int i = 0; i<startarray.count; i++) {
                    startStr = [startStr stringByAppendingString:[NSString stringWithFormat:@"%02d",[startarray[i] intValue]]];
                    endStr = [endStr stringByAppendingString:[NSString stringWithFormat:@"%02d",[endarray[i] intValue]]];
                    currentStr = [currentStr stringByAppendingString:[NSString stringWithFormat:@"%02d",[currentVersion[i] intValue]]];
                }
//                int startVersion = [[mVersionRange.startVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
//                int endVersion = [[mVersionRange.endVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
                int startVersion = [startStr intValue];
                int endVersion = [endStr intValue];
                int currVersion = [currentStr intValue];

                for (int i = startVersion; i <= endVersion ; i++) {
                    if (i == currVersion) {
                        result = YES;
                        return result;
                    }
                }
            }
            
        }
    }
    return result;
}

- (BOOL)isNeedUpdateWithCurrent:(NSString*)currentVison andServer:(NSString*)serverVison{
    NSArray *currentarray = [currentVison componentsSeparatedByString:@"."];
    NSArray *serverarray = [serverVison componentsSeparatedByString:@"."];
    for(int i = 0;i<serverarray.count;i++){
        int serNumber = [serverarray[i] intValue];
        int number = [currentarray[i] intValue];
        if (serNumber > number) {
            return YES;
        }
    }
    return NO;
}
@end
