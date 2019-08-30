//
//  myPhotoCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/11/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKPhotoImage.h"

@interface myPhotoCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView *photoView;

@property(nonatomic, assign)BOOL chooseStatus;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, assign) CGFloat progressFloat;

@property (nonatomic, strong) UIImageView *signImage;

@end
