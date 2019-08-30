//
//  KBookVoiceInfo.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBookVoiceInfo : NSObject

@property(nonatomic,assign) NSInteger bookId;
@property(nonatomic,copy) NSString *pic;
@property(nonatomic,copy) NSString *audio;
@property(nonatomic,assign) NSInteger pageNum;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *status;// 0:未录制  1:录制
@property(nonatomic,copy) NSString *kAudio;//k语音


+(KBookVoiceInfo *)parseDataByDictionary:(NSDictionary *)dic;

@end
