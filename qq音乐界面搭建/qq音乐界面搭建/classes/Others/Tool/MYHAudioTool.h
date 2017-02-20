//
//  MYHAudioTool.h
//  播放音效
//
//  Created by maoxiaohu on 17/1/16.
//  Copyright © 2017年 rss. All rights reserved.
// AVAudioPlayer:只能播放本地音乐 不能播放远程音乐
// AVPlayer 可以播放远程音乐,本地音乐 视频(本地 远程 ) 功能更加强大


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MYHAudioTool : NSObject

// 播放音效
+ (void)playSoundWithSoundName:(NSString *)soundName;

// 播放音乐 FileName : 音乐文件
+ (AVAudioPlayer *)playMusicWithFileName:(NSString *)FileName;
// 暂停音乐 FileName : 音乐文件
+ (void)pauseMusicWithFileName:(NSString *)FileName;
// 停止音乐 FileName : 音乐文件
+ (void)stopMusicWithFileName:(NSString *)FileName;
@end
