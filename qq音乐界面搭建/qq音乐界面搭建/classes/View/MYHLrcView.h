//
//  MYHLrcView.h
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/2/8.
//  Copyright © 2017年 rss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYHLrcLabel;

@interface MYHLrcView : UIScrollView
// 歌词名
@property (nonatomic, copy) NSString *lrcName;

// 当前播放器播放的时间
@property (nonatomic, assign) NSTimeInterval currentTime;

/** 主界面歌词的Lable */
@property (nonatomic, weak) MYHLrcLabel *lrcLabel;

// 当前播放器播放的总时间
@property (nonatomic, assign) NSTimeInterval duaraTime;
@end
