//
//  CustomVoiceMessage.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface CustomVoiceMessage : RCMessageContent<NSCoding>

@property(nonatomic,copy) NSString *extra;
@property(nonatomic,copy) NSString *voice;


@end
