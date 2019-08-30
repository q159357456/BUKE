//
//  BookDetailObject.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookDetailObject : NSObject

//"isbn": "9787554500200",
//"others": "戴伟杰",
//"painter": "[日]大友康夫",
//"writer": "",
//"author": "[日]渡边茂南",
//"translator": null,
//"forAge": "0-3岁",
//"tags": "",
//"publisher": "河北教育出版社",
//"series": "快乐的小熊",
//"language": 0,
//"pdate": "2013.4",
//"intro": null,
//"reviews": "《和爸爸一起玩》由日本绘本大奖、剑渊绘本之乡大奖得主中川宏贵与知名插画家三角芳子合作的暖心之作，描绘了一段快乐的亲子游戏时光，在游戏的同时，让孩子深切体会到父母浓浓的爱意，让孩子与父母之间建立一种安全、稳定、相互理解且彼此接纳的关系。",
//"aintro": "\r\n",
//"coverPic": "http://xiaobuke.oss-cn-beijing.aliyuncs.com/9787554500200/P0.jpg",
//"price": "88.00",
//"seriesNums": 10,
//"pageNum": 15,
//"id": 15,
//"bookName": "和爸爸一起玩"

@property(nonatomic,strong) NSString *isbn;
@property(nonatomic,strong) NSString *others;
@property(nonatomic,strong) NSString *painter;
@property(nonatomic,strong) NSString *writer;
@property(nonatomic,strong) NSString *author;
@property(nonatomic,strong) NSString *translator;
@property(nonatomic,strong) NSString *forAge;
@property(nonatomic,strong) NSString *tags;
@property(nonatomic,strong) NSString *publisher;
@property(nonatomic,strong) NSString *series;
@property(nonatomic,strong) NSString *language;
@property(nonatomic,strong) NSString *pdate;
@property(nonatomic,strong) NSString *intro;
@property(nonatomic,strong) NSString *reviews;
@property(nonatomic,strong) NSString *aintro;
@property(nonatomic,strong) NSString *coverPic;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *seriesNums;
@property(nonatomic,strong) NSString *pageNum;
@property(nonatomic,strong) NSString *mid;
@property(nonatomic,strong) NSString *bookName;

+(BookDetailObject *) withObject:(NSDictionary *) dic;

@end
