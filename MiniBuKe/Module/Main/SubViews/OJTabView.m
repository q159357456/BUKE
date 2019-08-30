//
//  OJTabView.m
//  MiniBuKe
//
//  Created by chenheng on 2018/8/13.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "OJTabView.h"
#import "ScaleLabel.h"

#define ICON_IMAGE_SIZE_DEFAULT CGSizeMake(29,23)
#define ICON_IMAGE_SIZE_ZOOM CGSizeMake(24,19)

#define TITLE_LABEL_SIZE_DEFAULT CGSizeMake(100,28)
#define TITLE_LABEL_SIZE_ZOOM CGSizeMake(60,20)

@interface OJTabView ()

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *defaultIcon;
@property (nonatomic,strong) NSString *pressIcon;

@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *clickButton;

@end

@implementation OJTabView
 
-(instancetype)initWithFrame:(CGRect)frame setTitle:(NSString *) title setDefaultIcon:(NSString *) defaultIcon setPressIcon:(NSString *) pressIcon setOnTabClick:(onTabClick) onTabClickBlock
{
    if(self = [super initWithFrame:frame]){
        self.title = title;
        self.defaultIcon = defaultIcon;
        self.pressIcon = pressIcon;
        self.onTabClick = onTabClickBlock;
        self.isSelect = YES;
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame setTitle:(NSString *) title setDefaultIcon:(NSString *) defaultIcon setPressIcon:(NSString *) pressIcon
          setOnStartTabClick:(onStartTabClick) onStartTabClick setOnTabClick:(onTabClick) onTabClickBlock
{
    if(self = [super initWithFrame:frame]){
        self.title = title;
        self.defaultIcon = defaultIcon;
        self.pressIcon = pressIcon;
        
        self.onStartTabClick = onStartTabClick;
        self.onTabClick = onTabClickBlock;
        self.isSelect = YES;
        
        [self initView];
    }
    return self;
}

-(void) initView
{
//    [self setBackgroundColor: [UIColor greenColor] ];
    
    [self createIconImageView];
    [self createTitleLabel];
    [self createClickButton];
}

-(void) createIconImageView
{
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 29/2,8,29,23)];
//    [self.mIconImageView setBackgroundColor:[UIColor redColor]];
    [self.iconImageView setImage: [UIImage imageNamed:self.defaultIcon]];
    [self addSubview: self.iconImageView];
}

-(void) createTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,26,self.frame.size.width,28)];
    self.titleLabel.text = self.title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = MY_FONT(11);
//    self.titleLabel.textColor = COLOR_STRING(@"#888888");
    self.titleLabel.textColor = COLOR_STRING(@"#999999");

//    self.titleLabel.colorLabelColor = COLOR_STRING(@"#888888");
    
//    self.titleLabel.startScale = 1.0f;
//    self.titleLabel.endScale = 1.0f;
//    self.titleLabel.duration = 0.5f;
    [self addSubview:self.titleLabel];
    
//    [self.titleLabel startAnimation];
}

-(void) createClickButton
{
    self.clickButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    [self.clickButton addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.clickButton setBackgroundColor:[UIColor clearColor] ];
    [self addSubview: self.clickButton];
}

-(IBAction) onClickButton:(id) sender
{
    if (self.onStartTabClick != nil) {
        self.onStartTabClick();
    }
    
    if (self.onTabClick != nil) {
        
        if (self.isSelect) {
            NSArray *views = [self.superview subviews];
            for (int i = 0; i < views.count; i ++) {
                id view = [views objectAtIndex:i];

//                NSLog(@"views ===> %@",[view class]);

                if ([view isKindOfClass:[OJTabView class]]) {
                    OJTabView *mOJTabView = (OJTabView *) view;
                    if (self == mOJTabView) {
                        [mOJTabView setTabClickStatus:true];
                    } else {
                        [mOJTabView setTabClickStatus:false];
                    }
                }
            }
        }
        
//        NSLog(@"=====> onTabClick <=====");
        self.onTabClick();
    }
}

-(void) setTabClickStatus:(BOOL) isClick
{
    if (!isClick) {
        [self.iconImageView setImage: [UIImage imageNamed:self.defaultIcon]];
//        self.titleLabel.textColor = COLOR_STRING(@"#888888");
        self.titleLabel.textColor = COLOR_STRING(@"#999999");

//        NSLog(@"进来了吗？？？？？？？");
    } else {
        [self.iconImageView setImage: [UIImage imageNamed:self.pressIcon]];
//        self.titleLabel.textColor = COLOR_STRING(@"#F57428");
        self.titleLabel.textColor = COLOR_STRING(@"#999999");

//        self.titleLabel.startScale = 1.0f;
//        self.titleLabel.endScale = 0.5f;
//        //    self.titleLabel.duration = 0.5f;
//        [self.titleLabel startAnimation];
        
        [self changeFrameAnimation:CGRectMake(self.iconImageView.center.x - ICON_IMAGE_SIZE_ZOOM.width/2, self.iconImageView.center.y - ICON_IMAGE_SIZE_ZOOM.height/2, ICON_IMAGE_SIZE_ZOOM.width, ICON_IMAGE_SIZE_ZOOM.height)];
    }
}

-(void) changeFrameAnimation:(CGRect) frame
{
    [UIView beginAnimations:@"FrameAni" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(startAnimation:)];
    [UIView setAnimationDidStopSelector:@selector(stopAnimation:)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    self.iconImageView.frame = frame;
//    self.titleLabel.frame = titleFrame;
    [UIView commitAnimations];
}

-(void) startAnimation:(NSString *)aniID
{
//    NSLog(@"changeFrameAnimation ==> startAnimation");

}

-(void) stopAnimation:(NSString *)aniID
{
//    NSLog(@"changeFrameAnimation ==> stopAnimation");
    if (self.iconImageView.frame.size.width != ICON_IMAGE_SIZE_DEFAULT.width) {
        [self changeFrameAnimation:CGRectMake(self.iconImageView.center.x - ICON_IMAGE_SIZE_DEFAULT.width/2, self.iconImageView.center.y - ICON_IMAGE_SIZE_DEFAULT.height/2, ICON_IMAGE_SIZE_DEFAULT.width, ICON_IMAGE_SIZE_DEFAULT.height)];
        
//        self.titleLabel.startScale = 0.5f;
//        self.titleLabel.endScale = 1.0f;
//        //    self.titleLabel.duration = 0.5f;
//        [self.titleLabel startAnimation];
    }
    
}

@end
