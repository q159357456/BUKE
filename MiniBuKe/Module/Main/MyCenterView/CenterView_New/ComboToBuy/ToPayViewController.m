//
//  ToPayViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/29.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "ToPayViewController.h"
#import "BottomBuyView.h"
#import "CenterSevice.h"
#import "PayStyleTableViewCell.h"
#import "DiscouTableViewCell.h"
#import "DeliveryTableViewCell.h"
#import "EditAdressController.h"
#import "BKWKWebViewController.h"
#import <WXApi.h>
#import "CommonUsePackaging.h"
#import "BKLoginCodeTip.h"
#import "BKCommonShowTipCtr.h"
#import "XBKWebViewController.h"
@interface ToPayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isSelectDiscount;
    BOOL _isHadAdress;
}
@property(nonatomic,strong)BottomBuyView *bottomBuyView;
@property(nonatomic,strong)NSString *UserDisId;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)NSDictionary *addressDicData;

@end

@implementation ToPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"收银台";
    [self.view addSubview:self.bottomBuyView];
    [self.view addSubview:self.tableView];
    _isSelectDiscount = YES;
    [self getDefaultAdress];
    [self AgreenMentView];
  

    // Do any additional setup after loading the view.
}
-(void)AgreenMentView{
    
    UILabel *loginTipLabe = [[UILabel alloc]init];
    loginTipLabe.text = @"点击立即购买即代表您已阅读并同意";
    loginTipLabe.textColor = COLOR_STRING(@"#999999");
    loginTipLabe.font = [UIFont systemFontOfSize:11.f];
    loginTipLabe.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:loginTipLabe];
    
    UIButton*agreementBtn = [[UIButton alloc]init];
    [agreementBtn setTitle:@"《服务协议》" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:COLOR_STRING(@"#FA9A3A") forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(agreementBtnClick) forControlEvents:UIControlEventTouchUpInside];
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [self.view addSubview:agreementBtn];
    
    [loginTipLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(11);
        make.left.mas_equalTo(self.view.mas_left).offset((SCREEN_WIDTH-193-68)/2);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
        make.width.mas_equalTo(193);
    }];
    
    
    [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(11);
        make.left.mas_equalTo(loginTipLabe.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-80);
        make.width.mas_equalTo(68);
    }];
}
//获取默认的收货地址
-(void)getDefaultAdress{
    [MBProgressHUD showMessage:@""];
    [CenterSevice pay_address:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUD];
        NSDictionary *dic = (NSDictionary*)responsed;
        if ([dic[@"code"] intValue] != 1) {
            [MBProgressHUD showError:dic[@"msg"]];
            return ;
        }
        if (!error) {
            if (dic[@"data"] == [NSNull null])
            {
                //没有地址
                
                
            }else
            {
                //有地址
                self.addressDicData = dic[@"data"];
                [self.tableView reloadData];
              
            }
        }
       
    }];
    
}

//预支付接口
-(void)preparePay{
    if (!self.addressDicData) {
        [CommonUsePackaging showSystemHint:@"请先填写地址!"];
        return;
    }
    [MBProgressHUD showMessage:@"" toView:self.view];
    [CenterSevice pay_wx_order:@"1" UserDisId:self.UserDisId AndFinish:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *dic = (NSDictionary*)responsed;
        if ([dic[@"code"] intValue] != 1) {
            [MBProgressHUD showError:dic[@"msg"]];
            return ;
        }
        if (!error)
        {
            [self weiXinPayWithDic:dic[@"data"]];
        }else
        {
          
        }
    }];
    
}
- (void)weiXinPayWithDic:(NSDictionary *)wechatPayDic {
    PayReq *req = [[PayReq alloc] init];
    req.openID =WXLOGIN_APPID;
    req.partnerId = @"1513935011";
    req.prepayId = [wechatPayDic objectForKey:@"prepayId"];
    req.package = @"Sign=WXPay";
    req.nonceStr = [wechatPayDic objectForKey:@"nonceStr"];
    req.timeStamp = [[wechatPayDic objectForKey:@"timestamp"] intValue];
    req.sign = [wechatPayDic objectForKey:@"sign"];
    [WXApi sendReq:req];
}

#pragma mark - 懒加载
-(BottomBuyView *)bottomBuyView
{
    if (!_bottomBuyView) {
        
        _bottomBuyView = [[BottomBuyView alloc]init];
        if (self.goodsModel.disCountDTOS.count>0) {
            DisCount *dis = self.goodsModel.disCountDTOS[0];
            self.UserDisId = [NSString stringWithFormat:@"%@",dis.userDisId];
            CGFloat discount = [dis.price floatValue];
            CGFloat shifu = self.goodsModel.goodsPrice.floatValue - discount;
            self.bottomBuyView.label1.text = [NSString stringWithFormat:@"实付:￥%.02f",shifu];
            _bottomBuyView.label2.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
            _bottomBuyView.lineView.hidden=NO;
            [self.bottomBuyView reSizeLineWith];
            
        }else
        {
            _bottomBuyView.label1.text = [NSString stringWithFormat:@"实付:￥%@",self.goodsModel.goodsPrice];
            _bottomBuyView.label2.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
            _bottomBuyView.lineView.hidden=YES;
            [self.bottomBuyView reSizeLineWith];
        }
        [_bottomBuyView.btn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBuyView;
}
-(NSString *)UserDisId
{
    if (!_UserDisId) {
        _UserDisId = @"";
    }
    return _UserDisId;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT-kNavbarH-60) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        [_tableView registerNib:[UINib nibWithNibName:@"PayStyleTableViewCell" bundle:nil] forCellReuseIdentifier:@"PayStyleTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"DiscouTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiscouTableViewCell"];
        [_tableView registerClass:[DeliveryTableViewCell class] forCellReuseIdentifier:@"DeliveryTableViewCell"];
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headView;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
-(UIView *)headView
{
    if (!_headView) {
        
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 112)];
        _headView.backgroundColor = COLOR_STRING(@"#F9F9F9");
        UILabel *label1 = [[UILabel alloc]init];
        UILabel *label2 = [[UILabel alloc]init];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text=@"需要支付";
        label1.font = [UIFont systemFontOfSize:11];
        label1.textColor = COLOR_STRING(@"#999999");
        //
        label2.textAlignment = NSTextAlignmentCenter;
        if (self.goodsModel.disCountDTOS.count>0) {
            DisCount *dis = self.goodsModel.disCountDTOS[0];
            self.UserDisId = [NSString stringWithFormat:@"%@",dis.userDisId];
            CGFloat discount = [dis.price floatValue];
            CGFloat shifu = self.goodsModel.goodsPrice.floatValue - discount;
            label2.text = [NSString stringWithFormat:@"￥%.02f",shifu];
            
        }else
        {
            label2.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
    
        }
       
        label2.font = [UIFont boldSystemFontOfSize:20];
        label2.textColor = COLOR_STRING(@"#2F2F2F");
        [_headView addSubview:label1];
        [_headView addSubview:label2];
        //
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(200, 15));
            make.top.mas_equalTo(_headView.mas_top).offset(30);
        }];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.mas_equalTo(_headView.mas_centerX);
             make.size.mas_equalTo(CGSizeMake(200, 15));
             make.top.mas_equalTo(label1.mas_bottom).offset(10);
        }];
        self.moneyLabel = label2;
        
    }
    return _headView;
}

#pragma mark - action
-(void)pay:(UIButton*)btn{
    
    if (APP_DELEGATE.isWXInstalled)
    {
//        [MobClick event:EVENT_Custom_106];
        [self preparePay];
        
    }else
    {
        [CommonUsePackaging showSystemHint:@"您还未安装微信客户端，请先下载安装"];
    }

}
-(void)backButtonClick
{
    BKCommonShowTipCtr *ctr = [[BKCommonShowTipCtr alloc]init];
    [ctr showWithTitle:@"确定放弃支付吗？" andsubTitle:@"放弃支付后系统不保留订单\n如需购买请再次下单哦~" andLeftBtntitel:@"确认离开" andRightBtnTitle:@"继续支付" andIsTap:NO AndLeftBtnAction:^{
         [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    } AndRightBtnAction:^{
       
    }];
    [ctr startShowTipWithController:self];
    
}
/**跳转用户协议*/
- (void)agreementBtnClick{
   
    XBKWebViewController *mXBKWebViewController = [[XBKWebViewController alloc] init: BuySeveiceAgreenMent];
    [APP_DELEGATE.navigationController pushViewController:mXBKWebViewController animated:YES];
}
#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        
        if (self.UserDisId.length)
        {
            return 2;
        }else
        {
             return 1;
        }
       
    }else
    {
        return 1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0)
            {
                PayStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayStyleTableViewCell"];
                return cell;
                
            }else
            {
                DiscouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscouTableViewCell"];
                if (self.UserDisId.length) {
                    DisCount *count = self.goodsModel.disCountDTOS[0];
                   cell.label.text = [NSString stringWithFormat:@"优惠券 -%@",count.price];
                }
                
                return cell;
            }
        }
            break;
            
        case 1:
        {
            DeliveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryTableViewCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (self.addressDicData)
            {
                cell.adressData = self.addressDicData;
                cell.cellStyle = HAD_Adress;
                
            }else
            {
                 cell.cellStyle = NO_Adress;
            }
            return cell;
        }
            break;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return  50;
        }
            break;
            
        case 1:
        {
           return  100;
        }
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 60;
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"支付方式";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(view.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 17));
            make.left.mas_equalTo(view.mas_left).offset(14);
        }];
        return view;
    }
    return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        if (indexPath.row == 1) {
            _isSelectDiscount = !_isSelectDiscount;
            DiscouTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (_isSelectDiscount)
            {
                cell.selectImageView.image = [UIImage imageNamed:@"yes_icon2"];
                DisCount *dis = self.goodsModel.disCountDTOS[0];
                CGFloat discount = [dis.price floatValue];
                CGFloat shifu = self.goodsModel.goodsPrice.floatValue - discount;
                self.bottomBuyView.label1.text = [NSString stringWithFormat:@"实付:￥%.02f",shifu];
                self.bottomBuyView.label2.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
                self.bottomBuyView.lineView.hidden=NO;
                self.moneyLabel.text = [NSString stringWithFormat:@"￥%.02f",shifu];
                [self.bottomBuyView reSizeLineWith];
                
            }else
            {
                cell.selectImageView.image = [UIImage imageNamed:@"no_select"];
                self.bottomBuyView.label1.text = [NSString stringWithFormat:@"实付:￥%@",self.goodsModel.goodsPrice];
                self.bottomBuyView.label2.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
                self.bottomBuyView.lineView.hidden=YES;
                self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.goodsModel.goodsPrice];
                [self.bottomBuyView reSizeLineWith];
            }
        }
        
    }else
    {
        
        EditAdressController *vc = [[EditAdressController alloc]init];
        NSString *encodeToken = [APP_DELEGATE.mLoginResult.token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
        vc.getAdessData = ^{
            [self getDefaultAdress];
        };
        //http://192.168.0.56:9000/editor.html?
//        NSString * url = [NSString stringWithFormat:@"https://dev-api.xiaobuke.com/template/html/yyh5/purchase/editor.html?token=%@",encodeToken];
        NSString * url = BKAdressEditor;
        vc.url =url;
   
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
