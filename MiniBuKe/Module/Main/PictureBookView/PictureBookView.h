//
//  PictureBookView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureBookView : UIView

@property (nonatomic) bool isLoadOne,isLoadTwo,isLoadThree;

-(void) updateData:(NSArray *) dataArray;

-(void) loadData;

@end
