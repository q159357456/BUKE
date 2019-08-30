//
//  ARReportUDIDManager.h
//  MiniBuKe
//
//  Created by chenheng on 2019/6/20.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARReportUDIDManager : NSObject
@property(nonatomic,copy)NSMutableArray * udidSource;
@property(nonatomic,copy)NSString * uuid;
+(instancetype)singleton;
//添加
-(void)addUDID:(NSString*)UIDD;
//删除
-(void)deletUDID:(NSString*)UIDD;

-(void)updateUDID;


@end

NS_ASSUME_NONNULL_END
