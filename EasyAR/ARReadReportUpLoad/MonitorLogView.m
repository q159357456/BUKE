//
//  MonitorLogView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/7/5.
//  Copyright © 2019 深圳偶家科技有限公司. All rights reserved.
//

#import "MonitorLogView.h"
@interface MonitorLogView()
@property(nonatomic,copy)NSMutableString * totalContent;
@property(nonatomic,strong)UITextView * textView;
@end
@implementation MonitorLogView
static MonitorLogView * _monitorLogView = nil;
+(instancetype)singleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _monitorLogView = [[super allocWithZone:nil]init];
    });
    return _monitorLogView;
}
+(id) allocWithZone:(struct _NSZone *)zone
{
    return [MonitorLogView singleton] ;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
         _totalContent = [NSMutableString string];
        self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.8];
        self.textView = [[UITextView alloc]init];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.textColor = [UIColor whiteColor];
        self.textView.editable = NO;
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden:)];
        self.textView.userInteractionEnabled = YES;
        [self.textView addGestureRecognizer:tap];
    }
    return self;
}
-(void)setContent:(NSString *)content
{
    _content = content;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString * datestr = [formatter stringFromDate:[NSDate date]];
    [_totalContent appendString:[NSString stringWithFormat:@"[%@] %@\n",datestr,[content copy]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        _textView.text = _totalContent;
    });
}

+(void)showMonitorLog:(NSString*)Log{
    if (IS_Monitor_Model) {
        if (APP_DELEGATE.window) {
            MonitorLogView  * ob = [MonitorLogView singleton];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (![APP_DELEGATE.window.subviews containsObject:ob]) {
                    ob.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALE(500));
                    ob.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                    [APP_DELEGATE.window addSubview:ob];
                }
            });
            ob.content = Log;
        }
    }
 
}
+(void)hiddenMonitorLog{
     MonitorLogView  * ob = [MonitorLogView singleton];
     [ob.totalContent deleteCharactersInRange:NSMakeRange(0, ob.totalContent.length)];
     [ob removeFromSuperview];
    
}


-(void)hidden:(UITapGestureRecognizer*)tap{
    
    CGPoint point = [tap locationInView:self];
    CGRect enable = CGRectMake(SCREEN_WIDTH-60, 0, 60, 60);
    if (CGRectContainsPoint(enable, point)) {
        [self.totalContent deleteCharactersInRange:NSMakeRange(0, self.totalContent.length)];
        [self removeFromSuperview];
    }
}
@end
