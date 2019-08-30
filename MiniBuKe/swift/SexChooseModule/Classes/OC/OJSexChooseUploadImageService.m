//
//  UploadImageService.m
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/9/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "OJSexChooseUploadImageService.h"
#import "FileUploadService.h"

@interface OJSexChooseUploadImageService()

@end

@implementation OJSexChooseUploadImageService

-(void) uploadImage:(UIImage *) image
{
    
    NSString *filePath = [self saveImage:image];
    
    if (filePath != nil || filePath.length > 0) {
        [self runUploadImageService:filePath];
    }
}

-(void)runUploadImageService:(NSString *)path
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        FileUploadService *fileService = (FileUploadService *)httpInterface;
        NSString *contentUrl = fileService.ossUrl;
        
        NSLog(@"===> sex choose upload image seucces <=== %@",contentUrl);
        [NSNotificationCenter.defaultCenter postNotificationName:@"upbabyinfo_suceced" object:contentUrl];
//        NSInteger time = [self getAudioDurationByUrl:contentUrl];
//        NSInteger durationTime = time*1000;//单位:ms
//        //发送消息
//        [weakSelf sendMessageWithUrl:contentUrl messageType:MessageTypeVoice durationTime:durationTime];
    };
    
    void (^OnError) (NSInteger ,NSString *) = ^(NSInteger httpInterface, NSString *description){
        NSLog(@"===> sex choose upload image error <===");
        [NSNotificationCenter.defaultCenter postNotificationName:@"upbabyinfo_fail" object:@"失败"];
    };
    
    FileUploadService *fileService = [[FileUploadService alloc]initWithPath:path setOnSuccess:OnSuccess setOnError:OnError];
    [fileService start];
}

//保存图片到沙盒
- (NSString *)saveImage:(UIImage *)targetImage
{
    NSString * resPath = @"";
    //压缩图片 大小<1M
    UIImage *image = [self imageByScalingAndCroppingForSize:CGSizeMake(124*3, 124*3) withSourceImage:targetImage];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *avatar = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/avatar"]];
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
        resPath = filePath;
    }
    return resPath;
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

@end
