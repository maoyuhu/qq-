//
//  MYHMusicTool.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/1/17.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "MYHMusicTool.h"
#import "MYHMusicModel.h"
#import "MJExtension.h"

@implementation MYHMusicTool

static NSArray *_musics;
static MYHMusicModel *_playerMusic;

+ (void)initialize{
    
    if (_musics == nil) {
        _musics = [MYHMusicModel objectArrayWithFilename:@"Musics.plist"];
    }
    if (_playerMusic == nil) {
        _playerMusic = _musics[1];
    }
}

+ (NSArray *)musics{
    return _musics;
}
+ (MYHMusicModel *)playingMusic{
    
    return _playerMusic;
}
+ (void)setupPlayingMusic:(MYHMusicModel *)playingMusic{
    
    
    _playerMusic = playingMusic;
}

// 返回上一首音乐
+ (MYHMusicModel *)previousMusic{

    // 1获取当前音乐的下标题
    NSInteger currentIndex = [_musics indexOfObject:_playerMusic];

    // 2 获取上一首的下标题
    NSInteger previousIndex = currentIndex - 1;
    
    MYHMusicModel *preousMusic = nil;
    //判断
    if (previousIndex < 0) {
       previousIndex = _musics.count - 1;
    }
    
    preousMusic = _musics[previousIndex];
    return  preousMusic;
}

//返回下一首音乐
+ (MYHMusicModel *)nextMusic{

    // 1获取当前音乐的下标题
    NSInteger currentIndex = [_musics indexOfObject:_playerMusic];
    
    // 2 获取下一首的下标题
    NSInteger nextIndex = currentIndex + 1;
    
    MYHMusicModel *nextMusic = nil;
    //判断
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    
    nextMusic = _musics[nextIndex];
    return  nextMusic;




}
@end
