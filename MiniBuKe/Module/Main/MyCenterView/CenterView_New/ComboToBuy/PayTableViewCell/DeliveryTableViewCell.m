//
//  DeliveryTableViewCell.m
//  MiniBuKe
//
//  Created by chenheng on 2018/11/30.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "DeliveryTableViewCell.h"

@implementation DeliveryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *spaceView1 = [[UIView alloc]init];
        UIImageView *spaceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_line"]];
        UIView *spaceView2 = [[UIView alloc]init];
        [self addSubview:spaceView1];
        spaceView1.backgroundColor = COLOR_STRING(@"#F9F9F9");
        spaceView2.backgroundColor = COLOR_STRING(@"#F9F9F9");
        [self addSubview:spaceView2];
        [self addSubview:spaceImageView];
        [self addSubview:self.imageview];
        [self addSubview:self.label];
        [self addSubview:self.phoneLabel];
        [self addSubview:self.adressLabel];
        [spaceView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10 ));
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
        }];
        [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 19 ));
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            
        }];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 30));
            make.left.mas_equalTo(self.imageview.mas_right).offset(05);
            make.centerY.mas_equalTo(self.mas_centerY);
            
        }];
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 13 ));
            make.left.mas_equalTo(self.imageview.mas_right).offset(5);
            make.bottom.mas_equalTo(self.mas_centerY).offset(-5);
            
        }];
        [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 15));
            make.left.mas_equalTo(self.imageview.mas_right).offset(5);
            make.top.mas_equalTo(self.mas_centerY).offset(5);
        }];
        
        [spaceView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10 ));
            make.left.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        [spaceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 5 ));
            make.left.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(spaceView2.mas_top);
        }];
    }
    return self;
}
-(void)setCellStyle:(CellStyle)cellStyle
{
    _cellStyle = cellStyle;
    if (cellStyle == HAD_Adress)
    {
        self.label.hidden  =YES;
        self.phoneLabel.hidden =NO;
        self.adressLabel.hidden =NO;
//        self.phoneLabel.text = [NSString stringWithFormat:@"%@",self.adressData[@"userPhone"]];
        self.adressLabel.text = [NSString stringWithFormat:@"%@%@",self.adressData[@"provinceAndCity"],self.adressData[@"addressContext"]];
        self.phoneLabel.attributedText = [self getAttributes:[NSString stringWithFormat:@"%@  %@",self.adressData[@"userName"],self.adressData[@"userPhone"]] Color:COLOR_STRING(@"#999999")];
        
        
    }else
    {
        self.phoneLabel.hidden =YES;
        self.adressLabel.hidden =YES;
        self.label.hidden  =NO;
    }
}
-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.text = @"请填写收货地址";
    }
    return _label;
}

-(UILabel *)adressLabel
{
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc]init];
        _adressLabel.font = [UIFont systemFontOfSize:SCALE(12)];
    }
    return _adressLabel;
}
-(UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.textColor = [UIColor blackColor];
        _phoneLabel.font = [UIFont boldSystemFontOfSize:SCALE(13)];
    }
    return _phoneLabel;
}
-(UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adress_icon"]];
    }
    return _imageview;
}

//富文本
-(NSMutableAttributedString*)getAttributes:(NSString*)str Color:(UIColor*)color;
{
    NSMutableAttributedString *attribute  = [[NSMutableAttributedString  alloc]initWithString:str attributes:nil];
    NSRange range = [str rangeOfString:self.adressData[@"userPhone"]];
    [attribute addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,[UIFont systemFontOfSize:SCALE(13)],NSFontAttributeName, nil] range:range];
 
    return attribute;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
