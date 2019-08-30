//
//  BKHomeJingDuTableViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomeJingDuTableViewCell.h"
#import "BKJingDuCollectionViewCell.h"
#import "BKHomeListModel.h"

@interface BKHomeJingDuTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) themeData *data;

@end

@implementation BKHomeJingDuTableViewCell
- (void)setModelWith:(themeData*)data{
    self.data = data;
    self.myCollectionView.contentOffset = CGPointZero;
    [self.myCollectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    return 141+6+20;
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self initCollectionView];
}

- (void)initCollectionView{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 10;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 6,SCREEN_WIDTH,141) collectionViewLayout:layout];
    self.myCollectionView.scrollEnabled = YES;
    
    [self.contentView addSubview:self.myCollectionView];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    //4.设置代理
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delaysContentTouches = false;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
//    self.myCollectionView.pagingEnabled = YES;
//    self.myCollectionView.decelerationRate = 0.5;
    [self regiestCollectionViewCell];
    
}

- (void)regiestCollectionViewCell{
    
    NSString * cellName = NSStringFromClass([BKJingDuCollectionViewCell class]);
    UINib * nibCell = [UINib nibWithNibName:cellName bundle:nil];
    [self.myCollectionView registerNib:nibCell forCellWithReuseIdentifier:cellName];
    
}

#pragma mark - collectionViewDelegate&DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.data.xbkThemeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BKJingDuCollectionViewCell *cell = [BKJingDuCollectionViewCell BKJingDuCollectionCellWithCollectionView:collectionView andIndexPath:indexPath];
    [cell setModelWith:self.data.xbkThemeList[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    themeDataModel *model = self.data.xbkThemeList[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKHomeJingDuClickWith:)]) {
        [self.delegate BKHomeJingDuClickWith:model.bookId];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(308.f, 141.f);
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(15, 141);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(15, 141);
}


#pragma -mark scrollviewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
//    NSLog(@"scrollViewWillBeginDragging");
//    NSLog(@"%f",scrollView.contentOffset.x);
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"scrollViewWillBeginDecelerating");
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    float pageWidth = 308.f+15-10;
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    if (targetOffset >= currentOffset){
//        newTargetOffset = roundf(currentOffset / pageWidth) * pageWidth;
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    }else{
//        newTargetOffset = roundf(currentOffset / pageWidth) * pageWidth;
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    }
    if (newTargetOffset < 0){
        newTargetOffset = 0;
    }else if (newTargetOffset > scrollView.contentSize.width-SCREEN_WIDTH){
        newTargetOffset = scrollView.contentSize.width-SCREEN_WIDTH;
    }
    targetContentOffset->x = currentOffset;

    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
}

@end
