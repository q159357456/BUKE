//
//  RemindBabyTapController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/5.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "RemindBabyTapController.h"
#import "RemindBabyTapCollectionCell.h"
#import "MiniBuKe-Swift.h"
#import "CenterSevice.h"
#import "BKLoginCodeTip.h"
#import "MJExtension.h"
@interface RemindBabyTapController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UpdateBabyInfo *updateBabyInfo;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *doneButton;
@property(nonatomic,strong)NSMutableArray *tagData;
@end

@implementation RemindBabyTapController
-(void)setBabyInfo:(id)babyInfo
{
    self.updateBabyInfo = (UpdateBabyInfo*)babyInfo;
}
-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, 16)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"宝贝喜欢读什么书？你期待宝贝未来成为谁?";
        _label.font = [UIFont boldSystemFontOfSize:15];
        
    }
    return _label;
}
-(UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, CGRectGetMaxY(self.collectionView.frame)+15 , 200, 44)];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        //
        _doneButton.enabled = NO;
        [_doneButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
        _doneButton.layer.cornerRadius = 22;
        _doneButton.layer.masksToBounds = YES;
        [_doneButton addTarget:self  action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _doneButton;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(SCALE(150), SCALE(55));
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH-100) collectionViewLayout:layout];
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView addSubview:self.label];
        [_collectionView registerNib:[UINib nibWithNibName:@"RemindBabyTapCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"RemindBabyTapCollectionCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
}
    return _collectionView;
}
#pragma mark - action
-(void)done:(UIButton*)btn{
    self.updateBabyInfo.babyQuestion = [self.tagData componentsJoinedByString:@","];
    if (self.updateBabyInfo.image) {
        
        [self getUrl];
    }else
    {
        
        [self upBabyInfo];
    }
}

#pragma mark - 生成url
-(void)getUrl{

    [MBProgressHUD showMessage:@""];
    [CenterSevice user_uploadBabyAvatar:@[self.updateBabyInfo.image] CompletionHandler:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUD];

        NSDictionary *dic =(NSDictionary*)responsed;
//        NSLog(@"dic===>%@",dic);
        
        if (!error) {
            NSLog(@"dic:%@",dic[@"data"][@"url"]);
            self.updateBabyInfo.babyImageUrl = dic[@"data"][@"url"];
            self.updateBabyInfo.image = nil;
            [self upBabyInfo];
            
        }else
        {
             [[[BKLoginCodeTip alloc]init] AddTextShowTip:dic[@"message"] and:APP_DELEGATE.window];
        }

    }];

}
#pragma mark - 上传宝贝信息数据
-(void)upBabyInfo{
    [MBProgressHUD showMessage:@""];
    NSDictionary *params = self.updateBabyInfo.mj_keyValues;
    [CenterSevice user_uploadBabyInfo:params CompletionHandler:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUD];
        if (!error) {
            NSDictionary *dic =(NSDictionary*)responsed;
            if ([dic[@"success"] intValue] == 1) {
                APP_DELEGATE.mLoginResult.appellativeName = self.updateBabyInfo.relationship;
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"保存成功!" and:APP_DELEGATE.window];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else
            {
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:dic[@"message"] and:APP_DELEGATE.window];
                
            }
        }

    }];
//    [CenterSevice user_updateBabyInfo:params CompletionHandler:^(id responsed, NSError *error) {
//        [MBProgressHUD hideHUD];
//    }];

}
#pragma mark -拉取标签信息
-(void)fethTapInfo{
    [CenterSevice pub_tag_list_type:@"2" CompletionHandler:^(id responsed, NSError *error) {
        
//        NSLog(@"responsed:%@",responsed);
//        NSLog(@"error:%@",error);
        NSDictionary *dic = (NSDictionary*)responsed;
        if (!error) {
            for (NSDictionary *dic1 in dic[@"data"][@"list"]) {
                
                [self.dataArray addObject:[dic1 valueForKey:@"tagName"]];
                [self.collectionView reloadData];
            }
           
        }
    }];
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)tagData
{
    if (!_tagData) {
        _tagData = [NSMutableArray array];
    }
    return _tagData;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RemindBabyTapCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RemindBabyTapCollectionCell" forIndexPath:indexPath];
    cell.label.text = self.dataArray[indexPath.item];
    cell.label.textColor = COLOR_STRING(@"#2F2F2F");
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    cell.backgroundView = view;
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(70, 30, 0, 30);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *temp = self.dataArray[indexPath.item];
    if (self.tagData.count == 5) {
        [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"最多选五个，不要贪多哟~" and:APP_DELEGATE.window];
        return;
    }
    if (![self.tagData containsObject:temp]) {
        [self.tagData addObject:temp];
    }
    
    if (self.tagData.count>0)
    {
        [_doneButton setBackgroundColor:COLOR_STRING(@"#F6922D")];
        _doneButton.enabled =YES;
    }else
    {
         [_doneButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
        _doneButton.enabled =NO;
    }
    UIView *seletedView = [[UIView alloc]init];
    seletedView.backgroundColor = COLOR_STRING(@"#FFF8F3");
    seletedView.layer.cornerRadius = 8;
    seletedView.layer.masksToBounds = YES;
    seletedView.layer.borderColor = COLOR_STRING(@"#FA9A3A").CGColor;
    seletedView.layer.borderWidth = 1;
    RemindBabyTapCollectionCell *cell = (RemindBabyTapCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundView = seletedView;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *temp = self.dataArray[indexPath.item];
    if ([self.tagData containsObject:temp]) {
        [self.tagData removeObject:temp];
    }
    if (self.tagData.count>0)
    {
        [_doneButton setBackgroundColor:COLOR_STRING(@"#F6922D")];
         _doneButton.enabled =YES;
    }else
    {
        [_doneButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
         _doneButton.enabled =NO;
    }
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = COLOR_STRING(@"#F7F9FB");
    view.layer.cornerRadius = 8;
    view.layer.masksToBounds = YES;
    RemindBabyTapCollectionCell *cell = (RemindBabyTapCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundView = view;
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.doneButton];
    [self fethTapInfo];
    // Do any additional setup after loading the view.
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
