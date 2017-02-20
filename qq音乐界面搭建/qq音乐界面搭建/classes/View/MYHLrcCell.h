//
//  MYHLrcCell.h
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/2/8.
//  Copyright © 2017年 rss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYHLrcLabel;
@interface MYHLrcCell : UITableViewCell

+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;
/**lrcLabel*/
@property (nonatomic, weak) MYHLrcLabel *lrcLabel;

@end
