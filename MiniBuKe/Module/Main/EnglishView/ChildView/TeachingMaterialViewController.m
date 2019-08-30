//
//  TeachingMaterialViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/9/17.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "TeachingMaterialViewController.h"
#import "TeachingMaterialCollectionCell.h"
#import "EnglishService.h"
#import "TeachingHeadView.h"
#import "SeriesList_Book_Detail_VC.h"
#import "English_Header.h"
#define bottomView_height 0

@interface TeachingMaterialViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *headview;

@end

@implementation TeachingMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
    [self get_textbook];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    [UIApplication sharedApplication].statusBarStyle =  UIStatusBarStyleDefault;
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
   
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    
}
- (void)showBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)hideBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20 ) collectionViewLayout:layout];
    self.collectionView.delegate =self;
    self.collectionView.dataSource =self;
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TeachingMaterialCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"TeachingMaterialCollectionCell"];
      [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:[TeachingHeadView teaching_headerWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 123)]];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [_topView setBackgroundColor:COLOR_STRING(@"#f1f6fa")];

    [self.view addSubview:_topView];
    [self.view bringSubviewToFront:_topView];
    [self createTopViewChild];

}


#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TeachingMaterialCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TeachingMaterialCollectionCell" forIndexPath:indexPath];
    
    Teaching_Catagory *model = self.dataArray[indexPath.item];
    cell.teaching_Catagory = model;
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Teaching_Catagory *model = self.dataArray[indexPath.item];
    if (!model.teachingId) {
        return;
    }
    [EnglishSettingManager shareInstance].backToWhatPage = BACK_TO_SECOND_PAGE;
    SeriesList_Book_Detail_VC *vc= [[SeriesList_Book_Detail_VC alloc]init];
    [EnglishSettingManager shareInstance].AGE_TO_ALL = NO;
    vc.teachingid = model.teachingId;
    vc.title_text = model.categoryName;
    [APP_DELEGATE.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (SCREEN_WIDTH -4*SCALE(20))/3;
    CGFloat h = w*111.00/101;
    return CGSizeMake(w, h);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(123 + 44 + SCALE(30), SCALE(15), 10, SCALE(15));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return  SCALE(25);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return SCALE(15);
}

#pragma mark - 获取教材
-(void)get_textbook{
    
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface,NSString *description){
        NSLog(@"获取教材 ==> OnSuccess");
        EnglishService *severce = (EnglishService*)httpInterface;
        self.dataArray = severce.dataArray;
        Teaching_Catagory *model = [[Teaching_Catagory alloc]init];
        model.logo = @"mate_more_icon.png";
        [self.dataArray addObject:model];
        [self.collectionView reloadData];
        
    };
    
    void (^OnError) (NSInteger,NSString*) = ^(NSInteger httpInterface,NSString *description)
    {
        NSLog(@"LoginService ==> OnError");
        [MBProgressHUD hideHUD];
        [MBProgressHUD showText:description];
    };
    
    EnglishService *service = [[EnglishService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [service start];
}

-(void)createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 20, 40, 40)];
    //[_moveButton setBackgroundColor:[UIColor whiteColor]];
    [backButton setImage:[UIImage imageNamed:@"identity_navibar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,16,self.view.frame.size.width,48)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"";
    self.titleLabel.font = MY_FONT(19);
    self.titleLabel.textColor = [UIColor darkTextColor];
    [_topView addSubview: self.titleLabel];
}

#pragma mark - scroviewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float y = scrollView.contentOffset.y;
  

//    NSLog(@"scrollView.contentOffset.y===>%f",y);
    float alph = [self alph_change:y];
//    NSLog(@"alph===>%f",alph);
    if (alph == 1) {
        _topView.backgroundColor =  COLOR_STRING(@"#FFF7F9FB");

    }else
    {
        
        _topView.backgroundColor = [UIColor colorWithWhite:1 alpha:alph];
        if (y >=40) {
            self.titleLabel.text = @"教材大全";
             _topView.backgroundColor = [UIColor whiteColor];
        }else
        {
            self.titleLabel.text = @"";
        }
    }




}

//透明度线性变化
-(float)alph_change:(float)contentY{

    return   contentY/40 >=0?  contentY/40:0;

}

-(IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
