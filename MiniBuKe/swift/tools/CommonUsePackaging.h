//
//  CommonUsePackaging.h
//  MiniBuKe
//
//  Created by chenheng on 2018/10/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XG_NoticeModel.h"



@interface CommonUsePackaging : NSObject
@property(nonatomic,copy)void(^hadChosenPhoto)(UIImage *);
@property(nonatomic,copy) NSString *filePath;
@property(nonatomic,strong)UIImage *chosenImage;
@property(nonatomic,assign)BOOL isHadNoticeRemind;
@property(nonatomic,assign)BOOL isMessageListNoticeRemind;
@property(nonatomic,assign)BOOL isShuoShuoListNoticeRemind;
@property(nonatomic,strong)XG_NoticeModel *xingeModel;
@property(nonatomic,strong)NSArray *emojiArray;


//单例
+(instancetype)shareInstance;
//调用相册或拍照
-(void)usePhotoLibOrPhotograph:(void(^)(UIImage *))hadChosen;
//获取当前控制器
- (UIViewController *)getCurrentVC;
//删除文件
-(void)deletePath:(NSString *)path;
//当前时间
-(NSString *)getCurrentTime:(NSString*)formatter;
//转化时间
+(NSString *)Time_format:(NSString *)time;
//富文本
+(NSMutableAttributedString*)getAttributes:(NSString*)str Color:(UIColor*)color;
//获得加密后的Url
+(NSString*)getEncryptionSin;
+(void)showSystemHint:(NSString*)hit;

/**获取当前时间戳*/
+(NSString*)getNowTimeTimestamp;
/**生成三位随机数*/
+(NSString*)getRandomNumber;
/**Url加签名 传参数dic 通用加密*/
+(NSString*)getEncryptionSinWithDic:(NSDictionary*)dic;
//清除H5缓存
+(void)deletWebCache;
//字符串转NSDate
+(NSDate*)strToDate:(NSString*)str;
//喜马拉雅sign生成
+(void)XMLY_Sgin;
//AES解密
-(NSString *)decryptStringWithString:(NSString *)string andKey:(NSString *)key;
//base64
+(NSString*)Base64:(NSString*)str;
@end


