//
//  QRCodeViewController.h
//  MiniBuKe
//
//  Created by chenheng on 2018/4/9.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum _ConfigMold{
    WifiConfigNet = 0,
    FourthGConfigNet
    
}ConfigMold;
@interface QRCodeViewController : UIViewController

@property (nonatomic) BOOL isConfigNet;
@property (nonatomic,strong) NSString *wifiAccount;
@property (nonatomic,strong) NSString *wifiPassword;

@property (nonatomic, assign) XBK_RobotType robotType;
@property(nonatomic,assign)ConfigMold configMold;
@end
