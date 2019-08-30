//
//  KBookListCell.h
//  MiniBuKe
//
//  Created by chenheng on 2018/6/27.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KBookListCellDelegate<NSObject>

-(void)showBottom:(UIButton *)sender;

-(void)playKbookAudio:(UIButton *)sender;

-(void)kBookAudioPause:(UIButton *)sender;

-(void)isShowAlertView:(UIButton *)sender;

@end

@interface KBookListCell : UITableViewCell

@property(nonatomic,copy) NSString *bookName;
@property(nonatomic,copy) NSString *identity;
@property(nonatomic,copy) NSString *iconUrl;

@property(nonatomic,assign) NSInteger status;//k绘本 录音是否完整 0:不完整  1:完整

@property(nonatomic,weak) id<KBookListCellDelegate> delegate;

@property(nonatomic,strong) UIButton *playButton;
@property(nonatomic,strong) UIButton *indicateButton;
@property(nonatomic,strong) UIView *line;

@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,strong) UIImageView *maskImageView;
@end
