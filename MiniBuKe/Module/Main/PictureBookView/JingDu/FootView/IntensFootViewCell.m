//
//  IntensFootViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "IntensFootViewCell.h"
#import "BKHomeBookCollectionViewCell.h"
#import "BKHomeCellHeadView.h"
#import "UIResponder+Event.h"
#define LeftRightOffest 5.f
@interface IntensFootViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UILabel *headerView;
@end
@implementation IntensFootViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setInstensiveDetailModel:(InstensiveDetailModel *)instensiveDetailModel
{
    _instensiveDetailModel = instensiveDetailModel;
    self.headerView.text = [NSString stringWithFormat:@"%@",instensiveDetailModel.column];
    [self.myCollectionView reloadData];

}
+ (CGFloat)heightForCellWithObject:(id)obj{
    if (obj != nil) {

        InstensiveDetailModel *model = (InstensiveDetailModel*)obj;
        return 141* ceilf((model.columnBookList.count/3.00))  +20 + 65;
    }else{
        return 141 + 20 + 65;
    }
  
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

      
        [self initCollectionView];
        
        
    }
    return self;
}

- (void)initCollectionView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    view.backgroundColor = [UIColor whiteColor];
    self.headerView = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, view.frame.size.width, view.frame.size.height)];
    self.headerView.text = @"更多图书信息";
    self.headerView.font = [UIFont boldSystemFontOfSize:17];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.headerView];
    [self.contentView addSubview:view];
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //该方法也可以设置itemSize
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 10;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(LeftRightOffest+5, 65,SCREEN_WIDTH-2*LeftRightOffest-10,((SCREEN_WIDTH-20-2*LeftRightOffest)/3.0 + 36.f+10.f)*2) collectionViewLayout:layout];
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
    
    return self.instensiveDetailModel.columnBookList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BKHomeBookCollectionViewCell *cell = [BKHomeBookCollectionViewCell BKHomeBookCollectionViewCellWithCollectionView:collectionView andIndexPath:indexPath];
    IntensiveBookModel *model = self.instensiveDetailModel.columnBookList[indexPath.row];
    cell.intensiveBookModel = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
       IntensiveBookModel *model = self.instensiveDetailModel.columnBookList[indexPath.row];
    [self eventName:IntensFootViewCell_Event Params:model.bookId];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((SCREEN_WIDTH-20-2*LeftRightOffest)/3.0,((SCREEN_WIDTH-20-2*LeftRightOffest)/3.0 + 36.f));
    return size;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
