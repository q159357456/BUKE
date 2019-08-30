//
//  MemberModel.h
//  MiniBuKe
//
//  Created by chenheng on 2019/5/23.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MemberInfo;
NS_ASSUME_NONNULL_BEGIN
@interface MemberModel : NSObject
@property (nonatomic, assign) NSInteger code;
@property (copy, nonatomic) NSString *msg;
@property (nonatomic, strong)MemberInfo *data;
@end


@interface MemberInfo : NSObject
@property(nonatomic,copy)NSString * appellativeName;
@property(nonatomic,copy)NSString * endTime;
@property(nonatomic,copy)NSString * imageUrl;
@property(nonatomic,copy)NSString * memberImg;
@property(nonatomic,copy)NSString * nickName;
@property(nonatomic,copy)NSString * memberTime;
@property(nonatomic,assign)NSInteger  isMemberActive;
@property(nonatomic,assign)NSInteger isSH;
@end
NS_ASSUME_NONNULL_END
