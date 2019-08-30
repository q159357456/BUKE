//
//  XBKNetWorkManager.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "BKBannerDataModel.h"
#import "BKHomeBookCategoryModel.h"
#import "BKHomeListModel.h"
#import "BKMoreNewBookListModel.h"
#import "BkWalletInfoModel.h"
#import "BKWalletDetailsModel.h"
#import "BKTixianProgressModel.h"
#import "BKSearchImagineModel.h"
#import "BKUserSNFetchModel.h"
#import "BKSNCallRecordsModel.h"
#import "MemberModel.h"
#import "ARBookDownModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XBKNetWorkManager : NSObject

/**Barnner获取接口请求
 type :2为绘本首页banner,3为故事首页banner
 */
+(instancetype)requestBarnnerWithType:(NSString*)type AndFinish:(void(^)(BKBannerDataModel *model,NSError *error))completionHandler;

/**绘本首页分类接口*/
+(instancetype)requestHomebookCategoryAndFinish:(void(^)(BKHomeBookCategoryModel *model,NSError *error))completionHandler;

/**绘本首页列表接口
 type:类型 ：我的1 绘本2 故事3 英语4
 */
+(instancetype)requestHomeBookListWithType:(NSString*)type andPage:(NSInteger)page andPageNumber:(NSInteger)pageNumber AndFinish:(void(^)(BKHomeListModel *model,NSError *error))completionHandler;

/**最新上架 book 分页接口*/
+(instancetype)requestNewBookListWithPage:(NSInteger)page AndPageNumber:(NSInteger)pageNumber AndFinish:(void(^)(BKMoreNewBookListModel *model,NSError *error))completionHandler;

/**缺书登记 图片批量上传 接口*/
+(instancetype)requestBookRegisterPictureWithImageArray:(NSArray*)array AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;

+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

/**获取用户钱包金额 接口*/
+(instancetype)requestWalletInfoAndAndFinish:(void(^)(BkWalletInfoModel *model,NSError *error))completionHandler;
/**获取用户钱包明细详情 分页 接口*/
+(instancetype)requestWalletDetailsDWithpage:(NSInteger)page pageNumber:(NSInteger)pageNumber AndAndFinish:(void(^)(BKWalletDetailsModel *model,NSError *error))completionHandler;
/**用户申请提现 接口*/
+(void)requestWalletTiXianWithmoneyType:(NSInteger)moneyType AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;

/**用户提现进度查询 接口*/
+(void)requestWalletTiXianProgressWithTransactionId:(NSString*)transactionId AndAndFinish:(void(^)(BKTixianProgressModel *model,NSError *error))completionHandler;

/**搜索框联想查询*/
+(void)requestSearchImagineWordWithSearchKey:(NSString*)searchKey AndAndFinish:(void(^)(BKSearchImagineModel* model,NSError *error))completionHandler;

/**搜索框联想词查询上报*/
+(void)requestSearchImagineWordRecordWithSearchKey:(NSString*)searchKey andImagineKey:(NSString*)imagineKey AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;

/**设置信鸽标签*/
+(void)requestAddXGTagWithtag:(NSString*)tag AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;
/**删除信鸽所有标签*/
+(void)requestDeleteXGAllTagWithtag:(NSString*)tag AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;
/**删除信鸽用户绑定的标签*/
+(void)requestDeleteXGUserTagWithtag:(NSString*)tag AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;

#pragma mark - babyCare相关
/**查询用户绑定机器SN号*/
+(void)requestUserFetchSNAndAndFinish:(void(^)(BKUserSNFetchModel* model,NSError *error))completionHandler;
/**解除机器绑定*/
+(void)requestUnLashRobotAndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;
/**查询机器通话记录*/
+(void)requestFetchSNCallRecordsWithSN:(NSString*)sn Page:(NSInteger)page PageNumber:(NSInteger)pageNumber AndAndFinish:(void(^)(BKSNCallRecordsModel *model,NSError *error))completionHandler;
/**app主叫新增通话记录*/
+(void)requestAddNewCallRecordsWithSN:(NSString*)sn AndiPhoneNumber:(NSString*)phone AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;
/**app更新通话记录状态*/
+(void)requestUpdateCallRecordsWithID:(NSInteger)recordId andState:(NSInteger)state AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;
/**查询通讯录接口*/
+(void)requestFetchContactsListWithSN:(NSString*)sn AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;

/**查询会员信息*/
+(void)memberFetchUserInfoFinish:(void(^)(MemberModel* model,NSError *error))completionHandler;
/*扫码激活*/
+(void)memberActivateMemberWithActivationCode:(NSString*)activationCode Finish:(void(^)(MemberModel* model,NSError *error))completionHandler;

/**手机端本地识别接口- featureId:图片识别码ID*/
+(void)requestAR_BookDownDataWithFeatureId:(NSString*)featureId AndAndFinish:(void(^)(ARBookDownModel * model,NSError *error))completionHandler;
/**本地识别获取音频地址*/
+(void)requestAR_BookAudioWith:(NSString*)bookId PageNumber:(NSString*)pageNumber AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler;
/**上报阅读数据*/
+(void)eventReportBookWithList:(NSArray*)reportList Finish:(void(^)(id responseObj,NSError *error))completionHandler;
/**会员购买*/
+(void)wxOrderWithDic:(NSDictionary*)dic Finish:(void(^)(id responseObj,NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
