//
//  KBookTableViewCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/5/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KbookListObject.h"

#define KBookTableViewCell_Height 93

@protocol KBookTableViewCellDelegate <NSObject>

@required
-(void) onClickRightCell:(KbookListObject *) obj;
//- (void)requiredMethod；
@optional
//- (void)optionalMethod；

@end

@interface KBookTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id <KBookTableViewCellDelegate> delegate;

+(instancetype)xibTableViewCell;

-(void) updateData:(KbookListObject *) mKbookListObject;

@end
