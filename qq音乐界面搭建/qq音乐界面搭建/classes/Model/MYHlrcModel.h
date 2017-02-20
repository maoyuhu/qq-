//
//  MYHlrcModel.h
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/2/18.
//  Copyright © 2017年 rss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYHlrcModel : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTimeInterval time;

- (instancetype)initWithLrcLineString :(NSString *)lrcLineString;

+ (instancetype)LrcLineString :(NSString *)lrcLineString;

@end
