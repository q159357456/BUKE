//
//  NSString+DES.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//
#import "NSString+DES.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+DataToHexString.h"

@implementation NSString (DES)

+(NSString *)des:(NSString *)str key:(NSString *)key{
    NSString *ciphertext = nil;
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        NSLog(@"data = %@",data);
        ciphertext = [data dataToHexString];
        NSLog(@"ciphertext = %@",ciphertext);
    }
    return ciphertext;
}


//解密
+(NSString *)decryptDes:(NSString*)hexString key:(NSString*)key{
    NSData *data = [self hexStringToData:hexString];
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding|kCCOptionECBMode, keyPtr, kCCBlockSizeDES, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesEncrypted);
    if(cryptStatus == kCCSuccess){
        NSString *string = [[NSString alloc]initWithData:[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted] encoding:NSUTF8StringEncoding];
        NSLog(@"string = %@",string);
        return string;
    }
    free(buffer);
    return nil;
}

+(NSData *)hexStringToData:(NSString *)hexString{
    const char *chars = [hexString UTF8String];
    int i = 0;
    int len = (int)hexString.length;
    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i<len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

@end

