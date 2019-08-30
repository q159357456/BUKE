//
//  BKlineLessonsTableCell.m
//  MiniBuKe
//
//  Created by chenheng on 2019/7/23.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "BKlineLessonsTableCell.h"
#import "BKRecordedLessonCell.h"
#import "OnlineClassPlayController.h"
@interface BKlineLessonsTableCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) LineLessonsData *data;
@end

@implementation BKlineLessonsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModelWith:(LineLessonsData*)data{
    self.data = data;
    self.myCollectionView.contentOffset = CGPointZero;
    [self.myCollectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    //    return 141+6+20;
    return SCALE(262);
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self initCollectionView];
}

- (void)initCollectionView{
    self.contentView.backgroundColor = [UIColor blueColor];
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //    layout.minimumInteritemSpacing = 15;
//    layout.minimumLineSpacing = 10;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCALE(262)) collectionViewLayout:layout];
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
    
    NSString * cellName = NSStringFromClass([BKRecordedLessonCell class]);
    //    UINib * nibCell = [UINib nibWithNibName:cellName bundle:nil];
    [self.myCollectionView registerClass:[BKRecordedLessonCell class] forCellWithReuseIdentifier:cellName];
    
}

#pragma mark - collectionViewDelegate&DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.data.onlineCourseList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //    BKJingDuCollectionViewCell *cell = [BKJingDuCollectionViewCell BKJingDuCollectionCellWithCollectionView:collectionView andIndexPath:indexPath];
    //    [cell setModelWith:self.data.xbkThemeList[indexPath.row]];
    BKRecordedLessonCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BKRecordedLessonCell" forIndexPath:indexPath];
       [cell setModelWith:self.data.onlineCourseList[indexPath.row]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    themeDataModel *model = self.data.xbkThemeList[indexPath.row];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(BKHomeJingDuClickWith:)]) {
//        [self.delegate BKHomeJingDuClickWith:model.bookId];
//    }
    LineLessonsModel * model = self.data.onlineCourseList[indexPath.item];
    OnlineClassPlayController * vc = [[OnlineClassPlayController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@/template/html/onlineCoursePage/onlineCoursePage.html?token=%@&courseId=%@",H5SERVER_URL,TokenEncode,model.lessonId];
//    vc.url = [NSString stringWithFormat:@"%@?token=%@&courseId=%@",@"http://192.168.0.53:8080/template/html/onlineCoursePage/onlineCoursePage.html",TokenEncode,model.lessonId];
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(SCALE(242), SCALE(262-26));
    return size;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(15, 141);
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return CGSizeMake(15, 141);
//}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(SCALE(13), SCALE(8), SCALE(13), SCALE(8));
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
    float pageWidth = SCALE(242)+15-10;
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
