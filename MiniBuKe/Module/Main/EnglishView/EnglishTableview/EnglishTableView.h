//
//  EnglishTableView.h
//  MiniBuKe
//
//  Created by chenheng on 2018/9/12.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define EnglishTableView_Event @"EnglishTableViewEvent_ScroListen"
@interface EnglishTableView : UITableView
@property(nonatomic,strong)NSArray *Teaching_Catagory_List;
@property(nonatomic,strong)NSArray *SeriesList;
@end
