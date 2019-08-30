//
//  UploadImageService.h
//  OJSexChooseComponent
//
//  Created by chenheng on 2018/9/10.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpFormDataInterface.h"

@interface OJSexChooseUploadImageService : NSObject

-(void) uploadImage:(UIImage *) image;

- (NSString *)saveImage:(UIImage *)targetImage;

-(void)runUploadImageService:(NSString *)path;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;
@end
