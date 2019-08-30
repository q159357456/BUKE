//
//  BookDetailViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/14.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookDetailService.h"
#import "BooklistObjet.h"
#import "UIImageView+WebCache.h"
#import "BookDetailObject.h"
#import "KBookViewController.h"
#import "KBookPageService.h"
#import "KBookPageObject.h"
#import "MusicPlayTool.h"
#import "BookVoiceChooseVersion.h"
#import "KBookVoiceChooseService.h"
#import "MBProgressHUD+XBK.h"

//#ifdef  IS_FULL_VERSION
#define bottomView_height   60
//#else
//#define bottomView_height   0
//#endif
#define background_height   266

@interface BookDetailViewController ()<UIScrollViewDelegate,MusicPlayToolDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIImageView *kBookImageView;
@property(nonatomic,strong) UIImageView *changeImageView;
@property(nonatomic,strong) UIButton *buyButton;

@property(nonatomic,strong) UIImageView *bgImageView;
@property(nonatomic,strong) UIView *textView;

//@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *endTitleLabel;

@property(nonatomic,strong) UIScrollView *myScrollView;

@property(nonatomic,strong) BooklistObjet *mBooklistObjet;

@property(nonatomic,strong) BookDetailObject *mBookDetailObject;

@property(nonatomic,strong) KBookPageObject *bookPageObject;

@property(nonatomic,assign) NSInteger pageNum;

@property(nonatomic,strong) UIView *backgroundView;
@property(nonatomic,strong) UIButton *frontButton;
@property(nonatomic,strong) UIButton *nextButton;
@property(nonatomic,strong) UIButton *playButton;
@property(nonatomic,strong) UIImageView *frontImgView;
@property(nonatomic,strong) UIImageView *nextImgView;
@property(nonatomic,strong) UIImageView *playImgView;
@property(nonatomic,strong) UILabel *bookNameLabel;

@property(nonatomic,strong) MusicPlayTool *playTool;

@property(nonatomic) bool isShow;

@end

@implementation BookDetailViewController

-(instancetype)init:(BooklistObjet *) mBooklistObjet
{
    if (self = [super init]) {
        self.mBooklistObjet = mBooklistObjet;
        
        NSLog(@"BooklistObjet ===> %@",mBooklistObjet.name);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.playTool = [MusicPlayTool shareMusicPlay];
    self.playTool.delegat = self;
    
    [self initView];
    [self onBookDetailService];
    
}

//-(void) updateDataView:(BookDetailObject *) mBookDetailObject
//{
//    if (mBookDetailObject != nil) {
//
//        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[mBookDetailObject.coverPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//            if (image) {
//                [self.bgImageView setImage:image];
//            }
//        }];
//
//        NSString *text = mBookDetailObject.reviews;
//        _contentLabel.text = text;
//        [_contentLabel setNumberOfLines:0];
//        UIFont *font = [UIFont fontWithName:@"Arial" size:14];
//        //设置字体
//        _contentLabel.font = font;
//        CGSize constraint = CGSizeMake(_myScrollView.frame.size.width, 20000.0f);
//
//        CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//        [_contentLabel setFrame:CGRectMake(10,30, size.width - 10*2, size.height)];
//        _contentLabel.backgroundColor = [UIColor redColor];
//
//        _endTitleLabel.frame = CGRectMake(0, _contentLabel.frame.size.height + _contentLabel.frame.origin.y, _myScrollView.frame.size.width - 10, 25);
//        _endTitleLabel.textAlignment = NSTextAlignmentRight;
//        _endTitleLabel.text = mBookDetailObject.author;
//        _endTitleLabel.font = MY_FONT(15);
//        _endTitleLabel.textColor = COLOR_STRING(@"#909090");
//        _endTitleLabel.hidden = NO;
//
//        self.textView.frame = CGRectMake(0, _bgImageView.frame.size.height, _middleView.frame.size.width, _endTitleLabel.frame.origin.y + _endTitleLabel.frame.size.height + 10);
//
//        self.textView.backgroundColor = [UIColor blueColor];
//
//        if ([mBookDetailObject.pageNum integerValue] < 1) {
//            self.nextButton.hidden = YES;
//        }else{
//            self.nextButton.hidden = NO;
//        }
//        self.frontButton.hidden = YES;
//        self.playButton.hidden = YES;
//
//        _myScrollView.contentSize = CGSizeMake(_middleView.frame.size.width,_endTitleLabel.frame.origin.y + _endTitleLabel.frame.size.height);
//    }
//}

-(void)updateBookPageView:(KBookPageObject *)bookPageObject
{
    if (bookPageObject != nil) {
        
        if (self.pageNum == 0) {
            
            self.frontButton.hidden = YES;
            self.frontImgView.hidden = YES;
        }else{
            //绘本页 从0页开始和首页重合的
            if (self.pageNum == [self.mBookDetailObject.pageNum integerValue] - 1) {
                self.nextImgView.hidden = YES;
                self.nextButton.hidden = YES;
            }else{
                self.nextImgView.hidden = NO;
                self.nextButton.hidden = NO;
            }
            
            //显示上一页
            self.frontButton.hidden = NO;
            self.frontImgView.hidden = NO;
        }
        
        //---更新显示内容
        NSString *imageString = [self disposeImageWithUrl:bookPageObject.picUrl WithParameter:@"m_pad,h_690,w_990,color_EAEAEA"];
        NSLog(@"imageString====>%@",imageString);
        [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"bookDetail_imageHoldnew"]];
        
        if ([bookPageObject.voiceUrl isEqualToString:@""] || bookPageObject.voiceUrl.length == 0 || bookPageObject.voiceUrl == nil) {

            self.playImgView.hidden = YES;
            self.playButton.hidden = YES;
            
        }else{
            self.playImgView.hidden = NO;
            self.playButton.hidden = NO;
        }
        
        //封面页
        if (self.pageNum == 0) {
            self.textView.hidden = NO;
            self.bookNameLabel.hidden = NO;
//            self.bookNameLabel.text = [NSString stringWithFormat:@"《%@》",bookPageObject.content];
            self.bookNameLabel.text = [NSString stringWithFormat:@"%@%@%@",@"《",self.mBookDetailObject.bookName,@"》"];
            
            NSString *text = self.mBookDetailObject.reviews;
            if ([text containsString:@"\r\n"]) {
                text = [text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
            }
            _contentLabel.text = text;
            
            NSLog(@"封面内容:%@",text);
            
            [_contentLabel setNumberOfLines:0];
            UIFont *font = MY_FONT(13);
            _contentLabel.font = font;
            CGSize constraint = CGSizeMake(_myScrollView.frame.size.width, 20000.0f);
//            CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//            CGSize constraintSize = [text sizeWithAttributes:@{NSFontAttributeName:font}];
            CGRect constraintSize = [text boundingRectWithSize:constraint options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
            
            CGSize size = CGSizeMake(ceilf(constraintSize.size.width), ceilf(constraintSize.size.height));
            
            CGFloat textHeight = self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height + 10 + size.height + 10 + 20 + 10;
            CGFloat textY = self.backgroundView.frame.origin.y + self.backgroundView.frame.size.height;
            
            CGFloat textMaxH = self.view.frame.size.height - _topView.frame.size.height -textY - bottomView_height - self.bookNameLabel.frame.origin.y -self.bookNameLabel.frame.size.height - 10 - 10 - 20 - 10;
            
            NSLog(@"contentSizeH === %lf\n MaxH===%lf",size.height,textMaxH);
            
            
            if (size.height > textMaxH) {
                textHeight = self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height + 10 + textMaxH + 10 + 20 + 10;
            }
            
//            if ((textY + textHeight) > self.view.frame.size.height - bottomView_height) {
//                textHeight = self.view.frame.size.height - bottomView_height - textY;
//                NSLog(@"view高度:%f\n底部页面y:%f\n底部页面高度%f",self.view.frame.size.height,textY,textHeight);
//            }
            
            self.textView.frame = CGRectMake(0, textY, _middleView.frame.size.width, textHeight);
            _myScrollView.frame = CGRectMake(0, self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height + 10, _middleView.frame.size.width, self.textView.frame.size.height - self.bookNameLabel.frame.origin.y - self.bookNameLabel.frame.size.height - 10);
            _myScrollView.contentSize = CGSizeMake(_middleView.frame.size.width,self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height + 10 + size.height + 20 + 10 + 10);
            
            NSLog(@"ScrollView的Y:%f\nScrollView的frame高:%f",self.bookNameLabel.frame.origin.y + self.bookNameLabel.frame.size.height + 10,self.textView.frame.size.height - self.bookNameLabel.frame.origin.y - self.bookNameLabel.frame.size.height - 10);
            
            NSLog(@"contentSize的高度:%f",size.height + 20 + 10);
            
            [_contentLabel setFrame:CGRectMake(30, 0, self.view.frame.size.width - 30*2, size.height)];
            //作者
            _endTitleLabel.frame = CGRectMake(0, _contentLabel.frame.size.height + _contentLabel.frame.origin.y + 10, _myScrollView.frame.size.width - 30, 20);
            _endTitleLabel.text = self.mBookDetailObject.author;
            _endTitleLabel.hidden = NO;
            
            self.frontImgView.hidden = YES;
            self.frontButton.hidden = YES;
        }else{
            self.bookNameLabel.hidden = YES;
            _endTitleLabel.hidden = YES;
            
            NSString *text = bookPageObject.content;
            
            if (text == nil || [text isEqualToString:@""]) {
                self.textView.hidden = YES;
            }else{
                
                self.textView.hidden = NO;
                
                _contentLabel.text = text;
                [_contentLabel setNumberOfLines:0];
                UIFont *font = [UIFont fontWithName:@"Arial" size:13];
                _contentLabel.font = font;
                CGSize constraint = CGSizeMake(_myScrollView.frame.size.width, 20000.0f);
                CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                
                CGFloat textY = self.backgroundView.frame.origin.y + self.backgroundView.frame.size.height;
                CGFloat textH = size.height + 10 + 30;
                CGFloat textMaxH = self.view.frame.size.height - _topView.frame.size.height - textY - bottomView_height - 30 - 10;
                
                if (size.height > textMaxH) {
                    textH = textMaxH + 10 + 30;
//                    _myScrollView.scrollEnabled = YES;
                }else{
//                    _myScrollView.scrollEnabled = NO;
                }
                
//                if ((textY + textH) > self.view.frame.size.height) {
//                    textH = self.view.frame.size.height - textY;
//                }
                
                self.textView.frame = CGRectMake(0, textY, _middleView.frame.size.width, textH);
                _myScrollView.frame = CGRectMake(0,30, _middleView.frame.size.width, self.textView.frame.size.height - 30);
                _myScrollView.contentSize = CGSizeMake(_middleView.frame.size.width,size.height + 30);
                
                [_contentLabel setFrame:CGRectMake(30, 0, self.view.frame.size.width - 30*2, size.height)];
                
                [_myScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    self.isShow = true;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isShow = false;
    
    [self showBarStyle];
    
    [self play_pause];
    self.playTool = nil;
    self.playButton.selected = NO;
    self.playImgView.image = [UIImage imageNamed:@"bookDetail_play"];
}

- (void)hideBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
//    _middleView.backgroundColor = COLOR_STRING(@"#E9E9E9");
    _middleView.backgroundColor = COLOR_STRING(@"#FFFFFF");

    [self.view addSubview:_middleView];

    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    [self createTopViewChild];
    [self createBottomViewChild];
    [self createMiddleViewChild];
    
}

-(IBAction) buyButtonClick:(id)sender
{
    NSLog(@"===> buyButtonClick <===");
}

-(void) createMiddleViewChild
{
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0, 0, _middleView.frame.size.width, background_height);
//    backgroundView.backgroundColor = COLOR_STRING(@"#F4F4F4");
    backgroundView.backgroundColor = COLOR_STRING(@"#EAEAEA");

    self.backgroundView = backgroundView;
    [_middleView addSubview:backgroundView];
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, backgroundView.frame.size.width, 253)];
    _bgImageView.userInteractionEnabled = YES;
//    _bgImageView.backgroundColor = COLOR_STRING(@"#F4F4F4");
    _bgImageView.backgroundColor = COLOR_STRING(@"#EAEAEA");

    [backgroundView addSubview:_bgImageView];
    
    UIImageView *frontImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (_bgImageView.frame.size.height - 26)*0.5 - 15, 18, 26)];
    frontImgView.backgroundColor = [UIColor clearColor];
    frontImgView.image = [UIImage imageNamed:@"bookDetail_front"];
    frontImgView.hidden = YES;
    self.frontImgView = frontImgView;
    [_bgImageView addSubview:frontImgView];
    
    UIButton *frontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    frontButton.frame = CGRectMake(0, (_bgImageView.frame.size.height - 50)*0.5 - 15, 60, 50);
    frontButton.backgroundColor = [UIColor clearColor];
    [frontButton addTarget:self action:@selector(clickFront:) forControlEvents:UIControlEventTouchUpInside];
    frontButton.hidden = YES; //首次进来隐藏
    self.frontButton = frontButton;
    [_bgImageView addSubview:frontButton];
    
    UIImageView *nextImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgImageView.frame.size.width - 18 - 15, frontImgView.frame.origin.y, 18, 26)];
    nextImgView.image = [UIImage imageNamed:@"bookDetail_next"];
    nextImgView.backgroundColor = [UIColor clearColor];
    self.nextImgView = nextImgView;
    [_bgImageView addSubview:nextImgView];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(_bgImageView.frame.size.width - 60, frontButton.frame.origin.y, 60, 50);
    [nextButton addTarget:self action:@selector(clickNext:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.backgroundColor = [UIColor clearColor];
    self.nextButton = nextButton;
    [_bgImageView addSubview:nextButton];
    
    UIView *textView = [[UIView alloc]init];
    textView.frame = CGRectMake(0, backgroundView.frame.origin.y + backgroundView.frame.size.height, _middleView.frame.size.width, _middleView.frame.size.height - backgroundView.frame.size.height - backgroundView.frame.origin.y);
    textView.backgroundColor = [UIColor whiteColor];
    self.textView = textView;
    [_middleView addSubview:textView];
    
    UIImageView *playImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, backgroundView.frame.size.height - 49*0.5, 49, 49)];
    playImgView.image = [UIImage imageNamed:@"bookDetail_play"];
    playImgView.backgroundColor = [UIColor clearColor];
    self.playImgView = playImgView;
    [_middleView addSubview:playImgView];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(0, backgroundView.frame.size.height - 70*0.5, 80, 70);
//    [playButton setImage:[UIImage imageNamed:@"bookDetail_play"] forState:UIControlStateNormal];
//    [playButton setImage:[UIImage imageNamed:@"bookDetail_pause"] forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(clickPlay:) forControlEvents:UIControlEventTouchUpInside];
    playButton.backgroundColor = [UIColor clearColor];
    self.playButton = playButton;
    [_middleView addSubview:playButton];
    
    UILabel *bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, textView.frame.size.width - 50, 20)];
    bookNameLabel.textColor = COLOR_STRING(@"#444444");
    bookNameLabel.font = MY_FONT(13);
    self.bookNameLabel = bookNameLabel;
    [textView addSubview:bookNameLabel];
    
    _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, bookNameLabel.frame.origin.y + bookNameLabel.frame.size.height + 10, _middleView.frame.size.width, textView.frame.size.height - bookNameLabel.frame.origin.y - bookNameLabel.frame.size.height - 10)];
//    _myScrollView.accessibilityActivationPoint = CGPointMake(100, 100);
    _myScrollView.minimumZoomScale = 0.5;
    _myScrollView.maximumZoomScale = 3;
    _myScrollView.delegate = self;
    [_myScrollView setShowsVerticalScrollIndicator:NO];
    _myScrollView.delaysContentTouches = false;
    [textView addSubview:_myScrollView];
     
    _contentLabel = [[UILabel alloc] init];
    NSString *text = @"";
    _contentLabel.text = text;
    _contentLabel.textColor = COLOR_STRING(@"#666666");
    [_contentLabel setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    //设置字体
    _contentLabel.font = font;
    CGSize constraint = CGSizeMake(_myScrollView.frame.size.width, 20000.0f);
    
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    [_contentLabel setFrame:CGRectMake(30, 0, textView.frame.size.width - 30*2, size.height)];
    [_myScrollView addSubview:_contentLabel];
    
    _endTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentLabel.frame.size.height + _contentLabel.frame.origin.y + 10, textView.frame.size.width - 30, 20)];
    _endTitleLabel.textAlignment = NSTextAlignmentRight;
    _endTitleLabel.font = MY_FONT(12);
    _endTitleLabel.textColor = COLOR_STRING(@"#9B9B9B");
    [_myScrollView addSubview:_endTitleLabel];
    
    textView.frame = CGRectMake(0, backgroundView.frame.origin.y + backgroundView.frame.size.height, _middleView.frame.size.width, _endTitleLabel.frame.origin.y + _endTitleLabel.frame.size.height + 10);
    
    _myScrollView.contentSize = CGSizeMake(textView.frame.size.width,_endTitleLabel.frame.origin.y + _endTitleLabel.frame.size.height);
}

-(void) createBottomViewChild
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    [imageView setBackgroundColor: COLOR_STRING(@"#eaeaea")];
    [_bottomView addSubview:imageView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, (_bottomView.frame.size.height - 47)*0.5, _bottomView.frame.size.width * 0.5, 47)];
    leftView.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:leftView];
    
    _kBookImageView = [[UIImageView alloc] initWithFrame:CGRectMake((leftView.frame.size.width - 21)*0.5, 0, 21, 24)];
    [_kBookImageView setImage:[UIImage imageNamed:@"Kbook_voice"]];
    [leftView addSubview:_kBookImageView];
    
    UILabel *kBookLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _kBookImageView.frame.origin.y + _kBookImageView.frame.size.height + 8, leftView.frame.size.width, 15)];
    kBookLabel.textAlignment = NSTextAlignmentCenter;
    kBookLabel.text = @"绘本录制";
    kBookLabel.font = MY_FONT(13);
    kBookLabel.textColor = COLOR_STRING(@"#9B9B9B");
    [leftView addSubview:kBookLabel];
    
    UIButton *khbButton = [[UIButton alloc] initWithFrame:leftView.bounds];
    [khbButton addTarget:self action:@selector(onKBookButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:khbButton];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(_bottomView.frame.size.width * 0.5, leftView.frame.origin.y, _bottomView.frame.size.width * 0.5, 47)];
    rightView.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:rightView];
    
    _changeImageView = [[UIImageView alloc] initWithFrame: CGRectMake((rightView.frame.size.width - 21)*0.5, 0, 21, 24)];
    [_changeImageView setImage:[UIImage imageNamed:@"Kbook_transfer"]];
    [rightView addSubview:_changeImageView];
    
    UILabel *qiehuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _changeImageView.frame.origin.y + _changeImageView.frame.size.height + 8, rightView.frame.size.width, 15)];
    qiehuanLabel.textAlignment = NSTextAlignmentCenter;
    qiehuanLabel.text = @"选择音源";
    qiehuanLabel.font = MY_FONT(13);
    qiehuanLabel.textColor = COLOR_STRING(@"#9B9B9B");
    [rightView addSubview:qiehuanLabel];
    
    UIButton *qhButton = [[UIButton alloc] initWithFrame:rightView.bounds];
    [qhButton addTarget:self action:@selector(onQHButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:qhButton];
    
}

-(void)clickFront:(UIButton *)sender
{
    [self play_pause];
    self.playButton.selected = NO;
    self.playImgView.image = [UIImage imageNamed:@"bookDetail_play"];
    
    self.pageNum--;
    if (self.pageNum == -1) {
        //显示刚进来的首页页面
        [self onBookDetailService];
    }else{
        [self getKbookPageDataWith:self.pageNum];
    }
}

-(void)clickNext:(UIButton *)sender
{
    [self play_pause];
    self.playButton.selected = NO;
    self.playImgView.image = [UIImage imageNamed:@"bookDetail_play"];
    
    //获取绘本 子页数
    self.pageNum++;
    if (self.pageNum > [self.mBookDetailObject.pageNum integerValue]) {
        self.pageNum = [self.mBookDetailObject.pageNum integerValue];
    }
    
    [self getKbookPageDataWith:self.pageNum];
}

-(void)clickPlay:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        
        self.playImgView.image = [UIImage imageNamed:@"bookDetail_pause"];
        if (self.bookPageObject != nil) {
            
            [MusicPlayTool shareMusicPlay].urlString = self.bookPageObject.voiceUrl;
            [[MusicPlayTool shareMusicPlay] musicPrePlay];
        }
    }else{
        self.playImgView.image = [UIImage imageNamed:@"bookDetail_play"];
        [self play_pause];
    }
}

-(void)play_pause
{
//    if ([MusicPlayTool shareMusicPlay].player.rate == 0) {
//        [[MusicPlayTool shareMusicPlay] musicPlay];
//    }else{
//        [[MusicPlayTool shareMusicPlay] musicPause];
//    }
    [[MusicPlayTool shareMusicPlay] musicPause];
}

-(IBAction) onKBookButtonClick:(id)sender
{
    if(4 == [APP_DELEGATE.snData.type integerValue]){
        //babycare不支持提示
        ScoreRemindView *reminde =[[ScoreRemindView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:@"此设备暂不支持该功能" Info:@"" ImageName:@"bc_DontUse_tip" Block:^{
            
        }];
        [APP_DELEGATE.window addSubview:reminde];
    }else{
        
        NSLog(@"绘本");
        KBookViewController *mKBookViewController = [[KBookViewController alloc] init];
        //给K绘本 传参bookId
        mKBookViewController.bookId = self.mBookDetailObject.mid;
        [APP_DELEGATE.navigationController pushViewController:mKBookViewController animated:YES];
    }
}


-(IBAction) onQHButtonClick:(id)sender
{
    NSLog(@"切换");
    [self onBookVoiceChooseVersion];
}

-(void)onBookVoiceChooseVersion
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"onBookVoiceChooseVersion ==> OnSuccess");
        
        
        BookVoiceChooseVersion *service = (BookVoiceChooseVersion*)httpInterface;
        
        if (service.mVersionListObjects != nil && service.mVersionListObjects.count > 0) {
            
            [self showAlertController: service.mVersionListObjects];
            
        }
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"onBookVoiceChooseVersion ==> OnError");
        [MBProgressHUD showText:@"网络异常,请稍候重试"];
    };
    
    BookVoiceChooseVersion *service = [[BookVoiceChooseVersion alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setBookId:self.mBookDetailObject.mid];
    [service start];
}

- (void) showAlertController:(NSMutableArray *) mVersionListObjects
{
    
    //初始化提示框；
    /**
     preferredStyle参数：
     UIAlertControllerStyleActionSheet,
     UIAlertControllerStyleAlert
     
     *  如果要实现ActionSheet的效果，这里的preferredStyle应该设置为UIAlertControllerStyleActionSheet，而不是UIAlertControllerStyleAlert；
     */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"切换音源" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    
    /**
     *  style参数：
     UIAlertActionStyleDefault,
     UIAlertActionStyleCancel,
     UIAlertActionStyleDestructive（默认按钮文本是红色的）
     *
     */
    //分别按顺序放入每个按钮；
    
    for (int i = 0; i < mVersionListObjects.count;  i ++) {
        VersionListObject *obj = [mVersionListObjects objectAtIndex:i];
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (obj.checked) {
            style = UIAlertActionStyleDefault;
        } else {
            style = UIAlertActionStyleDestructive;
        }
        [alert addAction:[UIAlertAction actionWithTitle:obj.version style:style handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
            NSLog(@"点击了 %@",obj.version);
            [self onKBookVoiceChooseService: obj.value];
        }]];
    }
    
    
//    [alert addAction:[UIAlertAction actionWithTitle:@"体育" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//        NSLog(@"点击了体育");
//    }]];
//
//    [alert addAction:[UIAlertAction actionWithTitle:@"娱乐" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //点击按钮的响应事件；
//        NSLog(@"点击了娱乐");
//    }]];
//
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        NSLog(@"点击了取消");
    }]];
    
    if (self.isShow) {
        //弹出提示框；
        [self presentViewController:alert animated:true completion:nil];
    }
}

-(void)onKBookVoiceChooseService:(NSString *) type
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"onKBookVoiceChooseService ==> OnSuccess");
        
//        BookVoiceChooseVersion *service = (BookVoiceChooseVersion*)httpInterface;
//
//        if (service.mVersionListObjects != nil && service.mVersionListObjects.count > 0) {
//            [self showAlertController: service.mVersionListObjects];
//        }
        [MBProgressHUD showText:@"切换成功"];
        [self play_pause];
        self.playButton.selected = NO;
        self.playImgView.image = [UIImage imageNamed:@"bookDetail_play"];
        
        [self getKbookPageDataWith:self.pageNum];
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"onKBookVoiceChooseService ==> OnError");
        [MBProgressHUD showText:@"切换失败,请重试"];
    };
    
    KBookVoiceChooseService *service = [[KBookVoiceChooseService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setBookId:self.mBookDetailObject.mid
                                        setType:type];
    [service start];
}

#pragma mark - 返回按钮的点击
- (IBAction)backPressed:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}


-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    //[_moveButton setBackgroundColor:[UIColor whiteColor]];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    //[_moveButton setTitle:@"故事" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    //[_moveButton setTitleColor:COLOR_STRING(@"#FFD1C7") forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"绘本预览";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

#pragma mark - 网络相关

-(void)onBookDetailService
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        
        NSLog(@"BookDetailService ==> OnSuccess");
        
        BookDetailService *service = (BookDetailService*)httpInterface;
        
        self.mBookDetailObject = service.mBookDetailObject;
        
        if (service.mBookDetailObject != nil) {
//            [self updateDataView:self.mBookDetailObject];
            
            self.pageNum = 0;
            [self getKbookPageDataWith:self.pageNum];
        }
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"BookDetailService ==> OnError");
    };
    
    BookDetailService *service = [[BookDetailService alloc] init:OnSuccess setOnError:OnError setCid:self.mBooklistObjet.mid];
    [service start];
}

-(void)getKbookPageDataWith:(NSInteger )pageNum
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface, NSString *description){
        
        NSLog(@"KBookPageService ====> OnSuccess");
        
        KBookPageService *pageService = (KBookPageService *)httpInterface;
        self.bookPageObject = pageService.bookPageObject;
        //进入绘本子页面更新UI
        if (self.bookPageObject != nil) {
            [self updateBookPageView:self.bookPageObject];
        }
        
    };
    
    void (^OnError) (NSInteger, NSString *) = ^(NSInteger httpInterface, NSString *description){
        NSLog(@"KBookPageService ====> OnError");
        
    };
    
//    KBookPageService *pageService = [[KBookPageService alloc]init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setBookId:[self.mBooklistObjet.mid integerValue] setPageNum:pageNum setGroupId:[self.mBooklistObjet.groupId integerValue]];
    KBookPageService *pageService = [[KBookPageService alloc]init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token setBookId:[self.mBooklistObjet.mid integerValue] setPageNum:pageNum setGroupId:0];
    [pageService start];
    
    NSLog(@"bookId===%d\n groupId ===%d\n pageNum ===%d",[self.mBooklistObjet.mid integerValue],[self.mBooklistObjet.groupId integerValue],pageNum);
}

#pragma mark - MusicPlayToolDelegate
-(void)endOfPlayAction
{
    self.playImgView.image = [UIImage imageNamed:@"bookDetail_play"];
    self.playButton.selected = NO;
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//OSS处理图片
-(NSString *)disposeImageWithUrl:(NSString *)urlStr WithParameter:(NSString *)parameter
{
    NSString *string;
    if (urlStr != nil && ![urlStr isEqualToString:@""]) {
        string = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,%@",urlStr,parameter];
    }
    
    return string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
