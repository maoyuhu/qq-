//
//  MYHLrcLabel.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/2/18.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "MYHLrcLabel.h"

@implementation MYHLrcLabel

- (void)setProgress:(CGFloat)progress{

    _progress = progress;
    [self setNeedsDisplay]; // 会调用drawRect

}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor greenColor] set];
   // UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
    
    
}


@end
