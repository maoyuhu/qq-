//
//  MYHMusicTool.h
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/1/17.
//  Copyright © 2017年 rss. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MYHMusicModel,MYHMusicTool;
@interface MYHMusicTool : NSObject

// 所有音乐
+ (NSArray *)musics;

//当前在播放的音乐
+ (MYHMusicModel *)playingMusic;

// 设置默认的音乐
+ (void)setupPlayingMusic:(MYHMusicModel *)playingMusic;

// 返回上一首音乐
+ (MYHMusicModel *)previousMusic;

//返回下一首音乐
+ (MYHMusicModel *)nextMusic;
@end
