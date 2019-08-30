//
//  BKHomeBookTableViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomeBookTableViewCell.h"
#import "BKHomeBookCollectionViewCell.h"
#import "BKHomeListModel.h"

#define LeftRightOffest 5.f

@interface BKHomeBookTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)seriesBookDataModel *model;
@end

@implementation BKHomeBookTableViewCell

- (void)setModelWith:(seriesBookDataModel*)data{
    self.model = data;
    self.myCollectionView.frame = CGRectMake(LeftRightOffest+5, 0,SCREEN_WIDTH-2*LeftRightOffest-10,[BKHomeBookTableViewCell heightForCellWithObject:data]);
    [self.myCollectionView reloadData];
}
//-(void)setDetailModelWith:(InstensiveDetailModel *)data
//{
//    
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithObject:(id)obj{
    if (obj != nil) {
        seriesBookDataModel *model = (seriesBookDataModel*)obj;
        NSInteger number = model.bookList.count;
        CGFloat height = (((SCREEN_WIDTH-20-2*LeftRightOffest)/3.0 + 36.f)+10)*(number/3);
        if (number%3) {
            height+=((SCREEN_WIDTH-20-2*LeftRightOffest)/3.0 + 36.f)+10;
        }
        return height;
    }else{
        return 151+20;
    }
}

- (void)setupUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self initCollectionView];
}

- (void)initCollectionView{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //该方法也可以设置itemSize
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 10;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(LeftRightOffest+5, 0,SCREEN_WIDTH-2*LeftRightOffest-10,((SCREEN_WIDTH-20-2*LeftRightOffest)/3.0 + 36.f+10.f)*2) collectionViewLayout:layout];
    self.myCollectionView.scrollEnabled = NO;
    
    [self.contentView addSubview:self.myCollectionView];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    //4.设置代理
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delaysContentTouches = false;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    
    [self regiestCollectionViewCell];
}

- (void)regiestCollectionViewCell{
    
    NSString * cellName = NSStringFromClass([BKHomeBookCollectionViewCell class]);
    UINib * nibCell = [UINib nibWithNibName:cellName bundle:nil];
    [self.myCollectionView registerNib:nibCell forCellWithReuseIdentifier:cellName];
    
}

#pragma mark - collectionViewDelegate&DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.model.bookList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BKHomeBookCollectionViewCell *cell = [BKHomeBookCollectionViewCell BKHomeBookCollectionViewCellWithCollectionView:collectionView andIndexPath:indexPath];
    [cell setModelWith:self.model.bookList[indexPath.item]];
    if (self.model.seriesType == 3) {//阅读排名
        if (indexPath.item<=2) {
            [cell setReadingNumberWith:indexPath.item+1];
        }
    }else{
        [cell setReadingNumberWith:-1];

    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    homeSeriesBookModel *model = self.model.bookList[indexPath.row];
//    NSLog(@"点击了bookid = %@",model.bookId);
    if (self.delegate && [self.delegate respondsToSelector:@selector(BKHomeBookClickWith:)]) {
        [self.delegate BKHomeBookClickWith:model.bookId];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((SCREEN_WIDTH-20-2*LeftRightOffest)/3.0,((SCREEN_WIDTH-20-2*LeftRightOffest)/3.0 + 36.f));
    return size;
}

@end
