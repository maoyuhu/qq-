//
//  NSString+MYHTimeExtension.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/1/17.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "NSString+MYHTimeExtension.h"

@implementation NSString (MYHTimeExtension)

+ (NSString *)stringWithTime:(NSTimeInterval)time{

    //给的时间戳 /60得分钟  (/60得分钟)/60得小时 余数是分钟     %60得秒

    NSInteger min = time / 60;
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}
@end
