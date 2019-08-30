//
//  KBookTableViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "KBookTableViewCell.h"
#import "BookDetailViewController.h"
#import "BooklistObjet.h"
#import "IntensiveReadingController.h"

@interface KBookTableViewCell ()

@property (nonatomic,strong) KbookListObject *mKbookListObject;

@property (nonatomic,weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic,weak) IBOutlet UILabel *labelTitle;
@property (nonatomic,weak) IBOutlet UILabel *hintTitle;


@end

@implementation KBookTableViewCell

+(instancetype)xibTableViewCell {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"KBookTableViewCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateData:(KbookListObject *) mKbookListObject
{
    self.mKbookListObject = mKbookListObject;
    
    self.labelTitle.text = mKbookListObject.bookName;
    self.hintTitle.text = mKbookListObject.familyName;
    
    
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[mKbookListObject.picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"绘本1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"sd_setImageWithURL ===> %@",error);
        if (image) {
            [self.iconImageView setImage:image];
        }
    }];
}

-(IBAction) onClickRight:(id)sender
{
    if (self.delegate != nil) {
        [self.delegate onClickRightCell:self.mKbookListObject];
    }
}

-(IBAction) onClickCell:(id)sender
{
    BooklistObjet *mBooklistObjet = [[BooklistObjet alloc] init];
    
    mBooklistObjet.coverPic = self.mKbookListObject.picUrl;
    mBooklistObjet.author = self.mKbookListObject.bookName;
    mBooklistObjet.mid = self.mKbookListObject.mid;
    mBooklistObjet.name = self.mKbookListObject.bookName;
    
//    BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:mBooklistObjet];
//    [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
    
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = mBooklistObjet.mid;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];

}

@end
