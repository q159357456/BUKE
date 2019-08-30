//
//  EnglishDownCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "EnglishDownCell.h"
#import "EnglishDownCollectionCell.h"
#import "EnglishSeriesService.h"
#import "English_Header.h"
#import "TeachingClassifyVC.h"
//static CGFloat size_w= 0;
//static CGFloat size_height
#define JianGe SCALE(5)
#define size_w (SCREEN_WIDTH - JianGe*3 -SCALE(18))/3.00
#define size_height size_w * 140.00 / 105.00 + 36.00
@interface EnglishDownCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end

@implementation EnglishDownCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionview registerNib:[UINib nibWithNibName:@"EnglishDownCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"EnglishDownCollectionCell"];
    self.collectionview.delegate =self;
    self.collectionview.dataSource =self;
    self.collectionview.scrollEnabled =NO;
    self.title_Lead_Constraints.constant = SCALE(15);
    // Initialization code
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.seriesList_Classify.xbkSeriesBookDtoList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EnglishDownCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EnglishDownCollectionCell" forIndexPath:indexPath];
    Series *model = self.seriesList_Classify.xbkSeriesBookDtoList[indexPath.item];
    cell.series = model;
    cell.imageview.layer.mask = [self get_maskLayerWithBounds:CGRectMake(0, 0, size_w - 11, size_w * 140.00 / 105.00 -SCALE(5) )];
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Series *model = self.seriesList_Classify.xbkSeriesBookDtoList[indexPath.item];
    [self eventName:EnglishDownCell_Event Params:model];
}

-(void)setTitleLabel:(UILabel *)titleLabel
{
    _titleLabel = titleLabel;
    _titleLabel.font = [UIFont boldSystemFontOfSize:SCALE(18)];
}
-(void)setMoreLael:(UILabel *)moreLael
{
    _moreLael = moreLael;
    _moreLael.font = [UIFont systemFontOfSize:SCALE(12) weight:UIFontWeightMedium];
    _moreLael = moreLael;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(more:)];
    _moreLael.userInteractionEnabled = YES;
    [_moreLael addGestureRecognizer:tap];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    return CGSizeMake(size_w, size_height);
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
-(void)setSeriesList_Classify:(SeriesList_Classify *)seriesList_Classify
{
    _seriesList_Classify = seriesList_Classify;
    if (![seriesList_Classify.hasMore intValue]) {
        self.moreLael.hidden = YES;
    }else
    {
        self.moreLael.hidden = NO;
    }
    [self.collectionview reloadData];

}
-(void)setFrame:(CGRect)frame
{
    frame.origin.y += SCALE(5);
    [super setFrame:frame];
}

#pragma mark - public
+(CGFloat)EnglishDownCellRowHeight:(SeriesList_Classify*)model
{
    CGFloat h =59;
    NSInteger line = ceilf(model.xbkSeriesBookDtoList.count   / 3.00);
    CGFloat temp = size_height;
    h = h + line * temp  + (line - 1) * 10 +20;
    return h;
}
-(CAShapeLayer*)get_maskLayerWithBounds:(CGRect)rect{
    
   UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = rect;
    maskLayer.path = path.CGPath;
    return maskLayer;
    
}
#pragma mark - action
-(void)more:(UITapGestureRecognizer*)tap{
    
    TeachingClassifyVC *vc= [[TeachingClassifyVC alloc]init];
    vc.teachingid = @"0";
    vc.title_text = @"全部";
    vc.ageid = self.seriesList_Classify.ageId;
    vc.ageContent = self.seriesList_Classify.seriesName;;
    [EnglishSettingManager shareInstance].backToWhatPage = BACK_TO_FIST_PAGE;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}
@end
