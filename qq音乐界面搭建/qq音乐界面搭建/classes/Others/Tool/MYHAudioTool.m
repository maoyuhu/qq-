//
//  MYHAudioTool.m
//  播放音效
//
//  Created by maoxiaohu on 17/1/16.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "MYHAudioTool.h"
#import <AVFoundation/AVFoundation.h>



@implementation MYHAudioTool
static NSMutableDictionary *_soundIds;
static NSMutableDictionary *_players;

+ (void)initialize{

    _soundIds = [NSMutableDictionary dictionary];
    _players = [NSMutableDictionary dictionary];
}

+ (void)playSoundWithSoundName:(NSString *)soundName{

    SystemSoundID soundid = 0;
    //从字段中取出soundid
    
    soundid = [_soundIds[soundName] unsignedIntValue];
    
    //判断soundid是否为0
    if (soundid == 0) {
        
        //生成soundid
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle]URLForResource:soundName withExtension:nil];
        AudioServicesCreateSystemSoundID(url, &soundid);
        
        if (url == nil) return;
        
        // 将soundid保存到字典中
        [_soundIds setObject:@(soundid) forKey:soundName];
    }
    
    // 播放音效
    AudioServicesPlayAlertSound(soundid);
 
}
+ (AVAudioPlayer *)playMusicWithFileName:(NSString *)FileName{

    AVAudioPlayer *player = nil;
    
    // 从字典中取出播放器
    player = _players[FileName];
    //判断字典是否为空
    if (player == nil) {
        // 生成对应音乐播放器
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:FileName withExtension:nil];
        
          if (fileUrl == nil) return nil;
        //创建对应的播放器
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
       
        //保存到字典中
        [_players setObject:player forKey:FileName];
        
        // 准备播放
        [player prepareToPlay];
        
    }
    // 开始播放
    [player play];

    return player;
}

// 暂停音乐 FileName : 音乐文件
+ (void)pauseMusicWithFileName:(NSString *)FileName{
     if (FileName == nil) return;
    // 从字典中取出播放器
    AVAudioPlayer *player = _players[FileName];
    
    // 暂停
    if (player) {
        [player pause];
    }
    
}
// 暂停音乐 FileName : 音乐文件
+ (void)stopMusicWithFileName:(NSString *)FileName{
 if (FileName == nil) return;
    // 从字典中取出播放器
    AVAudioPlayer *player = _players[FileName];
    
    // 停止音乐
    if (player) {
        [player stop];
        [_players removeObjectForKey:FileName];
        player = nil;
    }
}
@end
