
#import "SeriesBookObject.h"

@implementation SeriesBookObject

+(SeriesBookObject *) withObject:(NSDictionary *) dic
{
    SeriesBookObject *obj = nil;
    if (dic != nil) {
        obj = [[SeriesBookObject alloc] init];
        //        @property(nonatomic,strong) NSString *sort;
        //        @property(nonatomic,strong) NSString *bookId;
        //        @property(nonatomic,strong) NSString *bookName;
        //        @property(nonatomic,strong) NSString *bookPath;
        //        @property(nonatomic,strong) NSString *bookType;
        obj.sort = ![[dic objectForKey:@"sort"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"sort"] : @"";
        obj.bookId = ![[dic objectForKey:@"bookId"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"bookId"] : @"";
        obj.bookName = ![[dic objectForKey:@"bookName"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"bookName"] : @"";
        obj.bookPath = ![[dic objectForKey:@"bookPath"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"bookPath"] : @"";
        obj.bookType = ![[dic objectForKey:@"bookType"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"bookType"] : @"";
        obj.storyCount = ![[dic objectForKey:@"storyCount"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"storyCount"] : @"";
        NSInteger sumTime = ![[dic objectForKey:@"sumTime"] isKindOfClass:[NSNull class]] ? [[dic objectForKey:@"sumTime"] integerValue] : 0;
        obj.sumTime = [obj getHHMMSSFromSS:sumTime];
        if (obj.bookPath.length == 0) {
            obj.bookPath = ![[dic objectForKey:@"coverPic"] isKindOfClass:[NSNull class]] ? [dic objectForKey:@"coverPic"] : @"";
            if (obj.bookPath != nil && obj.bookPath.length > 0) {
                obj.bookPath = [NSString stringWithFormat:@"%@%@",obj.bookPath, @"?x-oss-process=image/resize,h_300"];
            }
        }
//        "coverPic": "http://xiaobuke.oss-cn-beijing.aliyuncs.com/9787554500200/P0.jpg"
        NSLog(@"SeriesBookObject ==> sort = %@ || bookName = %@ || bookPath = %@",obj.sort,obj.bookName,obj.bookPath);
    }
    
    return obj;
}

-(NSString *)getHHMMSSFromSS:(NSInteger )seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%0.2ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%0.2ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%0.2ld",seconds%60];
    
    //format of time
    NSString *format_time;
    if ([str_hour integerValue] < 1) {
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }else{
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
    return format_time;
}

@end
