//
//  CustomVoiceMessage.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "CustomVoiceMessage.h"
#define RCLocalMessageTypeIdentifier @"xbk:voicePlay" //消息类型
#define KEY_VOICE @"voice"
#define KEY_EXTRA @"extra"

@implementation CustomVoiceMessage

#pragma mark - NSCoding
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.voice = [aDecoder decodeObjectForKey:KEY_VOICE];
        self.extra = [aDecoder decodeObjectForKey:KEY_EXTRA];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.voice forKey:KEY_VOICE];
    [aCoder encodeObject:self.extra forKey:KEY_EXTRA];
}

#pragma mark - RCMessageCoding delegate
//将消息内容编码成json
-(NSData *)encode
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:self.voice forKey:@"voice"];
    
    [dataDic setObject:self.extra forKey:@"extra"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic options:kNilOptions error:nil];
    return data;
}

//将json解码生成消息内容
-(void)decodeWithData:(NSData *)data
{
    NSError *error = nil;
    if (!data) {
        return;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"dictionary====>:%@",dictionary);
    
    self.voice = ![[dictionary objectForKey:@"voice"] isKindOfClass:[NSNull class]] ? [dictionary objectForKey:@"voice"] : @"";
    self.extra = ![[dictionary objectForKey:@"extra"] isKindOfClass:[NSNull class]] ? [dictionary objectForKey:@"extra"] : @"";
    
}

//您定义的消息类型名，需要在各个平台上保持一致，以保证消息互通,别以 RC 开头，以免和融云系统冲突
+(NSString *)getObjectName {
    return RCLocalMessageTypeIdentifier;
}

+(RCMessagePersistent)persistentFlag
{
    return (MessagePersistent_ISCOUNTED);
}

@end
