//
//  ARDownFlieManager.m
//  MiniBuKe
//
//  Created by Don on 2019/5/28.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "ARDownFlieManager.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "ZipArchive.h"

@interface ARDownFlieManager()

@property(nonatomic, strong) NSURLSessionDownloadTask * downloadTask;
@property(nonatomic, copy) NSString *documentsSavePath;
@property(nonatomic, copy) NSString *downCachesPath;
@property(nonatomic, copy) NSString *downBookPath;
/**是否正在下载*/
@property(nonatomic, assign) BOOL isDownNowing;

@property(nonatomic, strong) ARBookDownModel *model;

@end

@implementation ARDownFlieManager

+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static ARDownFlieManager *manager =nil;
    dispatch_once(&onceToken, ^{
        manager = [[ARDownFlieManager alloc]init];
        manager.documentsSavePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/ARBookDown"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:manager.documentsSavePath]){
            [[NSFileManager defaultManager] createDirectoryAtPath:manager.documentsSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return manager;
}

- (void)downFlieWithURLStr:(ARBookDownModel*)model Andprogress:(void(^)(NSProgress * _Nonnull downloadProgress))dowloadprogress AndFinish:(void(^)(NSString* path,NSString* bookId,BOOL success))completionHandler{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//    return completionHandler(NULL,model.data.bookId,NO);
        if (!model.data.dstUrl) return completionHandler(NULL,model.data.bookId,NO);
        self.model = model;
        NSURL *URL = [NSURL URLWithString:model.data.dstUrl];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForResource = 60*5;
        configuration.allowsCellularAccess = YES;
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            if(_isDownNowing){
                dowloadprogress(downloadProgress);
            }
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",model.data.bookId]];
            self.downCachesPath = path;
            return [NSURL fileURLWithPath:path];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error == nil) {
                NSLog(@"下载完成");
                self.downCachesPath = [filePath path];
                
            if ([self CheckDownZipMD5WithPath:self.downCachesPath AndMD5Str:model.data.dstMd5]) {
                
                NSLog(@"MD5验证成功");
                uint64_t size = [self sizeDiskSpaceInBytesWithPath:self.downCachesPath];
                while ([self checkTheDownfolderSizeIsFullWith:size]) {
                    [self removeFirstDownBookIfDiskFull];
                    NSLog(@"缓存大于300M,删除一个索引数据");
                }
                
                BOOL isUnZipSuessce = [self UnZipWithPath:self.downCachesPath];
                if (isUnZipSuessce) {
                    NSLog(@"解压成功");
                    completionHandler([NSString stringWithFormat:@"%@/datasets.json",self.downBookPath],model.data.bookId,YES);
                    [self updateTheBookIndexesWithBookID:model.data.bookId];
                    
                }else{
                    NSLog(@"解压失败");
                    completionHandler(NULL,model.data.bookId,NO);
                }
                
            }else{
                NSLog(@"MD5验证失败");
                completionHandler(NULL,model.data.bookId,NO);
            }
            
            }else{
                NSLog(@"下载失败%@",[filePath path]);
                completionHandler(NULL,model.data.bookId,NO);
            }
            
            self.isDownNowing = NO;
            //删除下载缓存目录
            if ([[NSFileManager defaultManager] fileExistsAtPath:self.downCachesPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:self.downCachesPath error:nil];
            }
            self.model = nil;
        }];
        
        [self StartDownFlie];
//    });
   
}

/**启动下载*/
- (void)StartDownFlie{
    self.isDownNowing = YES;
    [self.downloadTask resume];
}
/**取消下载*/
- (void)stopDownFlie{
    self.isDownNowing = NO;
    [self.downloadTask cancel];
}
/**挂起下载*/
- (void)pauseDownFlie{
    [self.downloadTask suspend];
}

- (NSURLSessionTaskState)checkDownFlieState{
    return [self.downloadTask state];
}

/**解压zip文件,储存到(/Documents/ARBookDown) */
- (BOOL)UnZipWithPath:(NSString*)path{
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.documentsSavePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:self.documentsSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:self.downCachesPath] ){
        
        self.downBookPath = [self.documentsSavePath stringByAppendingString:[NSString stringWithFormat:@"/%@",self.model.data.bookId]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.downBookPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:self.downBookPath error:nil];
        }
        
        BOOL ret = [zip UnzipFileTo:self.downBookPath overWrite:YES];
        [zip UnzipCloseFile];
        
        return ret;
    }
    return NO;
}

/**校验下载文件MD5*/
- (BOOL)CheckDownZipMD5WithPath:(NSString*)path AndMD5Str:(NSString*)md5Str{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return NO;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    //大写MD5
    NSString *last = [result uppercaseString];
    return [md5Str isEqualToString:last];
}

/**检查本地图书是否需要下载*/
- (BOOL)CheckTheBookIsNeedDown:(ARBookDownModel*)model{
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.documentsSavePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:self.documentsSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [self.documentsSavePath stringByAppendingString:[NSString stringWithFormat:@"/%@",model.data.bookId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //更新书本索引
        [self updateTheBookIndexesWithBookID:model.data.bookId];

        NSString *newPath1 = [path stringByAppendingString:@"/etd.json"];
        NSData *data1 = [[NSData alloc] initWithContentsOfFile:newPath1];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:data1
                                                             options:kNilOptions
                                                               error:nil];
        NSInteger updateTime = [[dic1 objectForKey:@"updateTime"] integerValue];
        if (model.data.dstUpdateTime > updateTime) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

/**获取本地图书路径*/
- (NSString*)GetTheBookSavePath:(ARBookDownModel*)model{
    NSString *path = [self.documentsSavePath stringByAppendingString:[NSString stringWithFormat:@"/%@",model.data.bookId]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [NSString stringWithFormat:@"%@/datasets.json",path];
    }else{
        return nil;
    }
}
/**判断可用空间是否小于200M*/
- (BOOL)checkTheDiskMerrorySizeIsLess{
    //200*1024*1024
    return [self freeDiskSpaceInBytes]<209715200 ? YES:NO;
}

/**判断下载目录缓存是否达到上限(上限300M)314572800*/
- (BOOL)checkTheDownfolderSizeIsFullWith:(uint64_t)zipSize{
    if(314572800 > ([self checkBookDownSize]+zipSize)){
        return NO;
    }else{
        return YES;
    }
}

/**更新or新增书本索引*/
- (void)updateTheBookIndexesWithBookID:(NSString*)bookID{
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.documentsSavePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:self.documentsSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path = [NSString stringWithFormat:@"%@/BookIndexes.json",self.documentsSavePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        NSArray *array = [NSArray arrayWithObject:bookID];
        NSDictionary *parameters = @{@"Booklist":[array mutableCopy]
                                     };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        [[NSFileManager defaultManager] createFileAtPath:path contents:jsonData attributes:nil];

    }else{
        
        NSArray *array = [self getTheArrayInBookIndexJsonWith:path];
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
        if ([newArray containsObject:bookID]) {
            [newArray removeObject:bookID];
        }
        [newArray addObject:bookID];
        
        [self saveTheArrayInBookIndexJsonWithArray:[newArray mutableCopy] andPath:path];
    }
}

/**删除索引的第一个书籍数据*/
- (void)removeFirstDownBookIfDiskFull{
    NSString *path = [NSString stringWithFormat:@"%@/BookIndexes.json",self.documentsSavePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSArray *array = [self getTheArrayInBookIndexJsonWith:path];
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
        NSString *bookID = newArray.firstObject;
        
        NSString *bookpath = [NSString stringWithFormat:@"%@/%@",self.documentsSavePath,bookID];
        if ([[NSFileManager defaultManager] fileExistsAtPath:bookpath]) {
            BOOL isRemove=[[NSFileManager defaultManager] removeItemAtPath:bookpath error:nil];
            if(isRemove){
                [newArray removeObject:bookID];
                [self saveTheArrayInBookIndexJsonWithArray:[newArray mutableCopy] andPath:path];
            }
        }
        
    }
    
}

/**清除所有下载本地图书*/
- (void)removeAllDownBook{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.documentsSavePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.documentsSavePath error:nil];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.documentsSavePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:self.documentsSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

//获取本地书本索引
- (NSArray*)getTheArrayInBookIndexJsonWith:(NSString*)path{
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions
                                                              error:nil];
        NSArray *array = [dic objectForKey:@"Booklist"];
        return array;
    }
    return nil;
}
//保存本地书本索引
- (BOOL)saveTheArrayInBookIndexJsonWithArray:(NSArray*)array andPath:(NSString*)path{
    NSLog(@"更新BookIndexes.json文件中bookid的位置");
    NSDictionary *parameters = @{@"Booklist":[array mutableCopy]
                                 };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    
    BOOL ret = [jsonData writeToFile:path atomically:YES];
    
    return ret;
}

//获取可用存储空间
- (uint64_t)freeDiskSpaceInBytes
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[ 0 ];
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath: path error: nil];
    NSLog(@"可用size:%@",dictionary[NSFileSystemFreeSize]);

    if(dictionary){
        return [dictionary[ NSFileSystemFreeSize ] unsignedLongLongValue];
    }else{
        return 0;
    }
}

#pragma mark - 获取文件or文件夹大小
//获取文件大小属性
- (uint64_t)sizeDiskSpaceInBytesWithPath:(NSString*)path{

    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath: path error: nil];
//    NSLog(@"文件size:%@",dictionary[NSFileSize]);
    if(dictionary){
        return [dictionary[ NSFileSize ] unsignedLongLongValue];
    }else{
        return 0;
    }
}

/**计算文件夹size*/
- (uint64_t)checkTheFlieSizeWithPath:(NSString*)path{
    NSArray *subArray = [[NSFileManager defaultManager] subpathsAtPath:path];
    uint64_t total = 0;
    for (NSString *name in subArray) {
        total += [self sizeDiskSpaceInBytesWithPath:[NSString stringWithFormat:@"%@/%@",path,name]];
    }
    return total;
}

- (uint64_t)checkBookDownSize{
    return [self checkTheFlieSizeWithPath:self.documentsSavePath];
}

/**取消当前下载*/
- (void)cancelDownBook{
    if(_isDownNowing){
        [self stopDownFlie];
    }
}

@end
