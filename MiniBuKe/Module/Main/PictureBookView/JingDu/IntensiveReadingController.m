//
//  IntensiveReadingController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/2.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "IntensiveReadingController.h"
#import "IntensTableHeadView.h"
#import "IntensTableViewHeader.h"
#import "IntensMoreBookViewCell.h"
#import "IntensFootViewCell.h"
#import "InstensiveService.h"
#import "UIResponder+Event.h"
#import "BookDetailViewController.h"
#import "KBookViewController.h"
#import "BooklistObjet.h"
#import "IntentBottomView.h"
BooklistObjet* intensive_get_BooklistObjet(InstensiveDetailModel *pro){
    
    BooklistObjet *obj = [[BooklistObjet alloc]init];
    obj.author = pro.bookName;
    obj.coverPic = pro.cover;
    obj.name = pro.bookName;
    obj.mid = pro.bookId;
    return obj;
    
}
@interface IntensiveReadingController ()<UITableViewDelegate,UITableViewDataSource,HTMTableViewCellDelegate>
{
    CGFloat html_Height;
    BOOL htm5_firstLoad;
}
@property(nonatomic,assign)BOOL isGuid;
@property(nonatomic,strong)NSMutableArray *usefulList;
@property(nonatomic,strong)NSMutableArray *usefulTitleList;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)InstensiveDetailModel *instensiveDetailModel;
@property(nonatomic,strong)IntensTableHeadView *intensTableHeadView;
@property(nonatomic,strong)IntensTableViewHeader *intensTableViewHeader;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIVisualEffectView *visualEffectView;
@property(nonatomic,strong)IntentBottomView *intentBottomView;
@end

@implementation IntensiveReadingController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//
//        statusBar.backgroundColor = [UIColor clearColor];
//    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
    }else
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = [UIColor clearColor];
//    }
   
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.topView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    [self.view addSubview:self.topView];
    [self.view bringSubviewToFront:self.topView];
    [self.view addSubview:self.intentBottomView];
    [self getDetail];
    
    
    
    // Do any additional setup after loading the view.
}
-(IntentBottomView *)intentBottomView
{
    if (!_intentBottomView) {
        _intentBottomView = [IntentBottomView IntenBuyBottomView];
    }
    return _intentBottomView;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[IntensMoreBookViewCell class] forCellReuseIdentifier:@"IntensMoreBookViewCell"];
        [_tableView registerClass:[IntensFootViewCell class] forCellReuseIdentifier:@"IntensFootViewCell"];
        [_tableView registerClass:[HTMTableViewCell class] forCellReuseIdentifier:@"HTMTableViewCell"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.tableHeaderView = self.intensTableHeadView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
-(IntensTableHeadView *)intensTableHeadView
{
    if (!_intensTableHeadView) {
//        _intensTableHeadView = [[IntensTableHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 235 )];
        _intensTableHeadView = [[IntensTableHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 235 + 40 )];
        [_intensTableHeadView addSubview:self.intensTableViewHeader];
    }
    return _intensTableHeadView;
}
-(IntensTableViewHeader *)intensTableViewHeader
{
    if (!_intensTableViewHeader) {
        _intensTableViewHeader = [[IntensTableViewHeader alloc]initWithFrame:CGRectMake(0, self.intensTableHeadView.bounds.size.height - IntensTableViewHeader_Height, SCREEN_WIDTH, IntensTableViewHeader_Height)];
        _intensTableViewHeader.backgroundColor = [UIColor whiteColor];
        _intensTableViewHeader.layer.mask = [self get_maskLayerWithBounds:_intensTableViewHeader.bounds];
        _intensTableViewHeader.layer.masksToBounds = YES;
      
    }
    return _intensTableViewHeader;
}
-(UIVisualEffectView *)visualEffectView
{
    if (!_visualEffectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = _topView.bounds;
        _visualEffectView = effectView;
    }
    return _visualEffectView;
}
-(UIView *)topView
{
    if (!_topView) {
        

        CGFloat statuHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        CGFloat navHeight = 44.f + statuHeight;
 
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, navHeight)];
//        _topView.backgroundColor = [UIColor clearColor];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_topView.bounds.size.width/2 - 100,statuHeight==44?35:30, 200, 20)];
        [_topView addSubview:self.titleLabel];
        self.titleLabel.text = @"绘本详情";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, statuHeight==44?25:18 , 40, 40)];
        [backButton setImage:[UIImage imageNamed:@"therefore_navibar_back "] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backButton];
        
    }
    return _topView;
}

-(void)setInstensiveDetailModel:(InstensiveDetailModel *)instensiveDetailModel
{
    _instensiveDetailModel = instensiveDetailModel;
    if (self.instensiveDetailModel) {
        instensiveDetailModel.author= instensiveDetailModel.author.length?instensiveDetailModel.author:@"";
        instensiveDetailModel.painter = instensiveDetailModel.painter.length?instensiveDetailModel.painter:@"";
        instensiveDetailModel.others = instensiveDetailModel.others.length?instensiveDetailModel.others:@"";
        instensiveDetailModel.publisher = instensiveDetailModel.publisher.length?instensiveDetailModel.publisher:@"";
        instensiveDetailModel.isbn = instensiveDetailModel.isbn.length?instensiveDetailModel.isbn:@"";
        instensiveDetailModel.series = instensiveDetailModel.series.length?instensiveDetailModel.series:@"";
        
        NSArray *infoArray  = @[instensiveDetailModel.author,instensiveDetailModel.painter,instensiveDetailModel.others,instensiveDetailModel.publisher,instensiveDetailModel.isbn,instensiveDetailModel.series];
        NSArray *titleArray = @[@"作者",@"绘者",@"译者",@"出版社",@"ISBN",@"系列名"];
        self.usefulList = [NSMutableArray array];
        self.usefulTitleList = [NSMutableArray array];
        for (NSInteger i = 0; i< infoArray.count; i++) {
            NSString *key = titleArray[i];
            NSString *value = infoArray[i];
            if (value.length) {
                [self.usefulList addObject:value];
                [self.usefulTitleList addObject:key];
            }
            
        }
        self.intensTableHeadView.instensiveDetailModel = self.instensiveDetailModel;
        [self.tableView reloadData];
        
    }
}
#pragma mark - action
-(void)backButtonClick{
    
    [APP_DELEGATE.navigationController popViewControllerAnimated:YES];
}
-(void)eventName:(NSString *)eventname Params:(id)params
{
    if ([eventname isEqualToString:HTML_WebView_Height_Event]) {
//        self.instensiveDetailModel = nil;
        html_Height = [params floatValue];
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:NO];
    }
    
    else if ([eventname isEqualToString:IntensTableViewHeader_Event]){
        
        NSInteger tag = [params integerValue];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        HTMTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        [cell.scroView setContentOffset:CGPointMake(tag*SCREEN_WIDTH, 0) animated:NO];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.html_State = tag;
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:NO];
      
    }
    else if ([eventname isEqualToString:IntensTableHeadView_Event])
    {
       
        BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:intensive_get_BooklistObjet(self.instensiveDetailModel)];
        [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
       
    
    }
    else if ([eventname isEqualToString:HTML_WebView_Intens_Event])
    {
        NSString *bookid = [NSString stringWithFormat:@"%@",params];
        if (bookid.length) {
            IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
            vc.bookid = bookid;
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
       
        
    }else if ([eventname isEqualToString:IntentBottomView_Event]){
        int index = [params intValue];
        if (index == 0)
        {
            if(4 == [APP_DELEGATE.snData.type integerValue]){
                //babycare不支持提示
                ScoreRemindView *reminde =[[ScoreRemindView alloc]initWithFrame:[UIScreen mainScreen].bounds Title:@"此设备暂不支持该功能" Info:@"" ImageName:@"bc_DontUse_tip" Block:^{
                    
                }];
                [APP_DELEGATE.window addSubview:reminde];
            }else{
                
                NSString *bookid = [NSString stringWithFormat:@"%@",self.bookid];
                if (bookid.length>0) {
                    KBookViewController *mKBookViewController = [[KBookViewController alloc] init];
                    //给K绘本 传参bookId
                    mKBookViewController.bookId = bookid;
                    [APP_DELEGATE.navigationController pushViewController:mKBookViewController animated:YES];
                }else
                {
                    [MBProgressHUD showError:@"没有bookid"];
                }
            }
            
        }else
        {

            if (self.instensiveDetailModel.buyUrl.length==0) {
                [MBProgressHUD showError:@"此商品无货!"];
            }
            [[BaiduMobStat defaultStat] logEvent:@"c_bbuy200" eventLabel:@"绘本详情" attributes:@{@"isbn":self.instensiveDetailModel.isbn}];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.instensiveDetailModel.buyUrl]];
            
        }
    }
        
        
}


#pragma mark - data
-(void)getDetail{
    kWeakSelf(weakSelf);
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取分类 ==> OnSuccess");
        InstensiveService *service =(InstensiveService * )httpInterface;

        weakSelf.instensiveDetailModel = service.instensiveDetailModel;
        if ([weakSelf.instensiveDetailModel.hasGuide boolValue]) {
            weakSelf.intensTableViewHeader.intensive_Style = Intensive_Mode;
            weakSelf.html_State = Guide_State;
            weakSelf.isGuid = YES;
        }else
        {
            weakSelf.intensTableViewHeader.intensive_Style = Comme_Mode;
            weakSelf.html_State = Introduction_State;
            weakSelf.isGuid = NO;
        }
        if (weakSelf.instensiveDetailModel.buyUrl.length >0 ) {
            weakSelf.intentBottomView.buyBtn.backgroundColor = COLOR_STRING(@"#F6922D");
            [weakSelf.intentBottomView.buyBtn setImage:[UIImage imageNamed:@"shop_icon"] forState:UIControlStateNormal];
            weakSelf.intentBottomView.buyBtn.enabled = YES;
        }
        weakSelf.topView.backgroundColor = [UIColor clearColor];
        [weakSelf.view addSubview:weakSelf.tableView];
        [weakSelf.view sendSubviewToBack:weakSelf.tableView];
       
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
    };
    
    InstensiveService *service = [[InstensiveService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token Bookid:self.bookid];
    [service start];
    
}

#pragma mark - private
-(CAShapeLayer*)get_maskLayerWithBounds:(CGRect)rect{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = rect;
    maskLayer.path = path.CGPath;
    return maskLayer;
    
}

#pragma mark - scroDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //header悬浮位置
    if (scrollView.contentOffset.y >= 235+40-50-64) {
        [self.intensTableViewHeader removeFromSuperview];
        self.intensTableViewHeader.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
        [self.view addSubview:self.intensTableViewHeader];

    }else{
        [self.intensTableViewHeader removeFromSuperview];
        self.intensTableViewHeader.frame = CGRectMake(0, self.intensTableHeadView.bounds.size.height - IntensTableViewHeader_Height, SCREEN_WIDTH, IntensTableViewHeader_Height);
        [self.intensTableHeadView addSubview:self.intensTableViewHeader];

    }
    //topview毛玻璃
    if (scrollView.contentOffset.y>=20)
    {
        if (![self.topView.subviews containsObject:self.visualEffectView]) {
            [self.topView addSubview:self.visualEffectView];
            [self.topView sendSubviewToBack:self.visualEffectView];
        }
        
        
    }else
    {
        if ([self.topView.subviews containsObject:self.visualEffectView]) {
            [self.visualEffectView removeFromSuperview];
        }
       
    }
    
    if (scrollView.contentOffset.y > 100) {
        
        self.titleLabel.text = [NSString stringWithFormat:@"《%@》",self.instensiveDetailModel.bookName];
    }else
    {
        self.titleLabel.text = @"绘本详情";
    }

}
#pragma mark - HTMTableViewCellDelegate
-(void)scroDidend:(NSInteger)index
{

    self.html_State = index;
    [self.intensTableViewHeader animationTo:index];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:NO];
}

#pragma mark - tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case IntensMoreBookViewCell_Style:
        {
            IntensMoreBookViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntensMoreBookViewCell"];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
//            if (self.instensiveDetailModel) {
//                cell.userfulTitle = self.usefulTitleList;
//                cell.userfulList = self.usefulList;
//            }
            return cell;
        }
            break;
            
        case HTMTableViewCell_Style:
        {
            HTMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTMTableViewCell"];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.isScanningTo =self.isScanningTo;
            cell.html_State = self.html_State;
            cell.isGuide = self.isGuid;
            if (self.instensiveDetailModel) {
                if (self.html_State == Guide_State)
                {
//
                    cell.introduction = self.instensiveDetailModel.guideUrl;

                   

                }else
                {

                    cell.introduction = self.instensiveDetailModel.introductionUrl;
         

                    
                }
                
            }
            return cell;
            
        }
            break;
        case IntensFootViewCell_Style:
        {
            IntensFootViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntensFootViewCell"];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            if (self.instensiveDetailModel) {
                cell.instensiveDetailModel = self.instensiveDetailModel;
            }
            
            return cell;
        }
            break;

    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case IntensMoreBookViewCell_Style:
        {
            return 0;
            
        }
            break;
        case HTMTableViewCell_Style:
        {
            if (html_Height <= 0)
            {
                 return 500;
            }else
            {
                return html_Height;
            }
           
            
        }
            break;
        case IntensFootViewCell_Style:
        {
            return [IntensFootViewCell heightForCellWithObject:self.instensiveDetailModel];
        }
            break;
            
    }
    return 0;
}
-(void)dealloc
{
    NSLog(@"intensive--dealloc");
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
