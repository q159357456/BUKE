//
//  PGIndexBannerSubiew.m


#import "PGIndexBannerSubiew.h"
@interface PGIndexBannerSubiew()
@property (nonatomic, strong) UIImageView *backImage;

@end

@implementation PGIndexBannerSubiew

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.backImage];
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCellTapAction:)];
        [self addGestureRecognizer:singleTap];
    }
    
    return self;
}

- (void)singleCellTapAction:(UIGestureRecognizer *)gesture {
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(self.tag, self);
    }
}

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
    self.backImage.frame = CGRectMake(superViewBounds.origin.x, superViewBounds.origin.y,superViewBounds.size.width, superViewBounds.size.height+12);
}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.layer.cornerRadius = 20;
        _mainImageView.clipsToBounds = YES;
    }
    return _mainImageView;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.layer.cornerRadius = 20;
        _coverView.clipsToBounds = YES;
    }
    return _coverView;
}
- (UIImageView *)backImage{
    if (_backImage == nil) {
        _backImage = [[UIImageView alloc]init];
        _backImage.userInteractionEnabled = YES;
        _backImage.image = [UIImage imageNamed:@"home_banner_back"];
    }
    return _backImage;
}

@end
