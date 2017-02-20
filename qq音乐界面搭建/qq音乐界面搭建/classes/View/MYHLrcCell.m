//
//  MYHLrcCell.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/2/8.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "MYHLrcCell.h"
#import "MYHLrcLabel.h"
#import "Masonry.h"

@implementation MYHLrcCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    MYHLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MYHLrcCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        MYHLrcLabel *lrcLabel = [[MYHLrcLabel alloc]init];
        [self.contentView addSubview:lrcLabel];
        self.lrcLabel = lrcLabel;
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        lrcLabel.textColor = [UIColor whiteColor];
        lrcLabel.textAlignment = NSTextAlignmentCenter;
        lrcLabel.font = [UIFont systemFontOfSize:14];
        
        
    }
    return self;
}

@end
