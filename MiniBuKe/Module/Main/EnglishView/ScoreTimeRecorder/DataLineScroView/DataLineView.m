//
//  DataLineView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/10/16.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "DataLineView.h"
#import "English_Header.h"
#import "MyShapLayer.h"
#import "TimeScore.h"
static CGFloat raduis = 5;
@interface DataLineView()
@property(nonatomic,strong)CAShapeLayer *lineShapLayer;
@property(nonatomic,strong)CAGradientLayer *grandientLayer;
@property(nonatomic,strong)NSMutableArray *pointArray;
@property(nonatomic,strong)NSMutableArray *scoreArray;
@end
@implementation DataLineView
-(instancetype)initWithFrame:(CGRect)frame Data:(NSArray*)data{
    
    if (self = [super initWithFrame:frame]) {
        self.dataArray = data;
        CGFloat averge = (self.frame.size.height -80 - raduis*2) / 100;
        self.backgroundColor = COLOR_STRING(@"#F0F3F7");
        for (NSInteger i=0; i<self.dataArray.count; i++) {
            TimeScore *model = self.dataArray[i];
            CGFloat x= SCREEN_WIDTH/2 + i*P_TO_P_WITH;
            CGFloat y = self.frame.size.height -40 - (raduis + [model.score floatValue] * averge);
            CGPoint point = CGPointMake(x, y);
            NSValue *value = [NSValue valueWithCGPoint:point];
            [self.pointArray addObject:value];
            [self.scoreArray addObject:[NSNumber numberWithInteger:[model.score integerValue]]];
            [self.layer addSublayer:self.grandientLayer];
            
        }
        
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


#pragma mark - 懒加载
-(NSMutableArray *)layerArray
{
    if (!_layerArray) {
        _layerArray =[NSMutableArray array];
    }
    return _layerArray;
}
-(NSMutableArray *)b_layerArray
{
    if (!_b_layerArray) {
        
        _b_layerArray = [NSMutableArray array];
    }
    return _b_layerArray;
}
-(NSMutableArray *)pointArray
{
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}
-(NSMutableArray *)scoreArray
{
    if (!_scoreArray) {
        _scoreArray = [NSMutableArray array];
    }
    return _scoreArray;
}

-(CAShapeLayer *)lineShapLayer
{
    if (!_lineShapLayer) {
        _lineShapLayer = [CAShapeLayer layer];
        [_lineShapLayer setLineWidth:2.0f];
        [_lineShapLayer setStrokeColor:[UIColor redColor].CGColor];
    }
    return _lineShapLayer;
}
-(CAGradientLayer *)grandientLayer
{
    if (!_grandientLayer) {
        _grandientLayer = [CAGradientLayer layer];
        _grandientLayer.frame = self.bounds;
        _grandientLayer.locations = @[@0.0,@1.0];
        _grandientLayer.colors = @[(__bridge id)COLOR_STRING(@"#FFDABA").CGColor,(__bridge id)COLOR_STRING(@"#ECF1F7").CGColor];
        _grandientLayer.startPoint = CGPointMake(0, 0 );
        _grandientLayer.opacity = 0.75;
        _grandientLayer.endPoint  = CGPointMake(0, 1);
        
    }
    return _grandientLayer;
}


#pragma mark - drewreact
-(void)drawRect:(CGRect)rect
{

    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //path
    CGMutablePathRef path = CGPathCreateMutable();
    NSValue *value0 = self.pointArray[0];
    CGPoint point0 = [value0 CGPointValue];
    CGPathMoveToPoint(path, nil, point0.x, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil,point0.x,point0.y);
    
    CGPoint points[self.pointArray.count];
    CGPoint linepoints[self.pointArray.count];
    
    for (NSInteger i = 0; i<self.pointArray.count; i++) {
        NSValue *value = self.pointArray[i];
        CGPoint point = [value CGPointValue];
        points[i] = CGPointMake(point.x, point.y + 3);
        linepoints[i] = CGPointMake(point.x, point.y);
    }
    
    CGPathAddLines(path, nil, points, self.pointArray.count);
    NSValue *value1 = self.pointArray[self.pointArray.count - 1];
    CGPoint point1 = [value1 CGPointValue];
    CGPathAddLineToPoint(path, nil, point1.x, self.bounds.size.height);
    CGPathAddLineToPoint(path, nil, point0.x, self.bounds.size.height);
    self.lineShapLayer.path = path;
    self.grandientLayer.mask = self.lineShapLayer;
    

    //画线
    CGContextAddLines(context, linepoints, self.pointArray.count);
    CGContextSetStrokeColorWithColor(context, COLOR_STRING(@"#F98E38").CGColor);
    CGContextSetLineWidth(context, 3);
    CGContextStrokePath(context);
    

    
    for (NSInteger i = 0; i<self.pointArray.count; i++) {
     
        CGPoint point = linepoints[i];
       //绘制背景线
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(point.x, 40, 0.8, self.frame.size.height - 40);
        layer.backgroundColor = COLOR_STRING(@"#DDE5EB").CGColor;
        [self.layer addSublayer:layer];
        [self.b_layerArray addObject:layer];
        // 画圆
        MyShapLayer *shapLayer= [MyShapLayer layer];
        CGMutablePathRef shappath = CGPathCreateMutable();
        CGPathAddArc(shappath, nil, point.x, point.y, raduis, 0, M_PI*2, YES);
        if (i == self.pointArray.count - 1) {
            shapLayer.fillColor = [UIColor whiteColor].CGColor;
            shapLayer.strokeColor = COLOR_STRING(@"#F98E38").CGColor;
            layer.backgroundColor = COLOR_STRING(@"#F587A3").CGColor;
        }else
        {
            shapLayer.fillColor = COLOR_STRING(@"#F98E38").CGColor;
        }
        shapLayer.path = shappath;
        [self.layerArray addObject:shapLayer];
        [self.layer addSublayer:shapLayer];
        CGPathRelease(shappath);
    
        
       // 绘制分数文字
        NSString *drawStr = [NSString stringWithFormat:@"%ld",[self.scoreArray[i] integerValue]];
        NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:SCALE(10)],NSFontAttributeName,COLOR_STRING(@"#999999"),NSForegroundColorAttributeName, nil];
        NSAttributedString *attribute = [[NSAttributedString alloc]initWithString:drawStr attributes:dic];
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        textLayer.string = attribute;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.backgroundColor = COLOR_STRING(@"#F0F3F7").CGColor;
        CGSize size = [drawStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        textLayer.frame = CGRectMake(point.x - size.width/2, point.y - 23, size.width, size.height);
        [self.layer addSublayer:textLayer];
        
        //绘制时间文字
        TimeScore *model = self.dataArray[i];
        NSString *str = model.time;
        CGSize labelSize = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        [str drawAtPoint:CGPointMake(point.x - labelSize.width/2, 2) withAttributes:dic];
        
        
    }

}


@end
