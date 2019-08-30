//
//  ARManager.m
//  MiniBuKe
//
//  Created by chenheng on 2019/4/25.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#import "ARManager.h"
#import "CommonUsePackaging.h"

NSString * key = @"P9EytHNZ0vSFKqy5ms566p9kEqYBtq8nkgekD58sjl4KiZsNJl8Hv2Ci2e6UnQ8vV0QYUAWeEOCYVwVd422us4Jxv68QJY58H4evvZTuor0HOvMW2ApNAsq0OrOYOxoGGCqG5UYcil98hEXL1LVZfwUKaHFuu9ccw3GhD59MiE7cTmBcHd40HbkwIjeDtZBD3fEpPAnS";
//NSString * cloud_server_address = @"oplustech.staging.crs.easyar.com:8080";
NSString * cloud_server_address = @"fc07d06034b3ff9dd9fc148a0cae2662.cn1.crs.easyar.com:8080";
NSString * cloud_key = @"3dd55f28104b835285fecac69c00cc3b";
NSString * cloud_secret = @"mIakZj2KAvWqn7MZy0VzQ3olCqvUbnko0CrIc7DqHsc90VnIQhdzYhBLKx7MFEbdVmablPyL7LhG8RVZtJQ9Y6jZXu8S39iTJamE1GNcQfP6yeFaKhH8nsGi0nRYCxqQ";
easyar_DelayedCallbackScheduler * scheduler;
easyar_CameraDevice * camera;
easyar_CameraFrameStreamer * streamer;
NSMutableArray<easyar_ImageTracker *> * trackers;
easyar_Renderer * videobg_renderer;
easyar_CloudRecognizer * cloud_recognizer;
float aspect_ratio;
NSMutableSet<NSString *> * uids;
// change ImageTrackerMode to PreferQuality if your device is fast enough
easyar_ImageTrackerMode track_mode = easyar_ImageTrackerMode_PreferPerformance;
// change ImageSourceMode to Mirror if your camera is mirrored
easyar_ImageSourceMode src_mode = easyar_ImageSourceMode_Mirror;
NSString * _uid;
NSString * _localTrackName;

@implementation ARManager
//
+(void)configEasyAR
{
    if (![easyar_Engine initialize:key]) {
        NSLog(@"Initialization Failed.");
       
        [MonitorLogView showMonitorLog:@"easyar初始化失败"];
        
    }else
    {
        NSLog(@"Initialization Sucecess.");
        
        [MonitorLogView showMonitorLog:@"easyar初始化成功"];
        
    }
}
//
+(void)onPause
{
     [easyar_Engine onPause];
}
//
+(void)onResume
{
     [easyar_Engine onResume];
}
//
void createScheduler()
{
    scheduler = [easyar_DelayedCallbackScheduler create];
}
easyar_DelayedCallbackScheduler * getScheduler()
{
    return scheduler;
}

BOOL initialize()
{
    camera = [easyar_CameraDevice create];
    streamer = [easyar_CameraFrameStreamer create];
    [streamer attachCamera:camera];
    cloud_recognizer = [easyar_CloudRecognizer create];
    [cloud_recognizer attachStreamer:streamer];
    
    bool status = true;
    status &= [camera openWithType:easyar_CameraDeviceType_Front];
    [camera setSize:[easyar_Vec2I create:@[@1280, @720]]];
    if (src_mode == easyar_ImageSourceMode_Mirror) {
        [streamer setMirrorCamera];
        [cloud_recognizer setMirrorCamera];
    }
    
    [cloud_recognizer open:cloud_server_address appKey:cloud_key appSecret:cloud_secret callbackScheduler:scheduler callback:^(easyar_CloudStatus status, NSArray<easyar_Target *> * targets) {
        @autoreleasepool {
            
            NSString *metaStr;
            for (easyar_Target * t in targets) {
                if (t.meta.length) {
                    metaStr = t.meta;
                }
            }
            bool cloudIsP0 = false;//云端识别是否是封面
            //通过meta(5905,0,P0) 信息 区分出 在线识别的是 封面 还是内页,过滤在线内页保证在线只识别封面.
            NSArray *metaArray = [metaStr componentsSeparatedByString:@","];
            if(metaArray.count == 3){
                cloudIsP0 = [metaArray[1] integerValue] == 0 ? true : false;
            }
            bool cloudStatus = status == easyar_CloudStatus_FoundTargets ? true : false;
            if(cloudStatus){
                cloudStatus = cloudIsP0;
            }
            
            bool localStatus = getLocalResult();//本地识别status true or false
           
            if (cloudStatus && localStatus) {//都识别到
                NSLog(@"Cloud Local Found");
                easyar_Target * target = targets.firstObject;
                NSLog(@"uid: %@",target.uid);
                [[NSNotificationCenter defaultCenter] postNotificationName:EasyARLocalFound object:targets];
                
            }else if (cloudStatus && !localStatus){//只有云识别到
                NSLog(@"Cloud  Found");
                easyar_Target * target = targets.firstObject;
                NSLog(@"uid: %@",target.uid);
                [[NSNotificationCenter defaultCenter] postNotificationName:EasyARLocalFound object:targets];
                
            }else if (!cloudStatus && localStatus){//只有本地识别到
                NSLog(@"Local Found-%@",_localTrackName);
                [[NSNotificationCenter defaultCenter] postNotificationName:EasyARLocalFoundPlay object:_localTrackName];
                

            }else{//都未识别到
                NSLog(@"TargetsNotFound");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:EasyARTargetsNotFound object:nil];
            }
        }
        
        

//        if (status == easyar_CloudStatus_FoundTargets ) {
//            //            NSLog(@"CloudRecognizerCallBack: FoundTargets");
//            [[NSNotificationCenter defaultCenter] postNotificationName:EasyARGetUID object:targets];
//        } else if (status == easyar_CloudStatus_Reconnecting) {
//            //            NSLog(@"CloudRecognizerCallBack: Reconnecting");
//        } else if (status == easyar_CloudStatus_TargetsNotFound) {
//            NSLog(@"CloudRecognizerCallBack: TargetsNotFound");
//            //                [[NSNotificationCenter defaultCenter] postNotificationName:EasyARTargetsNotFound object:nil];
//        } else if(status == easyar_CloudStatus_ProtocolError){
//            NSLog(@"CloudRecognizerCallBack: ProtocolError");
//        }else{
//            NSLog(@"CloudRecognizerCallBack: %ld", (long)status);
//        }
//
        
        
    }];
    
    trackers = [[NSMutableArray<easyar_ImageTracker *> alloc] init];
    
    return status;
}

void finalize()
{
    [trackers removeAllObjects];
    cloud_recognizer = nil;
    videobg_renderer = nil;
    streamer = nil;
    camera = nil;
    scheduler = nil;
}

BOOL start()
{
    bool status = true;
    status &= (camera != nil) && [camera start];
    status &= (streamer != nil) && [streamer start];
    status &= (cloud_recognizer != nil) && [cloud_recognizer start];
    [camera setFocusMode:easyar_CameraDeviceFocusMode_Continousauto];
    
    return status;
}


BOOL stop()
{
    bool status = true;

    status &= trackerStop();
    status &= (cloud_recognizer != nil) && [cloud_recognizer stop];
    status &= (streamer != nil) && [streamer stop];
    status &= (camera != nil) && [camera stop];
    return status;
}

BOOL getLocalResult(){
    @autoreleasepool {
        
        while([scheduler runOne]){
            NSLog(@"scheduler runOne");
        };
        if (streamer == nil) {
            NSLog(@"streamer is nil");
            _localTrackName = nil;
            return false;
        }
        easyar_Frame * frame = [streamer peek];
        if(frame == nil) {
            _localTrackName = nil;
            return false;
        }
        easyar_CameraParameters * cameraParameters = [frame cameraParameters];
        if (cameraParameters == nil) {
            _localTrackName = nil;
            return false;
        }
        for (easyar_ImageTracker * tracker in trackers) {
            easyar_ImageTrackerResult * result = [tracker getResult:frame];
            if (result != nil) {
                for (easyar_TargetInstance * targetInstance in [result targetInstances]) {
                    easyar_TargetStatus status = [targetInstance status];
                    if (status == easyar_TargetStatus_Tracked) {
                        easyar_Target * target = [targetInstance target];
                        easyar_ImageTarget * imagetarget = [target isKindOfClass:[easyar_ImageTarget class]] ? (easyar_ImageTarget *)target : nil;
                        if (imagetarget == nil) {
                            continue;
                        }
                        
                        _localTrackName = [imagetarget name];
                        return true;
                    }else{
                        _localTrackName = nil;
                        return false;
                    }
                }
            }
        }
        
        _localTrackName = nil;
        return false;
    }
}

void addTracker(NSString* resPath){

    if (trackers.count) {
        [trackers removeAllObjects];
    }
    trackerStop();
    easyar_ImageTracker * tracker = [easyar_ImageTracker createWithMode:track_mode sourceMode:src_mode];
    [tracker attachStreamer:streamer];
    loadDatasetFromJsonFile(tracker,resPath);
    [trackers addObject:tracker];

    trackerStart();
    
}

void loadDatasetFromJsonFile(easyar_ImageTracker * tracker, NSString * path)
{
    for (easyar_ImageTarget * target in [easyar_ImageTarget setupAll:path storageType:easyar_StorageType_Absolute]) {
        [tracker loadTarget:target callbackScheduler:scheduler callback:^(easyar_Target * target, bool status) {
//            NSLog(@"load target (%d): %@ (%d),%@,%@", status, [target name], [target runtimeID],[target uid],[target name]);
        }];
    }
}

BOOL trackerStart(){
    
    bool status = true;
    for (easyar_ImageTracker * tracker in trackers) {
        status &= [tracker start];
    }
    return status;
}

BOOL trackerStop(){
    
    bool status = true;
    for (easyar_ImageTracker * tracker in trackers) {
        status &= [tracker stop];
    }
    return status;
}

@end


