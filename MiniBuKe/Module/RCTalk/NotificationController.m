//
//  NotificationController.m
//  MiniBuKe
//
//  Created by chenheng on 2018/12/26.
//  Copyright © 2018年 深圳偶家科技有限公司. All rights reserved.
//

#import "NotificationController.h"
#import "XG_PushManager.h"
@interface NotificationController ()
{
    int ddd;
}
@end

@implementation NotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 100 , 50, 40)];
//    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor redColor];
//    backButton setTitle:@"" forState:<#(UIControlState)#>
    [backButton addTarget:self action:@selector(addpushInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 100 , 50, 40)];
    //    [backButton setImage:[UIImage imageNamed:@"mate_back"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    

    // Do any additional setup after loading the view.
}
-(void)addpushInfo{
   
//    ddd++;
//    XG_NoticeModel *model = [[XG_NoticeModel alloc]init];
//    model.msgId = ddd;
//    model.rowid = model.msgId;
//    model.content = [NSString stringWithFormat:@"第%d条消息",ddd];
   
 
}
-(void)print{

//    [XG_PushManager getAllLocalNotifactionDataCallback:^(NSMutableArray * _Nonnull  array) {
//        for (XG_NoticeModel *model in array) {
//            NSLog(@"%@",model.description);
//        }
//    }];
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
