//
//  FOFPlaceholderTextView.m
//
//  Created by FlyOceanFish on 2017/12/18.
//  Copyright © 2017年 FlyOceanFish. All rights reserved.
//

//IB_DESIGNABLE

#import "FOFPlaceholderTextView.h"

@interface FOFPlaceholderTextView()<UITextViewDelegate>
@property (nonatomic,strong) UILabel *placeholderLabel;
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) NSArray *arrayAppleNineInput;//苹果自带九宫格输入导致限制表情符号不能输入的问题
@end

@implementation FOFPlaceholderTextView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    [self private_hideOrShow];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    return YES;
}

 
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    if (self.fofDelegate&&[((NSObject *)self.fofDelegate) respondsToSelector:@selector(placeholderTextView:shouldChangeTextInRange:replacementText:)]) {
        [self.fofDelegate placeholderTextView:self shouldChangeTextInRange:range replacementText:text];
    }
    if (self.solidWord>0) {
        NSAssert(self.text.length>=self.solidWord, @"固定文字大小＜‘solidWord’");
    }
    if (self.solidWord>0&&range.location<self.solidWord) {
        return NO;
    }
    if ([text isEqualToString:@""]) {

        if (self.showCountLabel&&self.text.length) {
            NSAssert(self.maxWord>0, @"请设置文字最多个数!");
            if (![[self.text substringWithRange:range] isEqualToString:@" "]) {
                self.countLabel.text = [NSString stringWithFormat:@"%@/%@",@([self deleSpace:self.text].length-1),@(self.maxWord)];
            }
            
        }
    }else{
        if ([text isEqualToString:@" "]) {
            return YES;
        }
        if (self.restrictEmotion&&![self.arrayAppleNineInput containsObject:text]&&[self emo_containsEmoji:text]) {
            return NO;
        }
        NSInteger count = 0;
        if (self.text.length>range.location) {
            NSString *aText = [self.text stringByReplacingCharactersInRange:range withString:text];
            count = [self deleSpace:aText].length;
        }else{
            NSString *aText = [self deleSpace:self.text];
            count = aText.length+text.length;
        }
        if (count>self.maxWord&&self.maxWord>0) {
            if (self.fofDelegate&&[((NSObject *)self.fofDelegate) respondsToSelector:@selector(placeholderTextViewDidOverMax:)]) {
                [self.fofDelegate placeholderTextViewDidOverMax:self];
            }
            return NO;
        }
        if (self.showCountLabel) {
            NSAssert(self.maxWord>0, @"请设置文字最多个数!");
            self.countLabel.text = [NSString stringWithFormat:@"%@/%@",@(count),@(self.maxWord)];
        }
    }
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (self.fofDelegate&&[((NSObject *)self.fofDelegate) respondsToSelector:@selector(placeholderTextViewDidChange:)]) {
        [self.fofDelegate placeholderTextViewDidChange:self];
    }
    if (self.restrictEmotion&&![self.arrayAppleNineInput containsObject:textView.text]&&[self emo_containsEmoji:textView.text]) {
        textView.text = [self deleEmotion:textView.text];
    }
    [self private_hideOrShow];
}
- (NSString *)deleEmotion:(NSString *)text{
    NSArray *array = [self emo_emojiRanges:text];
    for(NSValue *value in array) {
        text = [text stringByReplacingCharactersInRange:value.rangeValue withString:@""];
    }
    return text;
}
- (NSString *)deleSpace:(NSString *)text{
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]{1,}\\s{1}" options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *result = [reg firstMatchInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length)];
    NSString *str = text;
    if (result) {
        str =[text stringByReplacingCharactersInRange:NSMakeRange(result.range.location+result.range.length-1,1) withString:@""];
        return [self deleSpace:str];
    }
    return str;
}
-(void)setText:(NSString *)text{
    [super setText:text];
    [self private_hideOrShow];
}
- (void)private_hideOrShow{
    if (self.text.length>0) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    float height = [placeholder boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds),MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.placeholderLabel.font} context:nil].size.height;
    self.placeholderLabel.frame = CGRectMake(5,7, CGRectGetWidth(self.bounds), MIN(height, CGRectGetHeight(self.bounds)));
    self.placeholderLabel.text = placeholder;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}
-(void)setShowCountLabel:(BOOL)showCountLabel{
    _showCountLabel = showCountLabel;
    if (showCountLabel) {
        self.countLabel.hidden = NO;
    }else{
        self.countLabel.hidden = YES;
    }
}
-(NSArray *)arrayAppleNineInput{
    if (_arrayAppleNineInput==nil) {
        _arrayAppleNineInput = @[@"➋",@"➌",@"➍",@"➎",@"➏",@"➐",@"➑",@"➒"];
    }
    return _arrayAppleNineInput;
}
-(UILabel *)placeholderLabel{
    if (_placeholderLabel==nil) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0)];
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.4];
        _placeholderLabel.numberOfLines = 0;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}
-(UILabel *)countLabel{
    if (_countLabel==nil) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.bounds)-15, CGRectGetWidth(self.bounds)-5, 15)];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_countLabel];
    }
    return _countLabel;
}

- (BOOL)emo_containsEmoji:(NSString *)text
{
    __block BOOL containsEmoji = NO;
    
    [text enumerateSubstringsInRange:NSMakeRange(0,text.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     containsEmoji = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 containsEmoji = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 containsEmoji = YES;
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 containsEmoji = YES;
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 containsEmoji = YES;
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 containsEmoji = YES;
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 containsEmoji = YES;
             }
         }
         
         if (containsEmoji)
         {
             *stop = YES;
         }
     }];
    
    return containsEmoji;
}
- (NSArray *)emo_emojiRanges:(NSString *)text
{
    __block NSMutableArray *emojiRangesArray = [NSMutableArray new];
    
    [text enumerateSubstringsInRange:NSMakeRange(0,
                                                 [text length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring,
                                       NSRange substringRange,
                                       NSRange enclosingRange,
                                       BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 [emojiRangesArray addObject:[NSValue valueWithRange:substringRange]];
             }
         }
     }];
    
    return emojiRangesArray;
}
@end
