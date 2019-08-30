//
//  BKHomeBookCollectionViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/1.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKHomeBookCollectionViewCell.h"
#import "BKHomeListModel.h"
@interface BKHomeBookCollectionViewCell()

@property(nonatomic, weak) IBOutlet UIImageView *corverImage;
@property(nonatomic, weak) IBOutlet UILabel *bookName;
@property(nonatomic, weak) IBOutlet UIImageView *NumberImage;

@end

@implementation BKHomeBookCollectionViewCell

+ (instancetype)BKHomeBookCollectionViewCellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexpath{
    NSString * identify = NSStringFromClass([self class]);
    return [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexpath];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.corverImage.layer.cornerRadius = 5.f;
    self.corverImage.clipsToBounds = YES;
    self.NumberImage.hidden = YES;
}

-(void)setModelWith:(homeSeriesBookModel*)bookmodel{
    self.NumberImage.hidden = YES;
    CGFloat width = ((SCREEN_WIDTH-20-2*10)/3.0)*[UIScreen mainScreen].scale;
    NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",bookmodel.bookPath,(int)width];
    [self.corverImage sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:[UIImage imageNamed:@"place_kidbook_c"] options:SDWebImageRetryFailed];
    self.bookName.text = bookmodel.bookName;

}

-(void)setIntensiveBookModel:(IntensiveBookModel *)intensiveBookModel
{
    self.NumberImage.hidden = YES;
    CGFloat width = ((SCREEN_WIDTH-20-2*10)/3.0)*[UIScreen mainScreen].scale;
    NSString *picurl = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,w_%d",intensiveBookModel.cover,(int)width];
    
    _intensiveBookModel = intensiveBookModel;
    [self.corverImage sd_setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:[UIImage imageNamed:@"place_kidbook_c"] options:SDWebImageRetryFailed];
    self.bookName.text = intensiveBookModel.bookName;
}

- (void)setReadingNumberWith:(NSInteger)number{
    if (number == -1) {
        self.NumberImage.hidden = YES;
    }else{
        self.NumberImage.hidden = NO;
        self.NumberImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_reading_NO%ld",number]];
    }
}

@end
