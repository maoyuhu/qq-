//
//  MYHLrcTool.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/2/18.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "MYHLrcTool.h"
#import "MYHlrcModel.h"

@implementation MYHLrcTool
+ (NSArray *)lrcToolWithLrcName:(NSString *)lrcName{

// 获取路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    // 获取歌词
    NSString *lrc = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // 转化成歌词数组
    NSArray *lrcArr = [lrc componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArr = [NSMutableArray array];
    
   // [ti:]
  //  [ar:]
   // [al:]
    
    for (NSString *lrcLineString in lrcArr) {
        // 过滤不需要的歌词字符串
        if ([lrcLineString hasPrefix:@"[ti:]"] || [lrcLineString hasPrefix:@"[ar:]"] || [lrcLineString hasPrefix:@"[al:]"] || ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        // 将歌词转化成模型
        MYHlrcModel *lrcLine  = [MYHlrcModel LrcLineString:lrcLineString];
        [tempArr addObject:lrcLine];
        
    }
    
    
    NSLog(@"%@",lrc);
    return tempArr;
}

@end
