//
//  AudioCachModel.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioCachModel : NSObject<NSCoding>

/**
 * 下载本地path
 */
@property(nonatomic,copy) NSString *localPath;

/**
 * 网络url
 */
@property(nonatomic,copy) NSString *urlString;


@end
