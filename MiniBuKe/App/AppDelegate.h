//
//  AppDelegate.h
//  MiniBuKe
//
//  Created by zhangchunzhe on 2017/12/26.
//  Copyright © 2017年 深圳偶家科技有限公司. All rights reserved.
// test

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "VersionInfo.h"
#import "XbkKeySecret.h"
//#import <UMCommon/UMCommon.h>
//#import <UMAnalytics/MobClick.h>
//#import <UMPush/UMessage.h>
#import "BKNavgationController.h"

#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

@class LoginResult;
@class SNDataModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, strong) NSMutableArray * navigationControllers;

@property (nonatomic, strong) LoginResult *mLoginResult;
@property (nonatomic, strong) BKNavgationController *navigationController;
@property (nonatomic, assign) BOOL isWXInstalled;
@property (nonatomic, strong) VersionInfo *mVersionInfo;
@property (nonatomic,strong) XbkKeySecret *mXbkKeySecret;
@property (nonatomic) bool isUnbind;
@property (nonatomic,assign)BOOL isOnLine;
@property (nonatomic,assign)CGFloat ElectricQuantity;
@property (nonatomic, strong) SNDataModel *snData;
@property (nonatomic, strong) UIViewController *ARviewCtr;
- (void)saveContext;

-(void) removeLoginResult;

-(BOOL) isShowPromptEnterSexInfoWindow;
-(void) setPromptEnterSexInfoWindowFlag:(BOOL) flag;
+(NSString *) getServerHost;

-(void)saveLoginSuccessWithDictionary:(NSDictionary *)dic;
-(void)saveLoginSuccessWithModel;

-(void)saveSNInfoWithModel;
-(void)removeSNInfoSave;

@end

