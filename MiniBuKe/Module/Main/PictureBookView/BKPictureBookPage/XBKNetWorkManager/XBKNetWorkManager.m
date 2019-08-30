//
//  XBKNetWorkManager.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "XBKNetWorkManager.h"
#import "NSObject+CustomNetworking.h"

@implementation XBKNetWorkManager

+(instancetype)requestBarnnerWithType:(NSString*)type AndFinish:(void(^)(BKBannerDataModel* model,NSError *error))completionHandler{
    //banner图类别，2为绘本首页banner,3为故事首页banner
    NSString *path = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,@"/pub/fetchBannerPic/",type];
    return [self RequestNetWithType:BKRequestType_Get tokenFlag:tokenFlagUSER_TOKEN Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandler([BKBannerDataModel mj_objectWithKeyValues:responseObj],error);
    }];

}

/**绘本首页分类接口*/
+(instancetype)requestHomebookCategoryAndFinish:(void(^)(BKHomeBookCategoryModel *model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/book/category"];
    return [self RequestNetWithType:BKRequestType_Get tokenFlag:tokenFlagUSER_TOKEN Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandler([BKHomeBookCategoryModel mj_objectWithKeyValues:responseObj],error);
    }];
}

/**绘本首页列表接口
 type:类型 ：我的1 绘本2 故事3 英语4
 */
+(instancetype)requestHomeBookListWithType:(NSString*)type andPage:(NSInteger)page andPageNumber:(NSInteger)pageNumber AndFinish:(void(^)(BKHomeListModel *model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@/%ld/%ld/%@",SERVER_URL,@"/series/book/list",page,pageNumber,type];
    return [self RequestNetWithType:BKRequestType_Get tokenFlag:tokenFlagUSER_TOKEN Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        NSLog(@"book/list==>%@",responseObj);
        completionHandler([BKHomeListModel mj_objectWithKeyValues:responseObj],error);
    }];
}

/**最新上架 book 分页接口*/
+(instancetype)requestNewBookListWithPage:(NSInteger)page AndPageNumber:(NSInteger)pageNumber AndFinish:(void(^)(BKMoreNewBookListModel *model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@/%ld/%ld",SERVER_URL,@"/book/new/list",page,pageNumber];
    return [self RequestNetWithType:BKRequestType_Get tokenFlag:tokenFlagUSER_TOKEN Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandler([BKMoreNewBookListModel mj_objectWithKeyValues:responseObj],error);
    }];

}

/**缺书登记 图片批量上传 接口*/
+(instancetype)requestBookRegisterPictureWithImageArray:(NSArray*)array AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/file/batch/upload"];
    return [self RequestPostPicWithType:array Path:url parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        if(error){
            completionHandler(responseObj,error);
        }else{
            if ([[responseObj objectForKey:@"success"]integerValue]) {
                NSDictionary *dic = [responseObj objectForKey:@"data"];
                NSDictionary *listDic = [dic objectForKey:@"urlList"];
                if (listDic.count){
                    [self requestBookRegisterPictureURlWithImageArray:listDic AndAndFinish:^(id responseObj, NSError *error) {
                        completionHandler(responseObj,error);
                    }];
                }else{
                    completionHandler(responseObj,error);
                }
            }else{
                completionHandler(responseObj,error);
            }
        }
    }];
}
/**缺书登记 图片url批量上传 接口*/
+(instancetype)requestBookRegisterPictureURlWithImageArray:(NSDictionary*)list AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",SERVER_URL,@"/book/register/picture"];
    NSMutableString *str = [NSMutableString string];
    for (NSString *picurl in list) {
        NSString *str3 = [[NSString stringWithFormat:@"%@,",picurl] stringByAddingPercentEscapesUsingEncoding:                          NSUTF8StringEncoding];
        [str appendString:str3];
    }
    NSDictionary * paraDic = @{
                               @"pics":str
                               };
    return [self RequestNetWithType:BKRequestType_Post tokenFlag:tokenFlagUSER_TOKEN Path:path parameters:paraDic isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandler(responseObj,error);
    }];
}
/**限制图片大小压缩*/
+ (NSData *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}

/**获取用户钱包金额 接口*/
+(instancetype)requestWalletInfoAndAndFinish:(void(^)(BkWalletInfoModel *model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/pay/wallet"];
    return [self RequestNetWithType:BKRequestType_Get tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandler([BkWalletInfoModel mj_objectWithKeyValues:responseObj] ,error);
    }];
}
/**获取用户钱包明细详情 分页 接口*/
+(instancetype)requestWalletDetailsDWithpage:(NSInteger)page pageNumber:(NSInteger)pageNumber AndAndFinish:(void(^)(BKWalletDetailsModel *model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@?page=%@&size=%@",NewLoginSERVER_URL,@"/pay/wallet/details",[NSString stringWithFormat:@"%ld",page],[NSString stringWithFormat:@"%ld",pageNumber]];

    return [self RequestNetWithType:BKRequestType_Get tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        completionHandler([BKWalletDetailsModel mj_objectWithKeyValues:responseObj],error);
    }];
}
/**用户申请提现 接口*/
+(void)requestWalletTiXianWithmoneyType:(NSInteger)moneyType AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/pay/transaction/apply"];
    NSDictionary *parameters = @{@"moneyType":@(moneyType)};
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**用户提现进度查询 接口*/
+(void)requestWalletTiXianProgressWithTransactionId:(NSString*)transactionId AndAndFinish:(void(^)(BKTixianProgressModel *model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/pay/transaction/apply/progress"];
    NSDictionary *parameters = @{@"transactionId":transactionId};
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return  completionHandler([BKTixianProgressModel mj_objectWithKeyValues:responseObj],error);
    }];
}

/**搜索框联想查询*/
+(void)requestSearchImagineWordWithSearchKey:(NSString*)searchKey AndAndFinish:(void(^)(BKSearchImagineModel *model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/external/es/search"];
    NSDictionary *parameters = @{@"searchKey":searchKey};
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler([BKSearchImagineModel mj_objectWithKeyValues:responseObj],error);
    }];
}
/**搜索框联想词查询上报*/
+(void)requestSearchImagineWordRecordWithSearchKey:(NSString*)searchKey andImagineKey:(NSString*)imagineKey AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/external/es/search/record"];
    NSDictionary *parameters = @{@"searchText":searchKey,@"matchingText":imagineKey};
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**设置信鸽标签*/
+(void)requestAddXGTagWithtag:(NSString*)tag AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/external/msg/tag/add"];
    NSDictionary *parameters = @{@"tag":tag};
    [self RequestNetAndIsJSONParameter:NO With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**删除信鸽所有标签*/
+(void)requestDeleteXGAllTagWithtag:(NSString*)tag AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/external/msg/tag/delete"];
    NSDictionary *parameters = @{@"tag":tag};
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Delete tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**删除信鸽用户绑定的标签*/
+(void)requestDeleteXGUserTagWithtag:(NSString*)tag AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",NewLoginSERVER_URL,@"/external/msg/tag/delete/user"];
    NSDictionary *parameters = @{@"tag":tag};
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Delete tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];

}

/**查询用户绑定机器SN号*/
+(void)requestUserFetchSNAndAndFinish:(void(^)(BKUserSNFetchModel* model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",BeforeHandEnv_URL,@"/device/sn/getBindingDeviceInfo"];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Get tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        NSLog(@"查询SN-%@",responseObj);
        return completionHandler([BKUserSNFetchModel mj_objectWithKeyValues:responseObj],error);
    }];
}

/**解除机器绑定*/
+(void)requestUnLashRobotAndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@",BeforeHandEnv_URL,@"/device/app/unlashRobot"];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];

}
/**查询机器通话记录*/
+(void)requestFetchSNCallRecordsWithSN:(NSString*)sn Page:(NSInteger)page PageNumber:(NSInteger)pageNumber AndAndFinish:(void(^)(BKSNCallRecordsModel* model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@/device/app/fetchCallRecords/%@/%ld/%ld",BeforeHandEnv_URL,sn,(long)page,pageNumber];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Get tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        NSLog(@"%@",responseObj);
        return completionHandler([BKSNCallRecordsModel mj_objectWithKeyValues:responseObj],error);
    }];
}

/**app主叫新增通话记录*/
+(void)requestAddNewCallRecordsWithSN:(NSString*)sn AndiPhoneNumber:(NSString*)phone AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@/device/app/addCallRecords",BeforeHandEnv_URL];
    NSDictionary *parameters = @{@"sn":sn,
                                 @"phone":phone
                                 };
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**app更新通话记录状态*/
+(void)requestUpdateCallRecordsWithID:(NSInteger)recordId andState:(NSInteger)state AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@/device/app/updateCallRecords",BeforeHandEnv_URL];
    NSDictionary *parameters = @{@"id":@(recordId),
                                 @"state":@(state)
                                 };
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:parameters isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];
}

/**查询通讯录接口*/
+(void)requestFetchContactsListWithSN:(NSString*)sn AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@/device/app/fetchContactsList/%@",BeforeHandEnv_URL,sn];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Get tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        return completionHandler(responseObj,error);
    }];

}

/**查询会员信息*/
+(void)memberFetchUserInfoFinish:(void(^)(MemberModel* model,NSError *error))completionHandler{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",BeforeHandEnv_URL,@"/user/member/fetchUserInfo"];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Get tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
//        NSLog(@"memberFetch===>%@",responseObj);
        return completionHandler([MemberModel mj_objectWithKeyValues:responseObj],error);
    }];
    
}

/*扫码激活*/
+(void)memberActivateMemberWithActivationCode:(NSString*)activationCode Finish:(void(^)(MemberModel* model,NSError *error))completionHandler{
    
    NSDictionary *params = @{@"activationCode":activationCode};
    NSString *path = [NSString stringWithFormat:@"%@%@",BeforeHandEnv_URL,@"/user/member/activateMember"];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Post tokenFlag:tokenFlagAuthorization Path:path parameters:params isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        NSLog(@"memberActivate===>%@",responseObj);
        return completionHandler([MemberModel mj_objectWithKeyValues:responseObj],error);
    }];
    
    
}

/**手机端本地识别接口*/
+(void)requestAR_BookDownDataWithFeatureId:(NSString*)featureId AndAndFinish:(void(^)(ARBookDownModel * model,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@%@",BeforeHandEnv_URL,@"/book/v2/ar/page/",featureId];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Get tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        NSLog(@"AR_down-%@",responseObj);
        return completionHandler([ARBookDownModel mj_objectWithKeyValues:responseObj],error);
    }];
}

+(void)requestAR_BookAudioWith:(NSString*)bookId PageNumber:(NSString*)pageNumber AndAndFinish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@%@/%@/%@",BeforeHandEnv_URL,@"/book/v2/ar/audios",bookId,pageNumber];
    [self RequestNetAndIsJSONParameter:YES With:BKRequestType_Get tokenFlag:tokenFlagAuthorization Path:path parameters:nil isCache:NO withTime:0 progress:nil completionHandler:^(id responseObj, NSError *error) {
        NSLog(@"AR_audio-%@",responseObj);
        return completionHandler(responseObj,error);
    }];
}

/**上报阅读数据*/
+(void)eventReportBookWithList:(NSArray*)reportList Finish:(void(^)(id responseObj,NSError *error))completionHandler;{
    
    NSString *path = [NSString stringWithFormat:@"%@/tj/event/report/book",BeforeHandEnv_URL];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSArray *parames = reportList;
    NSLog(@"path===>%@",path);
//    NSLog(@"parames===>%@",parames);
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:parames error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSessionDataTask* task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
         return completionHandler(responseObject,error);
    }];
    [task resume];
}

/**会员购买*/
+(void)wxOrderWithDic:(NSDictionary*)dic Finish:(void(^)(id responseObj,NSError *error))completionHandler{
    NSString *path = [NSString stringWithFormat:@"%@/pay/wx/order",BeforeHandEnv_URL];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSLog(@"path===>%@",path);
    //    NSLog(@"parames===>%@",parames);
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:path parameters:dic error:nil];
    request.timeoutInterval = 10.f;
    [request setValue:APP_DELEGATE.mLoginResult.token forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSessionDataTask* task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        return completionHandler(responseObject,error);
    }];
    [task resume];
}
@end
