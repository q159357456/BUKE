//
//  TalkMessageModel.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TalkMessageModel.h"

@implementation TalkMessageModel


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.messageType = (MessageType )[[aDecoder decodeObjectForKey:@"messageType"] integerValue];
        self.messageSenderType = (MessageSenderType )[[aDecoder decodeObjectForKey:@"messageSenderType"] integerValue];
        self.messageSentStatus = (MessageSentStatus )[[aDecoder decodeObjectForKey:@"messageSentStatus"] integerValue];
        self.messageReadStatus = (MessageReadStatus )[[aDecoder decodeObjectForKey:@"messageReadStatus"] integerValue];
        self.showMessageTime = [[aDecoder decodeObjectForKey:@"showMessageTime"] boolValue];
        self.messageTime = [aDecoder decodeObjectForKey:@"messageTime"];
        self.showNickName = [[aDecoder decodeObjectForKey:@"showNickName"] boolValue];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.logoUrl = [aDecoder decodeObjectForKey:@"logoUrl"];
        self.messageText = [aDecoder decodeObjectForKey:@"messageText"];
        self.duringTime = [[aDecoder decodeObjectForKey:@"duringTime"] integerValue];
        self.voiceUrl = [aDecoder decodeObjectForKey:@"voiceUrl"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.imageSmall = [aDecoder decodeObjectForKey:@"imageSmall"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.messageType] forKey:@"messageType"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.messageSenderType] forKey:@"messageSenderType"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.messageSentStatus] forKey:@"messageSentStatus"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.messageReadStatus] forKey:@"messageReadStatus"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.showMessageTime] forKey:@"showMessageTime"];
    [aCoder encodeObject:self.messageTime forKey:@"messageTime"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.showNickName] forKey:@"showNickName"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.logoUrl forKey:@"logoUrl"];
    [aCoder encodeObject:self.messageText forKey:@"messageText"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.duringTime] forKey:@"duringTime"];
    [aCoder encodeObject:self.voiceUrl forKey:@"voiceUrl"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.imageSmall forKey:@"imageSmall"];
    
}


@end
