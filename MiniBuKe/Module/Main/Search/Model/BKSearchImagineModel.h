//
//  BKSearchImagineModel.h
//  MiniBuKe
//
//  Created by chenheng on 2019/1/11.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImagineData,ImagineTitleModel;

NS_ASSUME_NONNULL_BEGIN

@interface BKSearchImagineModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (copy, nonatomic) NSString *msg;
@property (strong, nonatomic) NSMutableArray *data;

@end

//@interface ImagineData : NSObject
//
//@property (nonatomic, strong) NSMutableArray *list;
//
//@end
//
//@interface ImagineTitleModel : NSObject
//
//@property (nonatomic, copy) NSString *title;
//
//@end

NS_ASSUME_NONNULL_END
