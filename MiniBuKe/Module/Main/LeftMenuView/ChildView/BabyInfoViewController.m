//
//  BabyInfoViewController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/5/3.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BabyInfoViewController.h"
#import "BabyInfoViewCell.h"
#import "BabyRobotInfo.h"
#import "FetchBabyInfoService.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "UploadBabyAvatarService.h"
#import "UpdateBabyInfoService.h"
#import "MBProgressHUD+XBK.h"
#import "MiniBuKe-Swift.h"
#import "English_Header.h"
#define bottomView_height   0
#define tableView_height    180

@interface BabyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *middleView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *saveButton;

@property(nonatomic,strong) UIView *backMaskView;
@property(nonatomic,strong) UIView *alertView;
@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIDatePicker *datePicker;

@property(nonatomic,copy) NSString *filePath;

@property(nonatomic,strong) BabyRobotInfo *babyInfo;

@property(nonatomic,copy) NSArray *genderArray;
@property(nonatomic,copy) NSString *selectedGender;
@property(nonatomic,copy) NSString *selectedDate;

@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *birthday;
@property(nonatomic,copy) NSString *babyIconUrl;

@end

@implementation BabyInfoViewController

-(NSArray *)genderArray
{
    if (!_genderArray) {
        _genderArray = [NSArray arrayWithObjects:@"小王子",@"小公主", nil];
    }
    return _genderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getBabyInfo];
    
    [self initView];
    [self createPickerView];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
//    [MobClick event:EVENT_BABY_INFO_9];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)hideBarStyle {
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView{
    self.view.backgroundColor = COLOR_STRING(@"#FAFAFA");
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 73)];
    [_topView setBackgroundColor:COLOR_STRING(@"#FFFFFF")];
    [self.view addSubview:_topView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomView_height, self.view.frame.size.width, bottomView_height)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bottomView];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.size.height - _bottomView.frame.size.height)];
    _middleView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:_middleView belowSubview:_topView];
    
    NSLog(@" %f == %f",self.view.frame.size.height,self.view.frame.size.width);
    
    [self createTopViewChild];
    [self createMiddleViewChild];
}

-(void) createMiddleViewChild
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, _middleView.frame.size.width, 194);
    bgView.backgroundColor = [UIColor whiteColor];
    [_middleView addSubview:bgView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.frame = CGRectMake((bgView.frame.size.width - 124)*0.5, 36, 124, 124);
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.cornerRadius = 62;
    iconImageView.layer.borderWidth = 0.5;
    iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImageView.layer.masksToBounds = YES;
    self.iconImageView = iconImageView;
    [bgView addSubview:iconImageView];
    if (self.babyInfo.babyImageUrl != nil && self.babyInfo.babyImageUrl.length != 0) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[self.babyInfo.babyImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"userInfo_iconHold"]];
    }else{
        iconImageView.image = [UIImage imageNamed:@"userInfo_iconHold"];
    }
    
    UIImageView *photoImageView = [[UIImageView alloc] init];
    photoImageView.frame = CGRectMake((bgView.frame.size.width - 35)*0.5 + 25, 132, 35, 35);
    photoImageView.image = [UIImage imageNamed:@"userInfo_photo"];
    photoImageView.userInteractionEnabled = YES;
    [bgView addSubview:photoImageView];
    
    UIButton *selectPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectPhotoBtn.frame = CGRectMake((bgView.frame.size.width - 150)*0.5, 27, 150, 150);
    [selectPhotoBtn setBackgroundColor:[UIColor clearColor]];
    [selectPhotoBtn addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectPhotoBtn];
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(16, bgView.frame.size.height - 1, bgView.frame.size.width - 16*2, 1);
    line.backgroundColor = COLOR_STRING(@"#F4F4F4");
    [bgView addSubview:line];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, bgView.frame.origin.y + bgView.frame.size.height, _middleView.frame.size.width, tableView_height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    self.tableView = tableView;
    [_middleView addSubview:tableView];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake((_middleView.frame.size.width - 200)*0.5,tableView.frame.origin.y + tableView.frame.size.height + 23, 200, 46);
    [finishButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateSelected];
    finishButton.layer.cornerRadius = 23.0f;
    finishButton.layer.masksToBounds = YES;
    finishButton.userInteractionEnabled = NO;
    [finishButton addTarget:self action:@selector(clickFinish:) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton = finishButton;
    [_middleView addSubview:finishButton];
}

-(void) createTopViewChild {
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateSelected];
    [backButton.titleLabel setFont:MY_FONT(18)];
    [backButton setAdjustsImageWhenHighlighted:NO];
    
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,25,self.view.frame.size.width,48)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"宝贝信息";
    titleLabel.font = MY_FONT(19);
    titleLabel.textColor = COLOR_STRING(@"#2f2f2f");
    [_topView addSubview: titleLabel];
}

-(void)createPickerView
{
    //遮罩层
    UIView *backMaskView = [[UIView alloc] initWithFrame:self.view.bounds];
    backMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    backMaskView.userInteractionEnabled = YES;
    backMaskView.hidden = YES;
    self.backMaskView = backMaskView;
    [self.view addSubview:backMaskView];
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 256, self.view.frame.size.width, 256)];
    alertView.backgroundColor = [UIColor whiteColor];
//    alertView.hidden = YES;
    self.alertView = alertView;
    [backMaskView addSubview:alertView];
    
    UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 60, 20)];
    cancelLabel.text = @"取消";
    cancelLabel.textColor = COLOR_STRING(@"#FF721C");
    cancelLabel.font = MY_FONT(16);
    [alertView addSubview:cancelLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 100, 40);
    [cancelBtn addTarget:self action:@selector(selectCancel:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelBtn];
    
    UILabel *sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(alertView.frame.size.width - 15 - 60, 20, 60, 20)];
    sureLabel.text = @"确定";
    sureLabel.textAlignment = NSTextAlignmentRight;
    sureLabel.textColor = cancelLabel.textColor;
    sureLabel.font = cancelLabel.font;
    [alertView addSubview:sureLabel];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(alertView.frame.size.width - 100, 0, 100, 40);
    [sureButton addTarget:self action:@selector(selectSure:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:sureButton];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, alertView.frame.size.width, 216)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.pickerView = pickerView;
    [alertView addSubview:pickerView];
    
    __weak typeof(self) weakSelf = self;
    [self.genderArray enumerateObjectsUsingBlock:^(NSString *rowItem, NSUInteger rowIdx, BOOL *stop) {
        if ([weakSelf.selectedGender isEqualToString:rowItem]) {
            [weakSelf.pickerView selectRow:rowIdx inComponent:0 animated:NO];
            *stop = YES;
        }
    }];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, alertView.frame.size.width, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    [datePicker setDate:[NSDate date]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setYear:0];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-30];//前推10年
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [datePicker setMaximumDate:maxDate];
    [datePicker setMinimumDate:minDate];
    
    self.datePicker = datePicker;
    [alertView addSubview:datePicker];
    
    
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertHidden:)];
    [backMaskView addGestureRecognizer:maskTap];
}

-(void)selectCancel:(UIButton *)sender
{
    self.backMaskView.hidden = YES;
}

-(void)selectSure:(UIButton *)sender
{
    if (self.pickerView.hidden == NO) {
        
        if (self.selectedGender == nil || self.selectedGender.length == 0) {
            self.selectedGender = [self.genderArray firstObject];
        }
        
        self.babyInfo.babyGender = [self.selectedGender isEqualToString:@"小王子"] ? 0 : 1;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (self.datePicker.hidden == NO){
        if (self.selectedDate == nil || self.selectedDate.length == 0) {
            
            self.babyInfo.babyBirthday = [self getCurrentDate];
        } else {
            NSLog(@"self.selectedDate====>%@",self.selectedDate);
            self.babyInfo.babyBirthday = [NSString stringWithFormat:@"%@",self.selectedDate];
            NSLog(@"self.babyInfo.babyBirthday====>%@",self.babyInfo.babyBirthday);
        }
        NSLog(@"self.babyInfo.babyBirthday ==> %@",self.babyInfo.babyBirthday);
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (self.iconImageView.image != nil && self.textField.text.length > 0 && self.gender.length > 0 && self.birthday.length > 0) {
        self.saveButton.userInteractionEnabled = YES;
        [self.saveButton setBackgroundColor:COLOR_STRING(@"#FF721C")];
    }
    
    self.backMaskView.hidden = YES;
}

-(void)dateChange:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *selectDate = [formatter stringFromDate:date];
    
    NSLog(@"====>selectDate%@",selectDate);
    self.selectedDate = selectDate;
   
}

-(NSString *)getCurrentDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}

-(void)alertHidden:(UITapGestureRecognizer *)sender
{
    self.backMaskView.hidden = YES;
}

-(void)clickFinish:(UIButton *)sender
{
    
    if (self.iconImageView.image == nil || self.iconImageView.image == [UIImage imageNamed:@"userInfo_iconHold"]) {
        [MBProgressHUD showText:@"请设置头像"];
        
        return;
    }
    
    [self updateBabyInfo];
}

-(void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"babyInfoCell";
    BabyInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BabyInfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.leftString = @"宝宝昵称";
            cell.rightField.hidden = NO;
            if (self.babyInfo.babyNickName != nil && self.babyInfo.babyNickName.length > 0) {
                cell.rightField.text = self.babyInfo.babyNickName;
            }else{
                cell.rightField.text = @"宝贝";
            }
            [cell.rightField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            cell.rightLabel.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.textField = cell.rightField;
            
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeValue:) name:UITextFieldTextDidChangeNotification object:cell.rightField];
            
            break;
        case 1:
            cell.leftString = @"宝宝性别";
            cell.rightField.hidden = YES;
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.babyInfo.babyGender == 0 ? @"小王子":@"小公主";
            self.gender = cell.rightLabel.text;
            break;
        case 2:
            cell.leftString = @"宝宝生日";
            cell.rightField.hidden = YES;
            cell.rightLabel.hidden = NO;
            NSString *birthday = nil;
            if (self.babyInfo.babyBirthday != nil && self.babyInfo.babyBirthday.length > 0) {
                if ([self.babyInfo.babyBirthday containsString:@"-"]) {
                    birthday = [self.babyInfo.babyBirthday stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                }else{
                    birthday = self.babyInfo.babyBirthday;
                }
            }else{
                NSString *currentDay = [self getCurrentDate];
                if ([currentDay containsString:@"-"]) {
                    birthday = [currentDay stringByReplacingOccurrencesOfString:@"-" withString:@"."];
                }else{
                    birthday = currentDay;
                }
            }
            
            cell.rightLabel.text = birthday;
            self.birthday = cell.rightLabel.text;
            break;
//        default:
//            break;
    }
    
    return cell;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        // 没有高亮选择的字
        // 1. 过滤非汉字、字母、数字字符
        self.textField.text = [self filterCharactor:textField.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
        // 2. 截取
        if (self.textField.text.length >= 20) {
            self.textField.text = [self.textField.text substringToIndex:20];
        }
    } else {
        // 有高亮选择的字 不做任何操作
    }
}

// 过滤字符串中的非汉字、字母、数字
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    return result;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.textField resignFirstResponder];
    
    BabyInfoViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.leftString isEqualToString:@"宝宝性别"]) {
        self.backMaskView.hidden = NO;
        self.datePicker.hidden = YES;
        self.pickerView.hidden = NO;
    }else if ([cell.leftString isEqualToString:@"宝宝生日"]){
        self.backMaskView.hidden = NO;
        self.datePicker.hidden = NO;
        self.pickerView.hidden = YES;
    }
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.genderArray.count;
}

#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.genderArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedGender = self.genderArray[row];
}


#pragma mark - 网络相关
-(void)getBabyInfo
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface, NSString *description){
        NSLog(@"FetchBabyInfoService===>OnSuccess");
        
        FetchBabyInfoService *service = (FetchBabyInfoService *)httpInterface;
        NSDictionary *babyDic = service.babyDic;
        if (babyDic != nil) {
            BabyRobotInfo *babyInfo = [BabyRobotInfo parseDataByDictionary:babyDic];
            self.babyInfo = babyInfo;
            
            if (self.babyInfo.babyBirthday == nil) {
                self.babyInfo.babyBirthday = [self getCurrentDate];
            }
            
            if (self.babyInfo.babyNickName == nil) {
                self.babyInfo.babyNickName = @"宝贝";//默认名:小布壳
            }
            
            NSLog(@"sex ===> %ld",self.babyInfo.babyGender);
            
            
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[self.babyInfo.babyImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:self.babyInfo.babyGender?@"baby_default image_girl":@"id_image_default boy"]];
            
            [self.tableView reloadData];
        }
        
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"FetchBabyInfoService===>OnError");
        NSLog(@"FetchBabyInfoService--->%@",description);
    };
    
    FetchBabyInfoService *babyService = [[FetchBabyInfoService alloc] init:OnSuccess setOnError:OnError setUSER_TOKEN:APP_DELEGATE.mLoginResult.token];
    [babyService start];
}
-(BabyRobotInfo *)babyInfo
{
    if (!_babyInfo) {
        _babyInfo = [[BabyRobotInfo alloc]init];
    }
    return _babyInfo;
    
}
-(void)uploadBabyAvatarWithPath:(NSString *)path
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface, NSString *description){
        NSLog(@"UploadBabyAvatarService===>OnSuccess");
        
        UploadBabyAvatarService *service = (UploadBabyAvatarService *)httpInterface;
        NSString *iconUrl = service.ossImgUrl;
//        self.babyIconUrl = iconUrl;
        self.babyInfo.babyImageUrl = iconUrl;
    };
    
    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"UploadBabyAvatarService===>OnError");
        NSLog(@"UploadBabyAvatarService--->%@",description);
    };
    
    UploadBabyAvatarService *avatarService = [[UploadBabyAvatarService alloc] initWithImagePath:path setDeviceId:APP_DELEGATE.mLoginResult.SN setOnSuccess:OnSuccess setOnError:OnError setToken:APP_DELEGATE.mLoginResult.token];
    [avatarService start];
}

-(void)updateBabyInfo
{
    void (^OnSuccess) (id,NSString *) = ^(id httpInterface, NSString *description){
        NSLog(@"UpdateBabyInfoService===>OnSuccess");
        [[NSNotificationCenter defaultCenter]postNotificationName:BabyInfo_HasChanged_Notifaction object:nil];
        [self backButtonClick:nil];
    };

    void (^OnError) (NSInteger,NSString *) = ^(NSInteger httpInterface,NSString *description){
        NSLog(@"UpdateBabyInfoService===>OnError");
        NSLog(@"UpdateBabyInfoService--->%@",description);
    };

    NSString *nickName = self.textField.text;
    NSInteger gender = 0;
    if ([self.gender isEqualToString:@"小王子"]) {
        gender = 0;
    }else{
        gender = 1;
    }

    NSString *birthday = @"";
    if ([self.babyInfo.babyBirthday containsString:@"."]) {
        birthday = [self.babyInfo.babyBirthday stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    }else{
        birthday = self.babyInfo.babyBirthday;
    }
    NSLog(@"birthday ===> %@",birthday);
    NSLog(@"self.babyInfo.babyBirthday ===> %@",self.babyInfo.babyBirthday);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:nickName forKey:@"babyNickName"];

    if (self.babyInfo.babyImageUrl == nil) {
        [params setObject:@"" forKey:@"babyImageUrl"];
    }else{
        [params setObject:self.babyInfo.babyImageUrl forKey:@"babyImageUrl"];
    }
    if (birthday != nil) {
        [params setObject:birthday forKey:@"babyBirthday"];
    }
 
    [params setObject:[NSNumber numberWithInteger:gender] forKey:@"babyGender"];
    
    

    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:params];

    UpdateBabyInfoService *Service = [[UpdateBabyInfoService alloc] initWithOnSuccess:OnSuccess setOnError:OnError setToken:APP_DELEGATE.mLoginResult.token setDictionary:dic];
    [Service start];
}

#pragma mark - 选择头像相关
-(void)selectPhoto:(UIButton *)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf checkVideoStatusWith:imagePickerController];
        
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf checkPhotoStautsWith:imagePickerController];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertVC addAction:cameraAction];
    }
    
    [alertVC addAction:photoAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)checkVideoStatusWith:(UIImagePickerController *)imagePickerController
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        //没有授权
        [self alertCamera];
    }else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)checkPhotoStautsWith:(UIImagePickerController *)imagePickerController
{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusRestricted || photoAuthorStatus == PHAuthorizationStatusDenied) {
        //没有授权
        [self alertPhoto];
    }else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void) alertCamera
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"无法启动相机" message:@"请为小布壳开启相机权限: 请进入手机【设置】>【隐私】>【相机】>小布壳(打开)" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tipAlert addAction:cancelAction];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

-(void)alertPhoto
{
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:nil message:@"请在iPhone的""设置-隐私-照片""选项中,允许访问你的手机相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [tipAlert addAction:cancelAction];
    [self presentViewController:tipAlert animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage; // 原始图片
     * UIImagePickerControllerEditedImage; // 裁剪后图片
     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL; // 媒体的URL
     * UIImagePickerControllerReferenceURL // 原件的URL
     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
     */
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //压缩图片 大小<1M
    UIImage *targetImage = [self imageByScalingAndCroppingForSize:CGSizeMake(124*3, 124*3) withSourceImage:image];
    //保存到沙盒
    [self saveImage:targetImage];
    
    self.iconImageView.image = targetImage;
    
    if (self.filePath != nil || self.filePath.length > 0) {
        [self uploadBabyAvatarWithPath:self.filePath];
    }
    
    if (self.textField.text.length > 0 && self.gender.length > 0 && self.birthday.length > 0) {
        self.saveButton.userInteractionEnabled = YES;
        [self.saveButton setBackgroundColor:COLOR_STRING(@"#FF721C")];
    }

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//压缩图片
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth/ width;
        CGFloat heightFactor = targetHeight/height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else{
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
        
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"image error");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 沙盒相关操作
- (void)saveImage:(UIImage *)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *avatar = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/BabyAvatar"]];
    if (![self isFileExit:avatar]) {
        [self createPath:avatar];
    }
    NSLog(@"avatar--->path:%@",avatar);
    NSString *timeStr = [self getCurrentTime:@"YYYYMMddHHmmss"];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",avatar,timeStr];
    // 保存成功会返回YES
    BOOL result = [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
    if (result == YES) {
        NSLog(@"头像保存成功");
        self.filePath = filePath;
    }
}

-(void)deletePath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isHave = [self isFileExit:path];
    if (!isHave) {
        return;
    }else {
        BOOL dele = [fileManager removeItemAtPath:path error:nil];
        if (dele) {
            NSLog(@"删除照片成功");
        }else{
            NSLog(@"删除照片失败");
        }
    }
}

-(NSString *)getCurrentTime:(NSString*)formatter
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

//检测文件是否存在
-(BOOL)isFileExit:(NSString*)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

-(void)createPath:(NSString*)path
{
    if (![self isFileExit:path]) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString * parentPath = [path stringByDeletingLastPathComponent];
        if ([self isFileExit:parentPath]) {
            NSError * error;
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:path attributes:nil error:&error];
        }else{
            [self createPath:parentPath];
            [self createPath:path];
        }
    }
}

#pragma mark - 监听键盘
-(void)keyboardWasShow:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = [UIScreen mainScreen].bounds.size.height - _topView.frame.size.height - frame.size.height;
    if (height < 255) {
        _middleView.frame = CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height - 30, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.origin.y -_topView.frame.size.height + 30);
        [_middleView layoutIfNeeded];
    }
}

-(void)keyboardWillHidden:(NSNotification *)notification
{
    _middleView.frame = CGRectMake(0, _topView.frame.origin.y + _topView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _topView.frame.origin.y - _topView.frame.size.height);
    [_middleView layoutIfNeeded];
}

-(void)textFieldDidChangeValue:(NSNotification *)notification
{
    UITextField *sender = (UITextField *)[notification object];
    if (sender.text.length != 0) {
        
        if (self.iconImageView.image && self.gender.length > 0 && self.birthday.length > 0) {
            self.saveButton.userInteractionEnabled = YES;
            [self.saveButton setBackgroundColor:COLOR_STRING(@"#FF721C")];
        }
    }else{
        
        self.saveButton.userInteractionEnabled = NO;
        [self.saveButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
}

@end
