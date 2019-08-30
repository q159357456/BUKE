//
//  ARDownFlieManager.h
//  MiniBuKe
//
//  Created by Don on 2019/5/28.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARDownFlieManager : NSObject

+(instancetype)shareInstance;

/**下载或者更新本地图书数据*/
- (void)downFlieWithURLStr:(ARBookDownModel*)model Andprogress:(void(^)(NSProgress * _Nonnull downloadProgress))dowloadprogress AndFinish:(void(^)(NSString* path,NSString* bookId,BOOL success))completionHandler;

/**检查图书是否需要本地下载or更新*/
- (BOOL)CheckTheBookIsNeedDown:(ARBookDownModel*)model;

/**获取本地图书路径(无需更新本地绘本时调用)*/
- (NSString*)GetTheBookSavePath:(ARBookDownModel*)model;

/**判断可用储存空间是否小于200M*/
- (BOOL)checkTheDiskMerrorySizeIsLess;

/**获取本地图书缓存大小*/
- (uint64_t)checkBookDownSize;

/**清除所有下载本地图书*/
- (void)removeAllDownBook;

/**取消当前下载*/
- (void)cancelDownBook;

@end

NS_ASSUME_NONNULL_END
