//
//  TeachingClassifyVC.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/20.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingClassifyVC.h"
#import "EnglishDownCollectionCell.h"
#import "ChooseAgeClickView.h"
#import "Teaching_Age_View.h"
#import "TeachingListService.h"
#import "Teaching_Catagory.h"
#import "SeriesList_Book_Detail_VC.h"
#import "BookDetailViewController.h"
#import "English_Header.h"
#import "BooklistObjet.h"
#import <MJRefresh.h>
#import "IntensiveReadingController.h"

BooklistObjet* TeachingClassifGet_objct(TeachingProperties *pro){
    
    BooklistObjet *obj = [[BooklistObjet alloc]init];
    obj.author = pro.author;
    obj.coverPic = pro.coverPic;
    obj.name = pro.name;
    obj.mid = pro.mid;
    return obj;
    
}
#define JianGe SCALE(5)
#define size_w (SCREEN_WIDTH - JianGe*3 -SCALE(18))/3.00
#define size_height size_w * 140.00 / 105.00 + 36.00
@interface TeachingClassifyVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)UILabel *title_label;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)ChooseAgeClickView *ageClickView;
@property(nonatomic,strong)ChooseAgeClickView *topAgeClickView;
@property(nonatomic,strong)Teaching_Age_View *teaching_Age_View;
@property(nonatomic,strong)NSMutableArray *teachingProList;
@property(nonatomic,assign) NSInteger page;

@end

@implementation TeachingClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionview];
    [self.collectionview addSubview:self.headView];
    [self teaching_lsit_TeachingId:self.teachingid AgeId:self.ageid];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideBarStyle];
    
}
-(void)setAgeContent:(NSString *)ageContent
{
    _ageContent = [NSString stringWithFormat:@"%@ %@",self.title_text,ageContent];
}

-(UICollectionView *)collectionview
{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
        [_collectionview registerNib:[UINib nibWithNibName:@"EnglishDownCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"EnglishDownCollectionCell"];
        _collectionview.delegate =self;
        _collectionview.dataSource =self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        
        //下拉加载
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [footer setTitle:MJRefreshStateIdle_Str forState:MJRefreshStateIdle];
        [footer setTitle:MJRefreshStatePulling_Str forState:MJRefreshStatePulling];
        [footer setTitle:MJRefreshStateRefreshing_Str forState:MJRefreshStateRefreshing];
        [footer setTitle:MJRefreshStateWillRefresh_Str forState:MJRefreshStateWillRefresh];
        [footer setTitle:MJRefreshStateNoMoreData_Str forState:MJRefreshStateNoMoreData];
        
        _collectionview.mj_footer = footer;
    }
    return  _collectionview;
}
-(UIView *)headView
{
    if (!_headView) {
        //get_chooseage_viewTitle:@"牛津英语阅读 全部年龄" Frame:CGRectMake(15, 0, 0, 0 )
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
-(UILabel *)title_label
{
    if (!_title_label) {
        
        _title_label =[[UILabel alloc]init];
        _title_label.textAlignment = NSTextAlignmentCenter;
        _title_label.font = [UIFont boldSystemFontOfSize:18];
        _title_label.frame=CGRectMake(SCREEN_WIDTH/2 -100,25,200,30);
        _title_label.text = self.title_text;
    }
    return _title_label;
}
-(NSInteger)page
{
    if (!_page) {
        _page = 1;
    }
    return _page;
}
-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 20, 40, 40)];
        
        [backButton setImage:[UIImage imageNamed:@"identity_navibar_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backButton];
        [_topView addSubview: self.title_label];
        
        
        
        
    }
    return _topView;
}
-(NSMutableArray *)teachingProList
{
    if (!_teachingProList) {
        _teachingProList = [NSMutableArray array];
    }
    return _teachingProList;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showBarStyle];
}

- (void)showBarStyle {
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)hideBarStyle {
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
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
        self.title_label.text = catagory.categoryName;
        if ([self.topView.subviews containsObject:self.topAgeClickView])
        {
            NSLog(@"=======TOP======");
            [self.teaching_Age_View disappear];
            [self.topAgeClickView remakeConstraintsTitle:self.ageContent PositionState:Top_State];
            [self.topAgeClickView packup];
            [self.ageClickView remakeConstraintsTitle:self.ageContent PositionState:Down_State];
        }else
        {
            NSLog(@"=======DOWN======");
            [self.ageClickView remakeConstraintsTitle:self.ageContent PositionState:Down_State];
            [self.ageClickView packup];
        }
        
        if (age.ageId.intValue)
        {
            self.page = 1;
            [self.teachingProList removeAllObjects];
            [self teaching_lsit_TeachingId:catagory.teachingId AgeId:age.ageId];
        }else
        {
            [EnglishSettingManager shareInstance].AGE_TO_ALL = YES;
            SeriesList_Book_Detail_VC *vc= [[SeriesList_Book_Detail_VC alloc]init];
            vc.teachingid = catagory.teachingId;
            vc.title_text = catagory.categoryName;
            [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
        }
        
        
    }
    

}
#pragma mark - data
-(void)teaching_lsit_TeachingId:(NSString*)teachingId AgeId:(NSString*)ageId{
    [MBProgressHUD showMessage:@""];
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取分类 ==> OnSuccess");
        TeachingListService *service =(TeachingListService * )httpInterface;
        [self.teachingProList addObjectsFromArray:service.dataArray];
        [MBProgressHUD hideHUD];
        if (service.dataArray.count<PAGENUM) {
            [self.collectionview.mj_footer endRefreshingWithNoMoreData];
        }else
        {
             [self.collectionview.mj_footer endRefreshing];
        }
      
      [self.collectionview reloadData];
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
        [self.collectionview.mj_footer endRefreshing];
    };
    
    TeachingListService *service = [[TeachingListService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token TeachingId:teachingId AgeId:ageId Page:self.page];
    [service start];
    
}
#pragma mark - private
//下拉加载
-(void)footerRereshing
{
    self.page++;
    [self teaching_lsit_TeachingId:self.teachingid AgeId:self.ageid];

}
-(CAShapeLayer*)get_maskLayerWithBounds:(CGRect)rect{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = rect;
    maskLayer.path = path.CGPath;
    return maskLayer;
    
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

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.teachingProList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EnglishDownCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EnglishDownCollectionCell" forIndexPath:indexPath];
    
    TeachingProperties *model = self.teachingProList[indexPath.row];
    cell.teachingProperties = model;
    cell.imageview.layer.mask = [self get_maskLayerWithBounds:CGRectMake(0, 0, size_w - 11, size_w * 140.00 / 105.00 -SCALE(5))];
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeachingProperties *model = self.teachingProList[indexPath.row];
//    BookDetailViewController *mBookDetailViewController = [[BookDetailViewController alloc] init:TeachingClassifGet_objct(model)];
//    [APP_DELEGATE.navigationController pushViewController:mBookDetailViewController animated:YES];
    
    IntensiveReadingController *vc = [[IntensiveReadingController alloc]init];
    vc.bookid = model.mid;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     return CGSizeMake(size_w, size_height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
     return UIEdgeInsetsMake(50, SCALE(18), 10, JianGe);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return SCALE(15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
     return JianGe;
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
