//
//  MYHlrcModel.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/2/18.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "MYHlrcModel.h"

@implementation MYHlrcModel

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString{

    if (self = [super init]) {
        NSArray *lrcArr = [lrcLineString componentsSeparatedByString:@"]"];
        self.text = lrcArr[1];
        self.time = [self timeWithString:[lrcArr[0] substringFromIndex:1]];
    }
    return self;
}

+ (instancetype)LrcLineString:(NSString *)lrcLineString{

    return [[self alloc]initWithLrcLineString:lrcLineString];

}

- (NSTimeInterval)timeWithString:(NSString *)timeString{
    // 01:02.38
    NSInteger min = [[timeString componentsSeparatedByString:@":"][0]integerValue];
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSInteger hs = [[[timeString componentsSeparatedByString:@"."] lastObject]integerValue];
    
    return min * 60 +sec + hs*0.01;
}
@end
