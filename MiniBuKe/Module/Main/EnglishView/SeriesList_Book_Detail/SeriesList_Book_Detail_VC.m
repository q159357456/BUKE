//
//  SeriesList_Book_Detail_VC.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/18.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "SeriesList_Book_Detail_VC.h"
#import "Teaching_Age_View.h"
#import "SeriesChangeView.h"
#import "SeriesBookCoverCell.h"
#import "PropertiesaTbleViewCell.h"
#import "HTMTableViewCell.h"
#import "TeachingDetailService.h"
#import "ChooseAgeClickView.h"
#import "TeachingListService.h"
#import "TeachingClassifyVC.h"
#import "BooklistObjet.h"
#import "BookDetailViewController.h"
#import "SeriesBookCoverNoneCell.h"
#import "IntroductionListCell.h"
#import "English_Header.h"
#import <MJRefresh.h>
#import "IntensiveReadingController.h"

BooklistObjet* TeachingGetBook_objct(TeachingProperties *pro){
    
    BooklistObjet *obj = [[BooklistObjet alloc]init];
    obj.author = pro.author;
    obj.coverPic = pro.coverPic;
    obj.name = pro.name;
    obj.mid = pro.mid;
    return obj;
    
}
@interface SeriesList_Book_Detail_VC () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)Teaching_Age_View *teaching_Age_View;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UILabel *title_label;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)TeachingDetail *teaching_detail;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)ChooseAgeClickView *ageClickView;
@property(nonatomic,strong)ChooseAgeClickView *topAgeClickView;
@property(nonatomic,strong)SeriesChangeView *seriesChangeView;
@property(nonatomic,strong)NSMutableArray *teachingProList;
@property(nonatomic,assign)Teaching_State bottomState;
@property(nonatomic,copy)NSString *ageContent;
@property(nonatomic,assign)CGFloat webViewScro_ContentHeight;
@property(nonatomic,assign)CGFloat IntroductionListCell_Height;
@property(nonatomic,assign)BOOL has_Reload;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)MJRefreshBackNormalFooter *footer;
@end

@implementation SeriesList_Book_Detail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([EnglishSettingManager shareInstance].AGE_TO_ALL) {
        
        self.bottomState = Atalogue_State;
        [self teaching_lsit_TeachingId:self.teachingid AgeId:@"0"];
    }else
    {
        
        self.bottomState = Introduce_State;
        
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.ageContent = @"全部年龄";
    self.tableView.tableFooterView  = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
  
    if (self.teachingid) {
        
        [self teaching_data_TeachingId:self.teachingid];
    }
    
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)showBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)hideBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark 懒加载
-(SeriesChangeView *)seriesChangeView
{
    if (!_seriesChangeView) {
        _seriesChangeView = [SeriesChangeView sectionView];
    }
    return _seriesChangeView;
}
-(UIView *)headView
{
    if (!_headView) {
        _headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
        self.ageClickView = [ChooseAgeClickView get_chooseage_viewTitle:self.ageContent Font:[UIFont boldSystemFontOfSize:12] Frame:CGRectMake(15, 0, 0, 0 )];
        self.ageClickView.positionState = Down_State;
        UIView *top = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        top.backgroundColor = COLOR_STRING(@"#EAEAEA");
        [_headView addSubview:top];
        [_headView addSubview:self.ageClickView];
        
    }
    return _headView;
}
-(NSMutableArray *)teachingProList
{
    if (!_teachingProList) {
        _teachingProList = [NSMutableArray array];
    }
    return _teachingProList;
}
-(CGFloat)webViewScro_ContentHeight
{
    if (!_webViewScro_ContentHeight) {
        _webViewScro_ContentHeight = 500;
    }
    return _webViewScro_ContentHeight;
}
-(MJRefreshBackNormalFooter *)footer
{
    if (!_footer) {
        //下拉加载
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [footer setTitle:MJRefreshStateIdle_Str forState:MJRefreshStateIdle];
        [footer setTitle:MJRefreshStatePulling_Str forState:MJRefreshStatePulling];
        [footer setTitle:MJRefreshStateRefreshing_Str forState:MJRefreshStateRefreshing];
        [footer setTitle:MJRefreshStateWillRefresh_Str forState:MJRefreshStateWillRefresh];
        [footer setTitle:MJRefreshStateNoMoreData_Str forState:MJRefreshStateNoMoreData];
        _footer = footer;
    }
    return _footer;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        [_tableView registerClass:[HTMTableViewCell class] forCellReuseIdentifier:@"HTMTableViewCell"];
         [_tableView registerClass:[IntroductionListCell class] forCellReuseIdentifier:@"IntroductionListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SeriesBookCoverCell" bundle:nil] forCellReuseIdentifier:@"SeriesBookCoverCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"PropertiesaTbleViewCell" bundle:nil] forCellReuseIdentifier:@"PropertiesaTbleViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"SeriesBookCoverNoneCell" bundle:nil] forCellReuseIdentifier:@"SeriesBookCoverNoneCell"];
        _tableView.tableHeaderView = self.headView;
   

    }
    return _tableView;
}

-(NSInteger)page
{
    if (!_page) {
        _page = 1;
    }
    return _page;
}
-(UILabel *)title_label
{
    if (!_title_label) {
   
        _title_label =[[UILabel alloc]init];
        _title_label.textAlignment = NSTextAlignmentCenter;
        _title_label.font = [UIFont boldSystemFontOfSize:18];
        _title_label.frame=CGRectMake(SCREEN_WIDTH/2 -100,kStatusBarH==44?32:25,200,30);
        _title_label.text = self.title_text;
    }
    return _title_label;
}

-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavbarH)];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, kStatusBarH==44?25:18 , 40, 40)];
      
        [backButton setImage:[UIImage imageNamed:@"identity_navibar_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backButton];
        [_topView addSubview: self.title_label];

        
        
     
    }
    return _topView;
}
-(void)setAgeContent:(NSString *)ageContent
{
    _ageContent = [NSString stringWithFormat:@"%@ %@",self.title_text,ageContent];
}


#pragma mark - UIResponder
-(void)eventName:(NSString *)eventname Params:(id)params
{
    if ([eventname isEqualToString:ChooseAgeClickView_Event])
    {
        ChooseAgeClickView *view = (ChooseAgeClickView*)params;
        if (view == self.ageClickView)
        {
            
         [self show_teaching_age_Frame:CGRectMake(0, 105, SCREEN_WIDTH, SCREEN_HEIGHT-105)];
            
        }else
        {
            
         [self show_teaching_age_Frame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        }
        
        
        
    }else if ([eventname isEqualToString:SeriesChangeView_Event])
    {
        
        Teaching_State state = [params intValue];
        self.bottomState = state;
        if (state == Introduce_State)
        {
            
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:NO];
            self.tableView.mj_footer = nil;
            
        }else
        {
            
            self.tableView.mj_footer = self.footer;
            [self teaching_lsit_TeachingId:self.teachingid AgeId:@"0"];
            
        }
    }else if ([eventname isEqualToString:TeachingAgeView_Event]){
        if (params == nil ) {
            [self.teaching_Age_View disappear];
            if ([self.topView.subviews containsObject:self.topAgeClickView])
            {
                [self.topAgeClickView packup];

            }else
            {
                 [self.ageClickView packup];
            }
            return;
        }
         NSDictionary *dic = (NSDictionary*)params;
         Teaching_Catagory * catagory = dic[@"Teaching_Catagory"];
         TeachingAge * age = dic[@"TeachingAge"];
         self.title_text = catagory.categoryName;
         self.ageContent = age.age;
        
        if ([self.topView.subviews containsObject:self.topAgeClickView])
        {
            NSLog(@"=======TOP======");
           [self.teaching_Age_View disappear];
            [self.topAgeClickView remakeConstraintsTitle:self.ageContent PositionState:Top_State];
            [self.topAgeClickView packup];
            
        }else
        {
             NSLog(@"=======DOWN======");
            [self.teaching_Age_View disappear];
            [self.ageClickView remakeConstraintsTitle:self.ageContent PositionState:Down_State];
            [self.ageClickView packup];
        }
        
        if (age.ageId.intValue || !catagory.teachingId.intValue)
        {
            TeachingClassifyVC *vc= [[TeachingClassifyVC alloc]init];
            vc.teachingid = catagory.teachingId;
            vc.title_text = catagory.categoryName;
            vc.ageid = age.ageId;
            vc.ageContent = age.age;;
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }else
        {
            [EnglishSettingManager shareInstance].AGE_TO_ALL = YES;
            SeriesList_Book_Detail_VC *vc= [[SeriesList_Book_Detail_VC alloc]init];
            vc.teachingid = catagory.teachingId;
            vc.title_text = catagory.categoryName;
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
        
        
    }else if ([eventname isEqualToString:PropertiesaTbleViewCell_Event]){
        
        
        TeachingProperties *model = (TeachingProperties*)params;
//        BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:TeachingGetBook_objct(model)];
//        [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
        
        IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
        vc.bookid = model.mid;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        
    }else if ([eventname isEqualToString:IntroductionListCell_Height_Event]){
        
        self.IntroductionListCell_Height = [params floatValue];
        if (!_has_Reload) {
            
            self.has_Reload = YES;
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:NO];
        }
        
    }else if ([eventname isEqualToString:SeriesBookCoverCell_Event]){
        
        Teaching_Catagory *model =(Teaching_Catagory*)params;
        SeriesList_Book_Detail_VC *vc= [[SeriesList_Book_Detail_VC alloc]init];
        vc.teachingid = model.teachingId;
        vc.title_text = model.categoryName;
        [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
    
}


#pragma mark - data
-(void)teaching_data_TeachingId:(NSString*)teachingId{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取分类 ==> OnSuccess");
        TeachingDetailService *service =(TeachingDetailService * )httpInterface;
        self.teaching_detail = service.teaching_detail;
        [self.tableView reloadData];
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
    };
    
    TeachingDetailService *service = [[TeachingDetailService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token TeachingId:teachingId];
    [service start];
    
}

-(void)teaching_lsit_TeachingId:(NSString*)teachingId AgeId:(NSString*)ageId{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取分类 ==> OnSuccess");
        TeachingListService *service =(TeachingListService * )httpInterface;
         [self.teachingProList addObjectsFromArray:service.dataArray];
     
        
        if (service.dataArray.count<PAGENUM) {
            [self.footer endRefreshingWithNoMoreData];
        }else
        {
            [self.footer endRefreshing];
        }
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:NO];
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
        [self.footer endRefreshing];
    };
    
    TeachingListService *service = [[TeachingListService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token TeachingId:teachingId AgeId:ageId Page:self.page];
    [service start];
    
}

#pragma mark - action
-(void)backButtonClick:(UIButton*)btn{
    if ([EnglishSettingManager shareInstance].backToWhatPage == BACK_TO_FIST_PAGE)
    {
         [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    }else
    {
          [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }
}
//下拉加载
-(void)footerRereshing
{
    self.page++;
    [self teaching_lsit_TeachingId:self.teachingid AgeId:@"0"];
    
}
-(void)show_teaching_age_Frame:(CGRect)frame{
  
        
    
    if ([self.view.subviews containsObject:self.teaching_Age_View]) {
        [self.teaching_Age_View disappear];
    }else
    {
        if (self.teaching_Age_View)
        {
            self.teaching_Age_View.frame =frame;
            [self.view addSubview:self.teaching_Age_View];
            [self.teaching_Age_View show];
        }else
        {
            _teaching_Age_View = [[Teaching_Age_View alloc]initWithFrame:frame];
             _teaching_Age_View.teachingid = self.teachingid;
             [self.view addSubview:self.teaching_Age_View];
        }
       
    }
    
}

#pragma mark - scroviewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 32)
    {
      
        if (![self.topView.subviews containsObject:self.topAgeClickView]) {
            
            [self.title_label removeFromSuperview];
            if (!self.topAgeClickView) {
                self.topAgeClickView = [ChooseAgeClickView get_chooseage_viewTitle:self.ageContent Font:[UIFont boldSystemFontOfSize:15] Frame:CGRectZero];
                self.topAgeClickView.positionState = Top_State;
                self.topAgeClickView.center = CGPointMake(self.topView.center.x, self.topView.center.y+5);
                 self.topAgeClickView.layer.borderColor = [UIColor clearColor].CGColor;
            }else
            {
                [self.topAgeClickView remakeConstraintsTitle:self.ageContent PositionState:Top_State];
            }
            [self.topView addSubview:self.topAgeClickView];
            
        }
        
        
        

    }else
    {
        if ([self.topView.subviews containsObject:self.topAgeClickView]) {
        
            [self.topAgeClickView removeFromSuperview];
            [self.topView addSubview:self.title_label];
        }
      
       
        
    }
    
    
}


#pragma mark - table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
          if (self.teaching_detail.otherTeachingList.count>0)
          {
              SeriesBookCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeriesBookCoverCell"];
              
              cell.teaching_detail = self.teaching_detail;
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              return cell;
              
          }else
          {

             SeriesBookCoverNoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeriesBookCoverNoneCell"];
              
              cell.teaching_detail = self.teaching_detail;
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              return cell;
          }
    
        
    }else
    {
        if (self.bottomState == Introduce_State)
        {

            IntroductionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntroductionListCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.teaching_detail.introductionList.count) {
                 cell.introductionList = self.teaching_detail.introductionList;
            }
           
            return cell;
            
        }else
        {
            PropertiesaTbleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertiesaTbleViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.property_list  = self.teachingProList;
            return cell;

            
            return nil;
            
        }
       
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.teaching_detail.otherTeachingList.count>0) {
            return SCALE(239);
        }else
        {
            return SCALE(163);
        }
        
    }
    if (self.bottomState == Introduce_State) {
          return self.IntroductionListCell_Height;
    }else
    {
        NSInteger line = ceil(self.teachingProList.count  / 3.00);
        
//        NSLog(@"line=====>%ld",line);
        CGFloat temp = Property_Size_Height;
        return line * temp + (line - 1) * SCALE(15) +20 ;
    }
  
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        
        
        return self.seriesChangeView;

    }
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return Section_Height;

    }
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
