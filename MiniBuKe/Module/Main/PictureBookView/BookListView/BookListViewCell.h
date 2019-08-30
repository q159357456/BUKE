//
//  BookListViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BookListViewCell_height (SCREEN_WIDTH*0.5+-23.f+10.f+63.f)

@class BooklistObjet;

@protocol BookListViewCellDelegate <NSObject>

- (void)NewbookClickWithBookId:(NSString*)bookId;

@end

@interface BookListViewCell : UITableViewCell

+(instancetype)xibTableViewCell;

-(void) updateData:(CGSize ) size setArrayBooklistObjet:(NSArray *) mBooklistObjets;

-(void)NewBookUpdateData:(CGSize ) size setArrayBooklistObjet:(NSArray *) mBooklistObjets;
@property(nonatomic,assign) id<BookListViewCellDelegate> delegate;

@end
