//
//  JDOSSUploadfileHandle.m
//  MiniBuKe
//
//  Created by chenheng on 2019/8/2.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "JDOSSUploadfileHandle.h"
#import <AWSCore.h>
#import <AWSS3.h>
#import "CommonUsePackaging.h"
#define JD_OSS_ENDPOINT @"http://s3.cn-south-1.jdcloud-oss.com" //外网
#define JD_BUKEET @"http://xbk-mobiles.s3.cn-south-1.jdcloud-oss.com" //外网
//#define JD_OSS_ENDPOINT @"xbk-robot.s3.cn-south-1.jdcloud-oss.com" //内网
//#define JD_BUKEET @"xbk-mobiles.s3-internal.cn-south-1.jdcloud-oss.com" //内网
#define JD_OSS_Key @"65185BF18757C32A97CBF39821292F66"
#define JD_OSS_Secret @"EF6307E9F1D553C0E8B4F587700CFFFE"
@implementation JDOSSUploadfileHandle
+(void)JD_OSS_Initialize
{
    [AWSDDLog addLogger:AWSDDTTYLogger.sharedInstance];
    AWSDDLog.sharedInstance.logLevel = AWSDDLogLevelInfo;
    
    AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:JD_OSS_Key secretKey:JD_OSS_Secret];
    AWSEndpoint *endPoint = [[AWSEndpoint alloc] initWithURLString:JD_OSS_ENDPOINT];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionAPSouth1
                                                                                    endpoint:endPoint
                                                                         credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
}
+(void)uploadFile:(NSString *)path Callback:(void (^)(NSString * _Nonnull))callback
{
    
    NSDate * current = [NSDate date];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    NSString * temp = [fomatter stringFromDate:current];
    NSTimeInterval second = [current timeIntervalSince1970];
    NSString * targetKey = [NSString stringWithFormat:@"ugc/%@/msg_voice/%@/%.0f.mp3",APP_DELEGATE.mLoginResult.userId,temp,second*1000];
    NSLog(@"targetKey==>%@",targetKey);

    NSString *filePath = path;
    NSString *fileName = filePath.lastPathComponent;
    NSString *contentType;
    if ([fileName.pathExtension.lowercaseString isEqualToString:@"pdf"]) {
        contentType = @"application/pdf";
    } else if ([fileName.pathExtension.lowercaseString isEqualToString:@"txt"]) {
        contentType = @"text/plain";
    }else if ([fileName.pathExtension.lowercaseString isEqualToString:@"mp3"]) {
        
        contentType = @"audio/mp3";
    }
    else {
        // demo中仅三种文件，若需要上传其他文件需配置相应的contentType，参见: http://tool.oschina.net/commons
        contentType = @"application/octet-stream";
    }

    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = targetKey;
    uploadRequest.bucket = @"xbk-mobiles";
    uploadRequest.contentType = contentType;
    
    uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat progress = totalBytesSent * 1.0 / totalBytesExpectedToSend;
            NSLog(@"progress==>%.2f",progress);
        });
    };
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(@"");
            });
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        NSLog(@"1--Upload Paused: [%@]", task.error);
                        break;
                        
                    default:
                        NSLog(@"2--Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                NSLog(@"3--Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 //上传成功
                NSString * adress = [NSString stringWithFormat:@"%@/%@",JD_BUKEET,targetKey];
                callback(adress);
            });
        }
        
        return nil;
    }];
    
}


+(void)uploadKbookFile:(NSString *)path Callback:(void (^)(NSString * _Nonnull))callback{
    NSDate * current = [NSDate date];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc]init];
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    NSString * temp = [fomatter stringFromDate:current];
    NSTimeInterval second = [current timeIntervalSince1970];
    NSString * targetKey = [NSString stringWithFormat:@"ugc/%@/kbook/%@/%.0f.mp3",APP_DELEGATE.mLoginResult.userId,temp,second*1000];
    NSLog(@"targetKey==>%@",targetKey);
    
    NSString *filePath = path;
    NSString *fileName = filePath.lastPathComponent;
    NSString *contentType;
    if ([fileName.pathExtension.lowercaseString isEqualToString:@"pdf"]) {
        contentType = @"application/pdf";
    } else if ([fileName.pathExtension.lowercaseString isEqualToString:@"txt"]) {
        contentType = @"text/plain";
    }else if ([fileName.pathExtension.lowercaseString isEqualToString:@"mp3"]) {
        
        contentType = @"audio/mp3";
    }
    else {
        // demo中仅三种文件，若需要上传其他文件需配置相应的contentType，参见: http://tool.oschina.net/commons
        contentType = @"application/octet-stream";
    }
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    uploadRequest.key = targetKey;
    uploadRequest.bucket = @"xbk-mobiles";
    uploadRequest.contentType = contentType;
    
    uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat progress = totalBytesSent * 1.0 / totalBytesExpectedToSend;
            NSLog(@"progress==>%.2f",progress);
        });
    };
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(@"");
            });
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                        NSLog(@"1--Upload Paused: [%@]", task.error);
                        break;
                        
                    default:
                        NSLog(@"2--Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                NSLog(@"3--Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //上传成功
                NSString * adress = [NSString stringWithFormat:@"%@/%@",JD_BUKEET,targetKey];
                callback(adress);
            });
        }
        
        return nil;
    }];
}
@end
