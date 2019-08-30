//
//  BabyInfoTapChosenView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BabyInfoTapChosenView.h"
#import "UIResponder+Event.h"
#import "BKLoginCodeTip.h"
#define TagsTitleFont  [UIFont systemFontOfSize: SCALE(13)]
@implementation BabyInfoTapChosenView
{
    NSMutableArray *_tapArray;
    NSInteger _colorSelectIndex;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        _tagsFrames = [NSMutableArray array];
        _width = SCREEN_WIDTH;
        _tagsMinPadding = SCALE(6);
        _tagsMargin = 10;
        _tagsLineSpacing = 10;
        _startX=10;
        _startY=0;
        _tapArray = [NSMutableArray array];
        _colorSelectIndex = 0;
        
    }
    return self;
}

- (void)setTagsArray:(NSArray *)tagsArray
{
    _tagsArray = tagsArray;
    
    if (tagsArray.count ==0 ) {
        return;
    }
    CGFloat btnX = _startX;
    CGFloat btnW = 0;
    
    CGFloat nextWidth = 0;  // 下一个标签的宽度
    CGFloat moreWidth = 0;  // 每一行多出来的宽度
    
    /**
     *  每一行的最后一个tag的索引的数组和每一行多出来的宽度的数组
     */
    NSMutableArray *lastIndexs = [NSMutableArray array];
    NSMutableArray *moreWidths = [NSMutableArray array];
    
    for (NSInteger i=0; i<tagsArray.count; i++) {
        //POSDIModel *model1=tagsArray[i];
        
        btnW = [self sizeWithText:tagsArray[i] font:TagsTitleFont].width + _tagsMinPadding * 2;
        
        if (i < tagsArray.count-1) {
            //POSDIModel *model2=tagsArray[i+1];
            nextWidth = [self sizeWithText:tagsArray[i+1] font:TagsTitleFont].width + _tagsMinPadding * 2;
        }
        CGFloat nextBtnX = btnX + btnW + _tagsMargin;
        // 如果下一个按钮，标签最右边则换行
        if ((nextBtnX + nextWidth) > (_width- _tagsMargin)) {
            // 计算超过的宽度
            moreWidth = _width - nextBtnX;
            
            [lastIndexs addObject:[NSNumber numberWithInteger:i]];
            [moreWidths addObject:[NSNumber numberWithFloat:moreWidth]];
            btnX = _tagsMargin;
        }else{
            btnX += (btnW + _tagsMargin);
        }
        
        // 如果是最后一个且数组中没有，则把最后一个加入数组
        if (i == tagsArray.count -1) {
            if (![lastIndexs containsObject:[NSNumber numberWithInteger:i]]) {
                [lastIndexs addObject:[NSNumber numberWithInteger:i]];
                [moreWidths addObject:[NSNumber numberWithFloat:0]];
            }
        }
    }
    
    NSInteger location = 0;  // 截取的位置
    NSInteger length = 0;    // 截取的长度
    CGFloat averageW = 0;    // 多出来的平均的宽度
    
    CGFloat tagW = 0;
    CGFloat tagH = 30;
    
    for (NSInteger i=0; i<lastIndexs.count; i++) {
        
        NSInteger lastIndex = [lastIndexs[i] integerValue];
        if (i == 0) {
            length = lastIndex + 1;
        }else{
            length = [lastIndexs[i] integerValue]-[lastIndexs[i-1] integerValue];
        }
        
        // 从数组中截取每一行的数组
        NSArray *newArr = [tagsArray subarrayWithRange:NSMakeRange(location, length)];
        location = lastIndex + 1;
        
        averageW = [moreWidths[i] floatValue]/newArr.count;
        
        CGFloat tagX = _startX;
        CGFloat tagY =_startY+_tagsLineSpacing + (_tagsLineSpacing + tagH) * i;
        
        for (NSInteger j=0; j<newArr.count; j++) {
            // POSDIModel *model=newArr[j];
            tagW = [self sizeWithText:newArr[j] font:TagsTitleFont].width + _tagsMinPadding * 2 + averageW;
            
            CGRect btnF = CGRectMake(tagX, tagY, tagW, tagH);
            
            [_tagsFrames addObject:NSStringFromCGRect(btnF)];
            
            
            tagX += (tagW+_tagsMargin);
            
        }
    }
    
    _tagsHeight = (tagH + _tagsLineSpacing) * lastIndexs.count + _tagsLineSpacing;
    
    //button
    for (NSInteger i=0; i<tagsArray.count; i++) {
        
        UIButton *tagsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tagsBtn setTitle:tagsArray[i] forState:UIControlStateNormal];
        
        tagsBtn.titleLabel.font = TagsTitleFont;
        tagsBtn.layer.borderWidth = 1;
        tagsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tagsBtn.layer.cornerRadius = 15;
        tagsBtn.layer.masksToBounds = YES;
        [tagsBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        tagsBtn.frame = CGRectFromString(_tagsFrames[i]);
        tagsBtn.tag=i+1;
        //选中状态
        tagsBtn.backgroundColor = COLOR_STRING(@"F7F9FB");
     
        [tagsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//
        [tagsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:tagsBtn];
    }
    [self eventName:BabyInfoTapChosenView_Event Params:[NSNumber numberWithFloat:_tagsHeight]];
    
}

/**
 *  单行文本数据获取宽高
 *
 *  @param text 文本
 *  @param font 字体
 *
 *  @return 宽高
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text sizeWithAttributes:attrs];
}
-(void)selectTemp:(NSString *)param
{
    NSArray *array = [param componentsSeparatedByString:@","];
    for (NSString *temp in array) {
        if ([self.tagsArray containsObject:temp]) {
            NSInteger index  = [self.tagsArray indexOfObject:temp];
            UIButton *button = (UIButton*)[self viewWithTag:index+1];
            [self click:button];
        }
    }
}
#pragma mark - action
-(void)click:(UIButton*)btn{
    NSArray *colorArray = @[COLOR_STRING(@"#FE7C84"),COLOR_STRING(@"#60D1CC"),COLOR_STRING(@"#F3C62B")];
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        if (_tapArray.count==5) {
            btn.selected =NO;
            
            [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"最多选五个，不要贪多哟~" and:APP_DELEGATE.window];
            return;
        }
        NSString *temp = self.tagsArray[btn.tag -1];
        [_tapArray addObject:temp];
        
        btn.backgroundColor = colorArray[_colorSelectIndex];
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        _colorSelectIndex++;
        if (_colorSelectIndex == 3) {
            _colorSelectIndex = 0;
        }
        
    }else
    {
        btn.backgroundColor = COLOR_STRING(@"F7F9FB");
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        NSString *temp = self.tagsArray[btn.tag -1];
        [_tapArray removeObject:temp];
    }
   
    [self eventName:BabyInfoTapClick_Event Params:self.tagsArray[btn.tag -1]];
   
}

@end
