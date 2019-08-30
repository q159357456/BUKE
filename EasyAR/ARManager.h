//
//  ARManager.h
//  MiniBuKe
//
//  Created by chenheng on 2019/4/25.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <easyar/callbackscheduler.oc.h>
#import <easyar/engine.oc.h>
#import <easyar/types.oc.h>
#import <easyar/camera.oc.h>
#import <easyar/frame.oc.h>
#import <easyar/framestreamer.oc.h>
#import <easyar/imagetracker.oc.h>
#import <easyar/imagetarget.oc.h>
#import <easyar/renderer.oc.h>
#import <easyar/cloud.oc.h>
#import <easyar/vector.oc.h>
#define EasyARTargetsNotFound @"EasyARTargetsNotFound"
#define EasyARLocalFound @"EasyARLocalFound"
#define EasyARLocalFoundPlay @"EasyARLocalFoundPlay"

@protocol RecognitionDelegate <NSObject>
@optional
-(void)RecognitionSuccess:(NSString*)featureid;
@end
@interface ARManager: NSObject
void createScheduler(void);
easyar_DelayedCallbackScheduler * getScheduler(void); 
BOOL initialize(void);
void finalize(void);
BOOL start(void);
BOOL stop(void);
void addTracker(NSString* resPath);

+(void)configEasyAR;
+(void)onPause;
+(void)onResume;
@end

