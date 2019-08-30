//
//  BookListViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/4/11.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BookListViewController.h"
#import "WJScrollerMenuView.h"
#import "BookCategoryObject.h"
#import "LySegmentMenu.h"
#import "BookListChildView.h"

#define kSCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define kSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

@interface BookListViewController ()<LySegmentMenuDelegate>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) WJScrollerMenuView *mWJScrollerMenuView;
@property (nonatomic) CGSize winSize;

@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) BookCategoryObject *mBookCategoryObject;

@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation BookListViewController

//自定义初始化
-(instancetype)init:(NSArray *) dataArray mBookCategoryObject:(BookCategoryObject *) mBookCategoryObject {
    if (self = [super init]) {
//        self.view.backgroundColor = SCreenColorMyGray;
//        self.title = @"搜索";
        //self.dataArray = nil;
        self.dataArray = dataArray;
        self.mBookCategoryObject = mBookCategoryObject;
        NSLog(@"===> instancetype-init <=== %ld",self.dataArray.count);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.winSize = self.view.frame.size;
    
    NSLog(@"====> self.winSize <==== %f = %f",self.winSize.width,self.winSize.height);
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initView];
    
    //    WJScrollerMenuView *vc=[[WJScrollerMenuView alloc]initWithFrame:CGRectMake(0, 64, 320, 50) showArrayButton:NO];
    
//    [self.view addSubview:vc];
    [self updateDataView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)hideBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showBarStyle {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
//    [_topView setBackgroundColor:COLOR_STRING(@"#FF5001")];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];

    [self.view addSubview:_topView];
    
//    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
//    //[_bottomView setBackgroundColor:[UIColor greenColor]];
//    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height)];
    [_middleView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_middleView];
    
    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    //_topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 110);
    
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 73));
//        make.top.equalTo(self.view);
//    }];
//
//    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 40));
//        make.top.equalTo(self.view).with.offset(self.view.frame.size.height - 40);
//        make.bottom.equalTo(self.view);
//    }];
//    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_topView.mas_bottom);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(_bottomView.mas_top);
//        //make.top.equalTo(_topView.mas_height);
//    }];
//    [_middleView setBackgroundColor:COLOR_STRING(@"#F8F8F8")];
    
    [self createTopViewChild];
    
    //[self createBottomViewChild];
    
}

-(void) updateDataView
{
    NSLog(@"====> updateData <==== %f = %f = %i",self.winSize.width,self.winSize.height,self.dataArray.count);
    
    if (self.dataArray != nil && self.dataArray.count > 0) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSMutableArray *tabNameArray = [[NSMutableArray alloc] init];
        
        for(int i = 0;i < self.dataArray.count;i++){
            
            BookCategoryObject *mBookCategoryObject = [self.dataArray objectAtIndex: i];
            
            BookListChildView *mBookListChildView = [[BookListChildView alloc] initWithFrame:CGRectMake(0, 0, self.winSize.width, self.winSize.height - 73 - HeaderToolBar_Height) setBookCategoryObject:mBookCategoryObject];
            
            [tempArray addObject:mBookListChildView];
            
            BookCategoryObject *object = (BookCategoryObject *)[self.dataArray objectAtIndex:i];
            [tabNameArray addObject:object.categoryName];
        }
        
        CGRect Rect = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height - 73);
        
        //NSLog(@" sss ===> %i <=== %i",tabNameArray.count,tempArray.count);
        LySegmentMenu *LyMenu = [[LySegmentMenu alloc] initWithFrame:Rect ControllerViewArray:tempArray TitleArray:tabNameArray  MaxShowTitleNum:3];
        LyMenu.delegate = self;
        [self.middleView addSubview:LyMenu];
    } else {
        BookListChildView *mBookListChildView = [[BookListChildView alloc] initWithFrame:CGRectMake(0, 0, self.winSize.width, self.winSize.height - 73) setBookCategoryObject:self.mBookCategoryObject];
        
        [self.middleView addSubview:mBookListChildView];
    }
}

-(void)LySegmentMenuCurrentView:(UIView *)currentView didSelectItemWithIndex:(NSInteger)index
{
    NSLog(@"currentView:%@ Index:%ld",currentView,index);
}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];

    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.mBookCategoryObject.categoryName;
    self.titleLabel.font = MY_FONT(19);
    self.titleLabel.textColor = COLOR_STRING(@"#2F2F2F");
    [_topView addSubview: self.titleLabel];
}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
