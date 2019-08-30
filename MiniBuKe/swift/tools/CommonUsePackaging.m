//
//  CommonUsePackaging.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "CommonUsePackaging.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "NSMutableDictionary+Order.h"
#import <CommonCrypto/CommonDigest.h>
#import <WebKit/WebKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "EmojiObject.h"
@interface CommonUsePackaging()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end
@implementation CommonUsePackaging
//单例
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static CommonUsePackaging *packing =nil;
    dispatch_once(&onceToken, ^{
        packing = [[CommonUsePackaging alloc]init];
    });
    return packing;
}
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

//调用相册或拍照
-(void)usePhotoLibOrPhotograph:(void(^)(UIImage *image))hadChosen
{
    self.hadChosenPhoto = hadChosen;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf checkVideoStatusWith:imagePickerController];
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf checkPhotoStautsWith:imagePickerController];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertVC addAction:cameraAction];
    }
    
    [alertVC addAction:photoAction];
    [alertVC addAction:cancelAction];
    
    [[self getCurrentVC] presentViewController:alertVC animated:YES completion:nil];

}
-(void)checkVideoStatusWith:(UIImagePickerController *)imagePickerController
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        //没有授权
        [self alertCamera];
    }else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[self getCurrentVC] presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)checkPhotoStautsWith:(UIImagePickerController *)imagePickerController
{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusRestricted || photoAuthorStatus == PHAuthorizationStatusDenied) {
        //没有授权
        [self alertPhoto];
    }else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[self getCurrentVC] presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void) alertCamera
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请为小布壳开启相机权限: 请进入手机【设置】>【隐私】>【相机】>小布壳(打开)" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tipAlert addAction:cancelAction];
    [[self getCurrentVC] presentViewController:tipAlert animated:YES completion:nil];
}

-(void)alertPhoto
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:nil message:@"请在iPhone的""设置-隐私-照片""选项中,允许访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tipAlert addAction:cancelAction];
    [[self getCurrentVC] presentViewController:tipAlert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage; // 原始图片
     * UIImagePickerControllerEditedImage; // 裁剪后图片
     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL; // 媒体的URL
     * UIImagePickerControllerReferenceURL // 原件的URL
     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
     */
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //压缩图片 大小<1M
    UIImage *targetImage = [self imageByScalingAndCroppingForSize:CGSizeMake(124*3, 124*3) withSourceImage:image];
    self.chosenImage = targetImage;
    if (self.hadChosenPhoto) {
         self.hadChosenPhoto(targetImage);
    }
   
    //保存到沙盒
//    [self saveImage:targetImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//压缩图片
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth/ width;
        CGFloat heightFactor = targetHeight/height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else{
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
        
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"image error");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 沙盒相关操作
- (void)saveImage:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *avatar = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/BabyAvatar"]];
    if (![self isFileExit:avatar]) {
        [self createPath:avatar];
    }
    NSLog(@"avatar--->path:%@",avatar);
    NSString *timeStr = [self getCurrentTime:@"YYYYMMddHHmmss"];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",avatar,timeStr];
    // 保存成功会返回YES
    BOOL result = [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
    if (result == YES) {
        NSLog(@"头像保存成功");
        self.filePath = filePath;
    }
}

-(void)deletePath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isHave = [self isFileExit:path];
    if (!isHave) {
        return;
    }else {
        BOOL dele = [fileManager removeItemAtPath:path error:nil];
        if (dele) {
            NSLog(@"删除照片成功");
        }else{
            NSLog(@"删除照片失败");
        }
    }
}

-(NSString *)getCurrentTime:(NSString*)formatter
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}
//检测文件是否存在
-(BOOL)isFileExit:(NSString*)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
-(void)createPath:(NSString*)path
{
    if (![self isFileExit:path]) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * parentPath = [path stringByDeletingLastPathComponent];
        if ([self isFileExit:parentPath]) {
            NSError * error;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:path attributes:nil error:&error];
        }else{
            [self createPath:parentPath];
            [self createPath:path];
        }
    }
}

//转化时间
+(NSString *)Time_format:(NSString *)time
{
    NSInteger seconds = [time intValue];
    if (seconds <60) {
        if (seconds ==0) {
           return @"00分钟";
        }else
        {
           return @"01分钟";
        }
        
    }else if (seconds>=60 && seconds< 3600)
    {
        NSInteger miniutes = ceilf(seconds / 60.00);
       
        return [NSString stringWithFormat:@"%02ld分钟",(long)miniutes];
    }else if(seconds>=3600&&seconds<3600*24)
    {
        
        NSInteger hours = seconds/3600;
        NSInteger minites = (seconds % 3600)/60;
      
        return [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hours,(long)minites];
    }else if(seconds>=3600*24 && seconds<3600*24*99)
    {
        
        NSInteger day = seconds/(3600*24);
        NSInteger hour = seconds%(3600*24)/3600;
        return [NSString stringWithFormat:@"%ld天%ld小时",(long)day,(long)hour];
        
    }else
    {
        NSInteger perday = 3600*24;
        NSInteger day = seconds/perday;
        return [NSString stringWithFormat:@"%ld天",(long)day];
    }
        
    
    
}

+(void)showSystemHint:(NSString *)hit
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"提示" message:hit preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tipAlert addAction:cancelAction];
    UIViewController *vc = [[CommonUsePackaging shareInstance] getCurrentVC];
    [vc presentViewController:tipAlert animated:YES completion:nil];
}

//富文本
+(NSMutableAttributedString*)getAttributes:(NSString*)str Color:(UIColor*)color;
{
    NSMutableAttributedString *attribute  = [[NSMutableAttributedString  alloc]initWithString:str attributes:nil];
    NSString *temp;
    for (int i =0; i<str.length; i++) {
        NSRange range = NSMakeRange(i, 1);
         temp =[str substringWithRange:range];
         if ([temp isEqualToString:@"0"]|| [temp isEqualToString:@"1"]||[temp isEqualToString:@"2"]||[temp isEqualToString:@"3"]||[temp isEqualToString:@"4"]||[temp isEqualToString:@"5"]||[temp isEqualToString:@"6"]||[temp isEqualToString:@"7"]||[temp isEqualToString:@"8"]||[temp isEqualToString:@"9"]){
            [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:40],NSFontAttributeName, nil] range:range];
        }
            
            
      
    }
    
    return attribute;
}

//获得加密后的Url
+(NSString*)getEncryptionSin
{
    NSMutableDictionary *dic = [CommonUsePackaging getFixedParamsDic];
    NSMutableString * dataStr = [NSMutableString string];
    //拼接(key)
    BOOL first = YES;
    for (NSString *key in dic.orderArray) {
       
        if (first) {
           [dataStr appendString:[NSString stringWithFormat:@"%@=%@",key,dic[key]]];
            first = NO;
        }else
        {
           [dataStr appendString:[NSString stringWithFormat:@"&%@=%@",key,dic[key]]];
        }
    }

    //获得MD5加密后的sig
    const char *cStr =[dataStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *md5Str_new=[NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ];
    NSLog(@"md5Str_new===>%@",[md5Str_new uppercaseString]);
    return[md5Str_new uppercaseString];
}

+(NSMutableDictionary*)getFixedParamsDic{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //随机数
    int s =  (int)(100 + (arc4random() % (999 - 100 + 1)));
    NSString * randomString = [NSString stringWithFormat:@"%d", s];
    //时间戳
    NSString * timeStamp = [CommonUsePackaging getNowTimeTimestamp];

    //appkey
    NSString *appkey = @"appKey_xbk";
    //appsecret
    NSString *appSecret = @"appsecret_xbk";
    [dic orderSetObject:appkey forKey:@"appKey"];
    [dic orderSetObject:randomString forKey:@"random"];
    [dic orderSetObject:timeStamp forKey:@"timestamp"];
    [dic orderSetObject:appSecret forKey:@"key"];
    return dic;
}

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
   
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}
//生成三位随机数
+(NSString*)getRandomNumber{
    //随机数
    int s =  (int)(100 + (arc4random() % (999 - 100 + 1)));
    NSString * randomString = [NSString stringWithFormat:@"%d",s];
    return randomString;
}
/**获取加密后的Url 传参数dic*/
+(NSString*)getEncryptionSinWithDic:(NSDictionary*)dic{
    //key排序
    NSArray *keyArray = [dic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[dic objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    NSInteger lastKeyIndex = 0;
    for (int i = 0; i < sortArray.count; i++) {
        if ([sortArray[i] isEqualToString:signappKey_Key]) {
            lastKeyIndex = i;
            continue;
        }
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    NSString *singMD5 = [sign stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",sortArray[lastKeyIndex],valueArray[lastKeyIndex]]];
    //获得MD5加密后的sig
    const char *cStr =[singMD5 UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *md5Str_new=[NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15]
                          ];
//    NSLog(@"md5Str_new===>%@",[md5Str_new uppercaseString]);
    
    return [NSString stringWithFormat:@"%@&sign=%@",sign,[md5Str_new uppercaseString]];
}
+(void)deletWebCache
{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}
//表情数据
-(NSArray *)emojiArray
{
    if (!_emojiArray) {
        NSString *baseUrl = @"https://xiaobuke.oss-cn-beijing.aliyuncs.com/file/";
        
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            EmojiObject *object = [[EmojiObject alloc] init];
            object.imageUrl = [NSString stringWithFormat:@"emoji_0%d",i+1];
            switch (i) {
                case 0:
                    object.voiceUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"read_kidbook.mp3"];
                    break;
                case 1:
                    object.voiceUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"do_not_watch_tv.mp3"];
                    break;
                case 2:
                    object.voiceUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"do_not_watch_phone.mp3"];
                    break;
                case 3:
                    object.voiceUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"have_a_meal.mp3"];
                    break;
                case 4:
                    object.voiceUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"wash.mp3"];
                    break;
                case 5:
                    object.voiceUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"brush_ones_teeth.mp3"];
                    break;
                case 6:
                    object.voiceUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"sleep.mp3"];
                    break;
                case 7:
                    object.voiceUrl = [NSString stringWithFormat:@"%@%@",baseUrl,@"drink_more_water.mp3"];
                    break;
                default:
                    break;
            }
            
            [mutableArray addObject:object];
        }
        
        _emojiArray = [NSArray arrayWithArray:mutableArray];
    }
    
    return _emojiArray;
}
+(NSDate*)strToDate:(NSString*)str{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [format dateFromString:str];
    return date;
}

+(void)XMLY_Sgin
{
    
}
- (NSString *)decryptStringWithString:(NSString *)string andKey:(NSString *)key

{
    
    NSMutableData *data = [NSMutableData dataWithCapacity:string.length/2.0];
    
    unsigned char whole_bytes;
    
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    
    for(i = 0 ; i < [string length]/2 ; i++)
        
    {
        
        byte_chars[0] = [string characterAtIndex:i * 2];
        
        byte_chars[1] = [string characterAtIndex:i * 2 + 1];
        
        whole_bytes = strtol(byte_chars, NULL, 16);
        
        [data appendBytes:&whole_bytes length:1];
        
    }
    
    NSData *result = [self decryptDataWithData:data andKey:key];
    
    if(result && result.length > 0)
        
    {
        
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
    }
    
    return nil;
    
}
- (NSData *)decryptDataWithData:(NSData *)data andKey:(NSString *)key

{
    
    char keyPtr[kCCKeySizeAES128 + 1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    
    if(cryptStatus == kCCSuccess)
        
    {
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
    }
    
    free(buffer);
    
    return nil;
    
}

//base64
+(NSString*)Base64:(NSString*)str{
    
    //1、先转换成二进制数据
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
    
}
@end
