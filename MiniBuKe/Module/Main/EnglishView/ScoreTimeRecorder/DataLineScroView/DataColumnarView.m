//
//  DataColumnarView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "DataColumnarView.h"
#import "English_Header.h"
#import "MyShapLayer.h"
#import "TimeScore.h"
@interface DataColumnarView ()
@end
@implementation DataColumnarView
-(instancetype)initWithFrame:(CGRect)frame Data:(NSArray*)data;
{
    if (self = [super initWithFrame:frame]) {
        
       self.backgroundColor = COLOR_STRING(@"#F0F3F7");
        self.timeDataArray = data;
        //绘制背景线
        CALayer *layer1 = [CALayer layer];
        CALayer *layer2 = [CALayer layer];
        CALayer *layer3 = [CALayer layer];
        CALayer *layer4 = [CALayer layer];
        layer1.backgroundColor = COLOR_STRING(@"#DDE5EB").CGColor;
        layer2.backgroundColor = COLOR_STRING(@"#DDE5EB").CGColor;
        layer3.backgroundColor = COLOR_STRING(@"#DDE5EB").CGColor;
        layer4.backgroundColor = COLOR_STRING(@"#DDE5EB").CGColor;
        layer1.frame = CGRectMake(SCREEN_WIDTH/6, 40, 0.8, self.frame.size.height - 40);
        layer2.frame = CGRectMake(SCREEN_WIDTH/3, 40, 0.8, self.frame.size.height - 40);
        layer3.frame = CGRectMake(self.frame.size.width - SCREEN_WIDTH/3, 40, 0.8, self.frame.size.height - 40);
        layer4.frame = CGRectMake(self.frame.size.width - SCREEN_WIDTH/6 , 40, 0.8, self.frame.size.height - 40);
        [self.layer addSublayer:layer1];
        [self.layer addSublayer:layer2];
        [self.layer addSublayer:layer3];
        [self.layer addSublayer:layer4];
       
        
    }
    return self;
}
-(NSMutableArray *)layerArray
{
    if (!_layerArray) {
        _layerArray = [NSMutableArray array];
    }
    return _layerArray;
}
-(void)layoutSubviews
{
     [self creatContet];
}

-(void)creatContet{
   

        
    int temp = [self compareGetMax:self.timeDataArray];
    CGFloat max = round(temp/60.00);
    double averge = (self.frame.size.height - 50.0f -10.0f)/max;
    CGFloat startX = SCREEN_WIDTH/2 - with/2;
    for (NSInteger i=0; i<self.timeDataArray.count; i++) {
        TimeScore *model = self.timeDataArray[i];
        CGFloat value = (int)round((model.score.floatValue/60)*averge);
        CGFloat x = startX + (with + colum)*i;
        CGFloat radiusX = x + with/2;
        
        //绘制背景线
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(radiusX, 40, 0.8, self.frame.size.height - 40);
        layer.backgroundColor = COLOR_STRING(@"#DDE5EB").CGColor;
        [self.layer addSublayer:layer];
        
        if (model.score.floatValue ==0)
        {
            CAShapeLayer *shaplayer = [CAShapeLayer layer];
            shaplayer.frame = CGRectMake(x,self.frame.size.height - 35 - with/2, with, with/2);
            shaplayer.strokeColor = COLOR_STRING(@"#5AC357").CGColor;
            shaplayer.fillColor = COLOR_STRING(@"#F0F3F7").CGColor;
            shaplayer.lineWidth = 1;
            shaplayer.lineJoin = kCALineJoinRound;
            
           // 设置虚线的线宽及间距
            [shaplayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber       numberWithInt:3], [NSNumber numberWithInt:1], nil]];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddArc(path, nil, with/2, with/2, with/2, 0, AngleToRadian(-180), YES);
            shaplayer.path = path;
            CGPathRelease(path);
            [self.layer addSublayer:shaplayer];
            [self.layerArray addObject:shaplayer];
            // 绘制分数文字
            NSString *drawStr ;
            if (self.isMinute) {
                drawStr = [NSString stringWithFormat:@"%.1f",ceilf(model.score.floatValue/60.00)];
            }else
            {
                drawStr = [NSString stringWithFormat:@"%.1f",model.score.floatValue/3600.00];
            }
            NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:SCALE(10)],NSFontAttributeName,COLOR_STRING(@"#999999"),NSForegroundColorAttributeName, nil];
            NSAttributedString *attribute = [[NSAttributedString alloc]initWithString:drawStr attributes:dic];
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            textLayer.string = attribute;
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.backgroundColor = COLOR_STRING(@"#F0F3F7").CGColor;
            CGSize size = [drawStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            CGFloat y  = self.frame.size.height - 35 - with/2 - 14;
            textLayer.frame = CGRectMake(radiusX - size.width/2, y, size.width, size.height);
            [self.layer addSublayer:textLayer];
          


        }else
        {
            //绘制渐变
            CAGradientLayer *grandient = [CAGradientLayer layer];
            if (i == self.timeDataArray.count - 1) {
                grandient.colors = nil;
                grandient.backgroundColor = COLOR_STRING(@"#5AC357").CGColor;
            }else
            {
                grandient .colors = @[(__bridge id)COLOR_STRING(@"#5AC357").CGColor,(__bridge id)COLOR_STRING(@"#CBE8D5").CGColor];
            }
            
            //_grandientLayer.locations = @[@(0.2),@(0.65),@(0.7)];
            
            grandient .startPoint = CGPointMake(0, 0);
            grandient .endPoint = CGPointMake(0, 1);
            grandient .type = kCAGradientLayerAxial;
            grandient .frame = CGRectMake(x,self.frame.size.height + 10 - 40  - value, with, value);
            [self.layerArray addObject:grandient];
            [self.layer addSublayer:grandient];
            
            //绘制顶部圆弧
            CGFloat w = with;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, 0, value);
            CGPathAddLineToPoint(path, nil, 0, w/2.0f);
            CGPathAddArc(path, nil, w/2.0f, w/2.0f, w/2.0f,0 , AngleToRadian(-180), YES);
            CGPathAddLineToPoint(path, nil, w, w/2.0f);
            CGPathAddLineToPoint(path, nil, w,value);
            CGPathAddLineToPoint(path, nil, 0, value);
            //
            CAShapeLayer *shap = [CAShapeLayer layer];
            shap.path = path;
            grandient.mask = shap;
            CGPathRelease(path);
            
            // 绘制分数文字
          
            NSString *drawStr ;
            if (self.isMinute) {
                drawStr = [NSString stringWithFormat:@"%.1f",ceilf(model.score.floatValue/60.00)];
            }else
            {
                drawStr = [NSString stringWithFormat:@"%.1f",model.score.floatValue/3600.00];
            }
            NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:SCALE(10)],NSFontAttributeName,COLOR_STRING(@"#999999"),NSForegroundColorAttributeName, nil];
            NSAttributedString *attribute = [[NSAttributedString alloc]initWithString:drawStr attributes:dic];
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            textLayer.string = attribute;
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.backgroundColor = COLOR_STRING(@"#F0F3F7").CGColor;
            CGSize size = [drawStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            CGFloat y  = self.frame.size.height - 45  - value;
            textLayer.frame = CGRectMake(radiusX - size.width/2, y, size.width, size.height);
            [self.layer addSublayer:textLayer];
            
        }
       
    }
    
}

-(void)drawRect:(CGRect)rect
{
    //绘制时间文字
    CGFloat startX = SCREEN_WIDTH/2 - with/2;
    
    for (NSInteger i=0;i<self.timeDataArray.count;i++) {
        TimeScore *model = self.timeDataArray[i];
        CGFloat x = startX + (with + colum)*i;
        NSString *str = model.time;
        NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:SCALE(10)],NSFontAttributeName,COLOR_STRING(@"#999999"),NSForegroundColorAttributeName, nil];
        CGSize labelSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        [str drawAtPoint:CGPointMake(x + with/2 - labelSize.width/2, 0) withAttributes:dic];
    }
   
}

//找出最大数据
-(int)compareGetMax:(NSArray*)array{
 
    
    int max = 0;
    if (array.count == 1) {
        TimeScore *model = array.firstObject;
        max = model.score.intValue;
    }else
    {
        for (NSInteger i=0; i<array.count; i++) {
            TimeScore *model1 = array[i];
            int x1 = model1.score.intValue;
            max = MAX(max, x1);
//            NSLog(@"max==>%d",max);

        }
    }
   
    
    return max;
   
    
}
@end
