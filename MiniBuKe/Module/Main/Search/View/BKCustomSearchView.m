//
//  BKCustomSearchView.m
//  MiniBuKe
//
//  Created by chenheng on 2019/1/8.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "BKCustomSearchView.h"
#import "BKSearchTextField.h"

@interface BKCustomSearchView()<UITextFieldDelegate>

@property(nonatomic, strong) BKSearchTextField *searchInputText;

@end

@implementation BKCustomSearchView

- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = COLOR_STRING(@"#F7F7F7");
    self.layer.cornerRadius = 16.f;
    self.clipsToBounds = YES;
    
    self.searchInputText = [[BKSearchTextField alloc]init];
    [_searchInputText setKeyboardType:UIKeyboardTypeDefault];
    [_searchInputText setFont:[UIFont systemFontOfSize:13.f]];
    [_searchInputText setPlaceholder:@"搜索绘本、英语"];
    _searchInputText.tintColor = COLOR_STRING(@"#FA9A3A");
    _searchInputText.returnKeyType = UIReturnKeySearch;
    UIImageView *leftimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
    leftimage.image=[UIImage imageNamed:@"home_search_icon"];
    _searchInputText.leftView=leftimage;
    _searchInputText.leftViewMode=UITextFieldViewModeAlways;
    _searchInputText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchInputText.delegate = self;

    _searchInputText.clearButtonMode = UITextFieldViewModeAlways;
    [self addSubview:_searchInputText];
    
    [self addConstraints];
    
    [self.searchInputText addTarget:self action:@selector(textDidChangeBegin:) forControlEvents:UIControlEventEditingChanged];
}

- (void)addConstraints{
    [self.searchInputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(150.f+40+20);
        make.height.mas_equalTo(32.f);
        make.centerX.mas_equalTo(self.mas_centerX).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)changeBecomeFirstResponder{
    if (![self.searchInputText isFirstResponder]) {
        [self.searchInputText becomeFirstResponder];
    }
}
- (void)changeResignFirstResponder{
    if ([self.searchInputText isFirstResponder]) {
        
        [self.searchInputText resignFirstResponder];
    }
}

- (void)changeAnimationUI{

    [self.searchInputText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
    }];
}

#pragma mark - textFiled Action

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self changeResignFirstResponder];
    //去除字符串两端空格
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(SearchDoneWithText:)]){
            [self.delegate SearchDoneWithText:str];
        }
    }
    
    return YES;
}

-(void)textDidChangeBegin:(UITextField*)textField{
    //去除字符串两端空格
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(self.delegate && [self.delegate respondsToSelector:@selector(SearchFiledTextChange:)]){
        [self.delegate SearchFiledTextChange:str];
    }
}
- (void)changeTheTextWithStr:(NSString*)str{
    self.searchInputText.text = str;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
