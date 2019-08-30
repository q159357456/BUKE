//
//  BookDetailObject.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookDetailObject.h"

@implementation BookDetailObject


+(BookDetailObject *) withObject:(NSDictionary *) dic
{
    BookDetailObject *obj = nil;
    if (dic != nil) {
        obj = [[BookDetailObject alloc] init];
        obj.isbn = ![[dic objectForKey:@"isbn"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"isbn"] : @"";
        obj.others = ![[dic objectForKey:@"others"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"others"] : @"";
        obj.painter = ![[dic objectForKey:@"painter"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"painter"] : @"";
        obj.writer = ![[dic objectForKey:@"writer"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"writer"] : @"";
        obj.author = ![[dic objectForKey:@"author"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"author"] : @"";
        obj.translator = ![[dic objectForKey:@"translator"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"translator"] : @"";
        obj.forAge = ![[dic objectForKey:@"forAge"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"forAge"] : @"";
        obj.tags = ![[dic objectForKey:@"tags"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"tags"] : @"";
        obj.publisher = ![[dic objectForKey:@"publisher"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"publisher"] : @"";
        obj.series = ![[dic objectForKey:@"series"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"series"] : @"";
        obj.language = ![[dic objectForKey:@"language"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"language"] : @"";
        obj.language = ![[dic objectForKey:@"language"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"language"] : @"";
        obj.pdate = ![[dic objectForKey:@"pdate"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"pdate"] : @"";
        obj.intro = ![[dic objectForKey:@"intro"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"intro"] : @"";
        obj.reviews = ![[dic objectForKey:@"reviews"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"reviews"] : @"";
        obj.aintro = ![[dic objectForKey:@"aintro"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"aintro"] : @"";
        obj.coverPic = ![[dic objectForKey:@"coverPic"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"coverPic"] : @"";
        obj.price = ![[dic objectForKey:@"price"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"price"] : @"";
        obj.seriesNums = ![[dic objectForKey:@"seriesNums"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"seriesNums"] : @"";
        obj.pageNum = ![[dic objectForKey:@"pageNum"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"pageNum"] : @"";
        obj.mid = ![[dic objectForKey:@"id"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"id"]stringValue] : @"";
        obj.bookName = ![[dic objectForKey:@"bookName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"bookName"] : @"";
        
//        NSLog(@"BooklistObjet ==> id = %@ || bookName = %@ || userId = %@",obj.mid,obj.author,obj.name);
        
//        @property(nonatomic,strong) NSString *isbn;
//        @property(nonatomic,strong) NSString *others;
//        @property(nonatomic,strong) NSString *painter;
//        @property(nonatomic,strong) NSString *writer;
//        @property(nonatomic,strong) NSString *author;
//        @property(nonatomic,strong) NSString *translator;
//        @property(nonatomic,strong) NSString *forAge;
//        @property(nonatomic,strong) NSString *tags;
//        @property(nonatomic,strong) NSString *publisher;
//        @property(nonatomic,strong) NSString *series;
//        @property(nonatomic,strong) NSString *language;
//        @property(nonatomic,strong) NSString *pdate;
//        @property(nonatomic,strong) NSString *intro;
//        @property(nonatomic,strong) NSString *reviews;
//        @property(nonatomic,strong) NSString *aintro;
//        @property(nonatomic,strong) NSString *coverPic;
//        @property(nonatomic,strong) NSString *price;
//        @property(nonatomic,strong) NSString *seriesNums;
//        @property(nonatomic,strong) NSString *pageNum;
//        @property(nonatomic,strong) NSString *mid;
//        @property(nonatomic,strong) NSString *bookName;
    }
    
    return obj;
}

@end
