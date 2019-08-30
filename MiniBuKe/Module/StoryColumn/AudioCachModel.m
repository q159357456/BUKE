//
//  AudioCachModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "AudioCachModel.h"

@implementation AudioCachModel


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.urlString = [aDecoder decodeObjectForKey:@"urlString"];
        self.localPath = [aDecoder decodeObjectForKey:@"localPath"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.urlString forKey:@"urlString"];
    [aCoder encodeObject:self.localPath forKey:@"localPath"];
}


@end
