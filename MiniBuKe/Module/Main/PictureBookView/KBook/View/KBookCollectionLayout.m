//
//  KBookCollectionLayout.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookCollectionLayout.h"


#define ActiveDistance  500 //400
#define ScaleFactor     0.5
#define ItemWidth       250
#define ItemHeight      200
#define LineSpacing     10


@interface KBookCollectionLayout()
{
   
}


@end

@implementation KBookCollectionLayout


-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.itemSize = CGSizeMake(ItemWidth, ItemHeight);
        self.minimumLineSpacing = LineSpacing;
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;//速率
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }
    
    return self;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offSetAdjustment = MAXFLOAT;

    //预期停止水平中心点
    CGFloat horizotalCenter = proposedContentOffset.x + self.collectionView.bounds.size.width / 2;

    //预期滚动停止时的屏幕区域
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);

    //找出最接近中心点的item
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes * attributes in array) {
        CGFloat currentCenterX = attributes.center.x;
        if (ABS(currentCenterX - horizotalCenter) < ABS(offSetAdjustment)) {
            offSetAdjustment = currentCenterX - horizotalCenter;
        }
    }
    //
    return CGPointMake(proposedContentOffset.x + offSetAdjustment, proposedContentOffset.y);
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *original = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:original copyItems:YES];
    CGRect visRect;
    visRect.origin = self.collectionView.contentOffset;
    visRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *layoutAttribute in array) {
        
        //判断相交
        if (CGRectIntersectsRect(visRect, rect)) {
            CGFloat distance = CGRectGetMidX(visRect) - layoutAttribute.center.x;
            CGFloat norDistance = fabs(distance/ActiveDistance);
            CGFloat zoom = 1 - ScaleFactor * norDistance;
            layoutAttribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
            layoutAttribute.zIndex = 1;
        }
    }
    
    return array;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


@end
