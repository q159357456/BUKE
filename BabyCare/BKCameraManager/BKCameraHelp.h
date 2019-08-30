//
//  BKCameraHelp.h
//  babycaretest
//
//  Created by Don on 2019/4/23.
//  Copyright © 2019年 深圳偶家科技有限公司. All rights reserved.
//

#ifndef BKCameraHelp_h
#define BKCameraHelp_h

typedef enum DeviceContentState {//babycare连接状态
    DeviceContentStateType_Connecting = 1,//连接中
    DeviceContentStateType_onLine  = 2,//在线
    DeviceContentStateType_offLine = 3//离线
} DeviceContentStateType;

typedef enum {//CMD命令类型
    IOTYPE_REMOTE_MUSIC_REQ = 0x5001,//推送mp3歌曲 (请求的参数就是MP3的播放链接的字符串)
    IOTYPE_REMOTE_MUSIC_RESP = 0x5002,//推送歌曲回调 (设备收到之后如果当前正在播放这首歌则返回"1"，否则就是返回"0" 点播成功)
    IOTYPE_STOP_MUSIC_PLAY_REQ  = 0x5003, //停止播放接口
    IOTYPE_STOP_MUSIC_PLAY_RESP = 0x5004, //停止播放回调,返回请求的参数
    IOTYPE_DEVICE_UNBLIND_REQ   = 0x6005, //设备解绑
    IOTYPE_DEVICE_UNBLIND_RESP  = 0x6006,
    //拨打电话
    IOTYPE_CALL_RESPON_REQ      = 0x6009,
    /** 参数
     a. "1"    接电话。设备发出推送APP收到推送后，点接听，连上P2P后先发送这个字符串，然后进入实时画面开来双向通话。
     b. "2"    挂电话。设备发出推送APP收到推送后，点挂断，连上P2P后先发送这个字符串。
     c. "4"    查询设备是否在通话。APP主动打电话给设备之前要先查询。
     d. "5"    APP主动打电话。 APP主动打电话给设备，需要先发这条命令告诉设备，让设备先播放来电话的提示音。发完这条命令之后延时3.5S再发送对讲的命令。
     */
    IOTYPE_CALL_RESPON_RESP     = 0x6010,
    
    //获取设备电量，音量播放状态等信息
    IOTYPE_BATTERY_LEVEL_REQ    = 0x6011,
    IOTYPE_BATTERY_LEVEL_RESP   = 0x6012,
    //设备音量控制及播放控制
    IOTYPE_CONTROL_VOL_REQ      = 0x6029,
    IOTYPE_CONTROL_VOL_RESP     = 0x6030,
    /**
     IOTYPE_CONTROL_VOL_REQ    请求参数说明：
     a.    "get_vol:"            获取音量
     b.    "set_vol:"            设置音量。set_vol:跟着音量值。范围0-100
     c.    "previous_music:"    上一曲
     d.    "next_music:"        下一曲
     e.    "start_music:"        暂停/播放
     f.    "stop_music:"        停止播放
     IOTYPE_CONTROL_VOL_RESP
     a.    "get_vol:0-100"
     b.    "0-100"
     c.    "previous_music: OK"
     d.    "next_music: OK"
     e.    "start_music: OK"
     f.    "stop_music: OK"*/
    
    //通讯录更新
    IOTYPE_MODIFY_FAMILY_REQ     = 0x6003,
    IOTYPE_MODIFY_FAMILY_RESP    = 0x6004
    
} CMDType;

typedef struct
{
    unsigned char total;        // MP3列表总共的url个数, 1的时候是单独点播1首，mp3ListPacket里面的数据就是MP3url
    unsigned char packetIndex;        // 包的索引，第0个包的时候要保证mp3ListPacket里面要有一个完整的url。因为第0个包拿到之后要马上开始播放。
    unsigned char endflag;        // end flag; endFlag = 1 means this package is the last one.
    unsigned int packetLen;    // max 1000
    unsigned char mp3ListPacket[1000]; // mp3列表。用每个url用换行符分隔。
}SMsgAVIoctrlListMp3Req;

#endif /* BKCameraHelp_h */
