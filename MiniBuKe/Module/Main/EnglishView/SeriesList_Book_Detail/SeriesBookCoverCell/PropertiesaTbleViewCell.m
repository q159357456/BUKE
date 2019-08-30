//
//  PropertiesaTbleViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "PropertiesaTbleViewCell.h"
#import "EnglishDownCollectionCell.h"
#import "English_Header.h"
@interface PropertiesaTbleViewCell()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end
@implementation PropertiesaTbleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionview registerNib:[UINib nibWithNibName:@"EnglishDownCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"EnglishDownCollectionCell"];
    self.collectionview.delegate =self;
    self.collectionview.dataSource =self;
    self.collectionview.scrollEnabled =NO;
    
    // Initialization code
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.property_list.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EnglishDownCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EnglishDownCollectionCell" forIndexPath:indexPath];
    
    TeachingProperties *model = self.property_list[indexPath.row];
    cell.teachingProperties = model;
    cell.imageview.layer.mask = [self get_maskLayerWithBounds:CGRectMake(0, 0, size_w - 11, size_w * 140.00 / 105.00 -SCALE(5))];
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    TeachingProperties *model = self.property_list[indexPath.item];
    [self eventName:PropertiesaTbleViewCell_Event Params:model];

}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    return CGSizeMake(size_w, Property_Size_Height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, SCALE(18), 10, JianGe);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
     return SCALE(15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return JianGe;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setProperty_list:(NSArray *)property_list
{
    _property_list = property_list;
    [self.collectionview reloadData];
}

-(CAShapeLayer*)get_maskLayerWithBounds:(CGRect)rect{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = rect;
    maskLayer.path = path.CGPath;
    return maskLayer;
    
}

@end
