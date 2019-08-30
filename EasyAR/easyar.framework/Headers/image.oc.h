//=============================================================================================================================
//
// EasyAR 3.0.0-final-r47287f89
// Copyright (c) 2015-2019 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_Image : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (easyar_Buffer *)buffer;
- (easyar_PixelFormat)format;
- (int)width;
- (int)height;
- (bool)empty;
- (void)setTimeStamp:(double)time;
+ (easyar_Image *)create:(easyar_Buffer *)buffer format:(easyar_PixelFormat)format width:(int)width height:(int)height;

@end
