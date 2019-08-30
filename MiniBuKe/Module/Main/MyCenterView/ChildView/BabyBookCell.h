//
//  BabyBookCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/21.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BabyBookCell_height 165
@class BooklistObjet;

@protocol BabyBookCellDelegate <NSObject>

@required
-(void) onSelectCell:(BooklistObjet *) obj select:(BOOL) isSelect;
//- (void)requiredMethod；
@optional
//- (void)optionalMethod；

@end

@interface BabyBookCell : UITableViewCell

@property (nonatomic, weak, nullable) id <BabyBookCellDelegate> delegate;

+(instancetype)xibTableViewCell;

-(void) updateViewData:(CGSize ) size setArrayBooklistObjet:(NSArray  *)mBooklistObjets isSelect:(BOOL) isSelect;
@end
