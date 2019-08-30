//
//  KBookCollectionView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/6/4.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookCollectionView.h"
#import "KBookCollectionLayout.h"

#define ITEM_WIDTH  200
#define ITEM_HEIGHT 150

@interface KBookCollectionView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,assign) NSInteger curIndex;
@property(nonatomic,strong) KBookCollectionLayout *layout;


@end


@implementation KBookCollectionView

-(instancetype)initWithFrame:(CGRect)frame
{
    self.layout = [[KBookCollectionLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithFrame:frame collectionViewLayout:self.layout];
    if (self) {
        [self initView];
    }
    
    return self;
}


-(void)initView
{
    _curIndex = 1;
    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = NO;
    
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

-(NSInteger)currentIndex
{
    return _curIndex;
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    NSString *imgString = self.imageArray[indexPath.row];
    [imgView sd_setImageWithURL:[NSURL URLWithString:[imgString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""]];
    
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    cell.backgroundView = imgView;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);//上左下右
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _curIndex = indexPath.row;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger scrIndex = scrollView.contentOffset.x / (ITEM_WIDTH + 10);
    
    if (!decelerate) {
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        _curIndex = scrIndex + 1;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger scrIndex = scrollView.contentOffset.x / (ITEM_WIDTH + 10);
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:scrIndex + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _curIndex = scrIndex + 1;
}

@end
