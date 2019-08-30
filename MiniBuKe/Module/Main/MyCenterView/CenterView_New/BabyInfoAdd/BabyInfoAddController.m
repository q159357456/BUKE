//
//  BabyInfoAddController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/28.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "BabyInfoAddController.h"
#import "BabyInfoTapChosenView.h"
#import "UIResponder+Event.h"
#import "CommonUsePackaging.h"
#import "PayModeView.h"
#import "ComboToBuyController.h"
#import "CenterSevice.h"
#import "BabyRobotInfo.h"
#import "MJExtension.h"
#import "UITextView+YLTextView.h"
#import "BKLoginCodeTip.h"
#import "BuyToKnowViewController.h"
@interface BabyInfoAddController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    CGFloat offset;
    CGFloat height;
    NSString * tempText;
}
@property(nonatomic,strong)UIScrollView *scroView;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)BabyInfoTapChosenView * babyInfoTapChosenView;
@property(nonatomic,strong)UITextField  * nikeTextField;
@property(nonatomic,strong)UILabel *sexLabel;
@property(nonatomic,strong)UILabel *brithdayLabel;
@property(nonatomic,strong)UIButton *doneButton;
@property(nonatomic,strong)UIView *babyInfoView;
@property(nonatomic,strong)UITextView *babyInfoTextVew;
//
@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong) UIView *backMaskView;
@property(nonatomic,strong) UIView *alertView;
@property(nonatomic,copy) NSArray *genderArray;
@property(nonatomic,copy) NSString *selectedGender;
@property(nonatomic,copy) NSString *selectedDate;
//
@property(nonatomic,strong)PayModeView *payModeView;
@property(nonatomic,strong)UIImage *baAvatar;
@property(nonatomic,strong)BabyRobotInfo *babyRobotInfo;
@property(nonatomic,strong)NSMutableArray *tagArray;
@property(nonatomic,strong)UIView *coverView;
@end

@implementation BabyInfoAddController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardListen];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyboardListen];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isPayMode==YES) {
        self.titleLabel.text = @"『100+1』绘本套餐";
    }else
    {
        self.titleLabel.text = @"宝贝信息";
    }
    
    [self initSubViews];
    if (self.isPayMode) {
         [self.view addSubview:self.payModeView];
    }
    
    [self createPickerView];
    [self fetchBabyInfo];
   
    // Do any additional setup after loading the view.
}
#pragma mark - 懒加载
-(UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _coverView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
        _coverView.userInteractionEnabled = YES;
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}
-(NSArray *)genderArray
{
    if (!_genderArray) {
        _genderArray = [NSArray arrayWithObjects:@"小王子",@"小公主", nil];
    }
    return _genderArray;
}
-(NSMutableArray *)tagArray
{
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}
-(UIView *)payModeView
{
    if (!_payModeView) {
       
        _payModeView = [[PayModeView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, 30)];
        _payModeView.fistStepLabel.textColor = COLOR_STRING(@"#2F2F2F");
        
    }
    return _payModeView;
}
-(BabyRobotInfo *)babyRobotInfo
{
    if (!_babyRobotInfo) {
        _babyRobotInfo = [[BabyRobotInfo alloc]init];
    }
    return _babyRobotInfo;
}
-(NSString *)selectedGender
{
    if (!_selectedGender) {
        _selectedGender = @"小王子";
    }
    return _selectedGender;
}
-(NSString *)selectedDate
{
    if (!_selectedDate) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        _selectedDate = dateString;
    }
    return _selectedDate;
}
-(void)initSubViews{
    
    self.scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavbarH, SCREEN_WIDTH, SCREEN_HEIGHT - kNavbarH - 60)];
    self.scroView.backgroundColor = [UIColor whiteColor];
    self.scroView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scroView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scroView.frame), SCREEN_WIDTH, 60)];
    bottomView.backgroundColor = COLOR_STRING(@"#F7F9FB");
   
    
    [self.view addSubview:bottomView];
    self.doneButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, 8 , 200, 44)];
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    self.doneButton.enabled = NO;
    [self.doneButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
    self.doneButton.layer.cornerRadius = 22;
    self.doneButton.layer.masksToBounds = YES;
    [self.doneButton addTarget:self  action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.doneButton];
    
    //
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.frame = CGRectMake((SCREEN_WIDTH - SCALE(80))*0.5, 30, SCALE(80), SCALE(80));
    iconImageView.userInteractionEnabled = YES;
    iconImageView.layer.cornerRadius = SCALE(80)/2;
    iconImageView.layer.borderWidth = 0.5;
    iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImageView.layer.masksToBounds = YES;
    self.iconImageView = iconImageView;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"id_image_default boy"]];
    [self.scroView addSubview:self.iconImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoGraph)];
    [self.iconImageView addGestureRecognizer:tap];
    //
    UIImageView *photoImageView = [[UIImageView alloc] init];
    photoImageView.frame = CGRectMake((SCREEN_WIDTH - 35)*0.5 + 25, 42+SCALE(80)-35, 30, 30);
    photoImageView.image = [UIImage imageNamed:@"id_photo_button "];
//    photoImageView.userInteractionEnabled = YES;
    [self.scroView addSubview:photoImageView];
    
    //
    CGFloat startY = CGRectGetMaxY(iconImageView.frame)+10;
    for (NSInteger i=0; i<3; i++) {
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(15,startY+i*50, SCREEN_WIDTH - 30, 50)];
        [self.scroView addSubview:backView];
        if (i!=2) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.size.height-1, backView.frame.size.width, 1)];
            lineView.backgroundColor = COLOR_STRING(@"#E4E4E4");
            [backView addSubview:lineView];
        }

        CGFloat title_w = 80;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,  title_w, 50)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [backView addSubview:titleLabel];
        switch (i) {
            case 0:
            {
                titleLabel.text = @"宝贝昵称";
                self.nikeTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, backView.frame.size.width-title_w, 50)];
                self.nikeTextField.textAlignment = NSTextAlignmentRight;
                [backView addSubview:self.nikeTextField];
                self.nikeTextField.text = @"宝贝";
                self.nikeTextField.textColor = COLOR_STRING(@"#999999");
                self.nikeTextField.font = [UIFont systemFontOfSize:16];
                self.nikeTextField.returnKeyType = UIReturnKeyDone;
                self.nikeTextField.delegate = self;
                [self.nikeTextField addTarget:self
                                       action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
                break;
                
            case 1:
            {
                 titleLabel.text = @"宝贝性别";
                self.sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, backView.frame.size.width-title_w, 50)];
                self.sexLabel.textAlignment = NSTextAlignmentRight;
                [backView addSubview:self.sexLabel];
                self.sexLabel.text =@"小王子";
                self.sexLabel.textColor = COLOR_STRING(@"#999999");
                self.sexLabel.font = [UIFont systemFontOfSize:16];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sexChoose:)];
                self.sexLabel.userInteractionEnabled = YES;
                [self.sexLabel addGestureRecognizer:tap];
                
            }
                break;
                
            case 2:
            {
                titleLabel.text = @"宝贝生日";
                self.brithdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, backView.frame.size.width-title_w, 50)];
                self.brithdayLabel.textAlignment = NSTextAlignmentRight;
                 [backView addSubview:self.brithdayLabel];
                self.brithdayLabel.text =self.selectedDate;
                 self.brithdayLabel.textColor = COLOR_STRING(@"#999999");
                 self.brithdayLabel.font = [UIFont systemFontOfSize:16];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(birthdayChoose:)];
                self.brithdayLabel.userInteractionEnabled = YES;
                [self.brithdayLabel addGestureRecognizer:tap];
            }
                break;
                
        }
        
    }
    //
    UIView * spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, startY + 50*3, SCREEN_WIDTH, 10)];
    spaceView.backgroundColor = COLOR_STRING(@"#F7F9FB");
    [self.scroView addSubview:spaceView];
    //
    UIView *describView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(spaceView.frame), SCREEN_WIDTH, 20+16+5)];
    [self.scroView addSubview:describView];
    UILabel *describLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH, 16)];
    describLabel.font = [UIFont boldSystemFontOfSize:15];
    describLabel.text = @"宝贝喜欢读什么书？你期待宝贝未来成为谁？";
    [describView addSubview:describLabel];
    //
    self.babyInfoTapChosenView = [[BabyInfoTapChosenView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(describView.frame), SCREEN_WIDTH, 200)];
    [self.scroView addSubview:self.babyInfoTapChosenView];
    
    //
    UIView *babyInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.babyInfoTapChosenView.frame), SCREEN_WIDTH, 100)];
    [self.scroView addSubview:babyInfoView];
    self.babyInfoTextVew = [[UITextView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 100)];
    self.babyInfoTextVew.layer.cornerRadius = 10;
    self.babyInfoTextVew.layer.masksToBounds = YES;
    self.babyInfoTextVew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.babyInfoTextVew.layer.borderWidth = 1;
    self.babyInfoTextVew.placeholder = @"请简单写下你对亲子阅读的期望，让小布壳更好地帮助你!";
    self.babyInfoTextVew.placeholdFont = [UIFont systemFontOfSize:14];
    self.babyInfoTextVew.font = [UIFont systemFontOfSize:14];
    [babyInfoView addSubview:self.babyInfoTextVew];
    self.babyInfoTextVew.delegate = self;
    self.babyInfoView =babyInfoView;
    
    //
    self.scroView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(babyInfoView .frame));


}

#pragma mark - 拉取宝贝信息数据
-(void)fetchBabyInfo{
    [MBProgressHUD showMessage:@""];
    [CenterSevice user_fetchBabyInfo:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"fetchBabyInfo:%@",responsed);
//        NSLog(@"error:%@",error);
        if (!error) {
            NSDictionary *dic =(NSDictionary*)responsed;
            self.babyRobotInfo = [BabyRobotInfo parseDataByDictionary:dic[@"data"][@"baby"]];
            if (self.babyRobotInfo.babyImageUrl.length>0) {
                UIImage *palce = self.babyRobotInfo.babyGender==0?[UIImage imageNamed:@"id_image_default boy"]:[UIImage imageNamed:@"baby_default image_girl"];
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.babyRobotInfo.babyImageUrl] placeholderImage:palce];
                
            }else
            {
                self.iconImageView.image =  self.babyRobotInfo.babyGender == 0?[UIImage imageNamed:@"id_image_default boy"]:[UIImage imageNamed:@"baby_default image_girl"];
            }
            self.nikeTextField.text = self.babyRobotInfo.babyNickName.length>0?self.babyRobotInfo.babyNickName:@"宝贝";
            self.sexLabel.text=self.babyRobotInfo.babyGender?@"小公主":@"小王子";
            self.brithdayLabel.text = self.babyRobotInfo.babyBirthday.length?self.babyRobotInfo.babyBirthday:self.selectedDate;
            self.babyInfoTextVew.text = self.babyRobotInfo.superAbility;
            if (self.self.babyRobotInfo.superAbility.length>0) {
                self.babyInfoTextVew.placeholder=@"";
            }
            if (self.babyRobotInfo.babyQuestion.length || self.babyRobotInfo.superAbility.length) {
        
                [_doneButton setBackgroundColor:COLOR_STRING(@"#F6922D")];
                    _doneButton.enabled =YES;
    
            }else
            {
                _doneButton.enabled = NO;
                [_doneButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
            }
            [self fethTapInfo];
           
        }
    }];
    
}
#pragma mark - 生成url
-(void)getUrl{
    
    [MBProgressHUD showMessage:@""];
    [CenterSevice user_uploadBabyAvatar:@[self.baAvatar] CompletionHandler:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUD];
//        NSLog(@"responsed:%@",responsed);
//        NSLog(@"error:%@",error);
        NSDictionary *dic =(NSDictionary*)responsed;
        if (!error) {
            
            self.babyRobotInfo.babyImageUrl = dic[@"data"][@"url"];
            [self upDateBabyInfo];
        }else
        {
            [CommonUsePackaging showSystemHint:dic[@"message"]];
        }
       
    }];
    
}
#pragma mark - 上传宝贝信息数据
-(void)upDateBabyInfo{
    [MBProgressHUD showMessage:@""];
    NSDictionary *params = self.babyRobotInfo.mj_keyValues;
    NSLog(@"params:%@",params);
    [CenterSevice user_updateBabyInfo:params CompletionHandler:^(id responsed, NSError *error) {
        [MBProgressHUD hideHUD];
        if (!error) {
            NSDictionary *dic =(NSDictionary*)responsed;
            if ([dic[@"success"] intValue] == 1) {
                
                [[[BKLoginCodeTip alloc]init] AddTextShowTip:@"保存成功!" and:APP_DELEGATE.window];
                [[NSNotificationCenter defaultCenter]postNotificationName:BabyInfo_HasChanged_Notifaction object:nil];
        
                if (self.isPayMode ==YES) {
                    BuyToKnowViewController *vc = [[BuyToKnowViewController alloc]init];
                    vc.url = BuyNeedToKnow;
                    vc.HaveBotom = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else
                {
                    [self.navigationController popViewControllerAnimated:YES]; self.titleLabel.text = @"『100+1』绘本套餐";
                }
                
            }else
            {
                [CommonUsePackaging showSystemHint:dic[@"message"]];
            }
        }
    }];
    
}

#pragma mark -拉取标签信息
-(void)fethTapInfo{
    [CenterSevice pub_tag_list_type:@"2" CompletionHandler:^(id responsed, NSError *error) {
        
        NSLog(@"responsed:%@",responsed);
        NSLog(@"error:%@",error);
        NSDictionary *dic = (NSDictionary*)responsed;
        if (!error) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic1 in dic[@"data"][@"list"]) {
                
                [array addObject:[dic1 valueForKey:@"tagName"]];
            }
            self.babyInfoTapChosenView.tagsArray = array;
            [self.babyInfoTapChosenView selectTemp:self.babyRobotInfo.babyQuestion];
        }
    }];
}
#pragma mark - UIResponder
-(void)eventName:(NSString *)eventname Params:(id)params
{
    if ([eventname isEqualToString:BabyInfoTapChosenView_Event]) {
        CGFloat h = [params floatValue];
        self.babyInfoTapChosenView.frame =CGRectMake(0, self.babyInfoTapChosenView.frame.origin.y, SCREEN_WIDTH, h);
         self.babyInfoView.frame = CGRectMake(0, CGRectGetMaxY(self.babyInfoTapChosenView.frame), SCREEN_WIDTH, self.babyInfoView.frame.size.height);
        self.scroView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.babyInfoView.frame));
   
    }
    else if ([eventname isEqualToString:BabyInfoTapClick_Event])
    {
        NSString *temp = params;
        if ([self.tagArray containsObject:temp])
        {
            [self.tagArray removeObject:temp];
        }else
        {
            [self.tagArray addObject:temp];
        }
        if (self.tagArray.count || self.babyInfoTextVew.text.length>0) {
            [_doneButton setBackgroundColor:COLOR_STRING(@"#F6922D")];
            _doneButton.enabled =YES;
        }else
        {
            _doneButton.enabled = NO;
            [_doneButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
        }
    }
}

#pragma mark - action
-(void)sexChoose:(UITapGestureRecognizer*)tap{
    
    self.backMaskView.hidden = NO;
    self.datePicker.hidden = YES;
    self.pickerView.hidden = NO;
}
-(void)birthdayChoose:(UITapGestureRecognizer*)tap{
    
    self.backMaskView.hidden = NO;
    self.datePicker.hidden = NO;
    self.pickerView.hidden = YES;
}

-(void)selectSure:(UIButton *)sender
{
    if (self.pickerView.hidden == NO) {
        

        self.sexLabel.text = self.selectedGender;
        if (self.babyRobotInfo.babyImageUrl.length ==0) {
            if (!self.baAvatar) {
                NSInteger sex = [self.selectedGender isEqualToString:@"小王子"]?0:1;
                self.iconImageView.image =  sex == 0?[UIImage imageNamed:@"id_image_default boy"]:[UIImage imageNamed:@"baby_default image_girl"];
            }
            
        }
        NSInteger sex = [self.selectedGender isEqualToString:@"小王子"]?0:1;
        self.babyRobotInfo.babyGender = sex;
  
    }else if (self.datePicker.hidden == NO){
       
        self.brithdayLabel.text = self.selectedDate;
        self.babyRobotInfo.babyBirthday = self.selectedDate;
       
    }
    
    
    self.backMaskView.hidden = YES;
}
-(void)selectCancel:(UIButton *)sender
{
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
-(void)endEdit{
    [self.view endEditing:YES];
//    [self.coverView removeFromSuperview];
    
}
-(void)alertHidden:(UITapGestureRecognizer *)sender
{
    self.backMaskView.hidden = YES;
}
-(void)done:(UIButton*)btn{
      if (self.isPayMode) {
//        [MobClick event:EVENT_Custom_104];
      }
  
        self.babyRobotInfo.babyNickName = self.nikeTextField.text;
        self.babyRobotInfo.babyQuestion = [self.tagArray componentsJoinedByString:@","];
        self.babyRobotInfo.superAbility = self.babyInfoTextVew.text;

        if (!self.baAvatar)
        {
            
           [self upDateBabyInfo];
        }else
        {
           [self getUrl];
            
        }
        
    
    
}
-(void)photoGraph{
    
    [[CommonUsePackaging shareInstance] usePhotoLibOrPhotograph:^(UIImage * image) {
        self.baAvatar = image;
        self.iconImageView.image = image;
//        [self getUrl];
    }];
    
}

#pragma mark - 监听键盘
-(void)addKeyboardListen{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeKeyboardListen{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 键盘监听事件
- (void)keyboardAction:(NSNotification*)sender{
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
     if([sender.name isEqualToString:UIKeyboardWillShowNotification])
    {
        [APP_DELEGATE.window addSubview:self.coverView];
        //获取textView在window上的frame
        CGFloat keyBoardHeight= [value CGRectValue].size.height;
        offset = height - (self.view.frame.size.height - keyBoardHeight);
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[useInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //将视图上移计算好的偏移
        if(offset > 0) {
                
                [UIView animateWithDuration:duration animations:^{
                    self.view.frame = CGRectMake(self.view.frame.origin.x, -(keyBoardHeight-60), self.view.frame.size.width, self.view.frame.size.height);
                }];

           
          
        }
       
    }else{
        [self.coverView removeFromSuperview];
        double duration = [[useInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //视图下沉恢复原状
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
        
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rect=[self.nikeTextField convertRect:self.nikeTextField.frame toView:APP_DELEGATE.window];
    height=rect.origin.y + self.nikeTextField.bounds.size.height;
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textDidChange:(UITextField*)textField{
    //获得长度
    int length = 0;
    for (int i =0; i<textField.text.length; i++) {
        NSString *subStr = [textField.text substringWithRange:NSMakeRange(i, 1)];
        NSInteger bytesCount = [subStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        length += bytesCount>=2?2:1;
       
    }
    if (length<=20) {
        tempText = textField.text;
    }else
    {
        textField.text = tempText;
    }

   
    
    
    
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect rect=[self.babyInfoTextVew convertRect:self.babyInfoTextVew.frame toView:APP_DELEGATE.window];
    
    height=rect.origin.y + self.babyInfoTextVew.bounds.size.height;
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.tagArray.count || self.babyInfoTextVew.text.length>0) {
        [_doneButton setBackgroundColor:COLOR_STRING(@"#F6922D")];
        _doneButton.enabled =YES;
    }else
    {
        _doneButton.enabled = NO;
        [_doneButton setBackgroundColor:COLOR_STRING(@"#D7D7D7")];
    }
}
#pragma mark - copy BabyInfoViewController 代码
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
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
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

@end
