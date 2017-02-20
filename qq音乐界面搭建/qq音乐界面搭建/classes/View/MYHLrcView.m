//
//  MYHLrcView.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/2/8.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "MYHLrcView.h"
#import "Masonry.h"
#import "UIView+RSSExtensionView.h"
#import "MYHLrcCell.h"
#import "MYHLrcTool.h"
#import "MYHlrcModel.h"
#import "MYHLrcLabel.h"
#import "MYHMusicTool.h"
#import "MYHMusicModel.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MYHLrcView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
/** 歌词数组 */
@property (nonatomic, strong) NSArray *lrcList;

@property (nonatomic, assign) NSInteger currentLine;

@end

@implementation MYHLrcView

- (NSArray *)lrcList{
    
    if (_lrcList ==nil) {
        _lrcList = [NSArray array];
    }
    
    return _lrcList;
    
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // 初始化TableView
        [self setupTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化TableView
        [self setupTableView];
    }
    return self;
}
- (void)setupTableView{
    
    
    // 1.初始化
    UITableView *tableView = [[UITableView alloc] init];
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //1 添加约束
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(self.width);
        make.width.equalTo(self.mas_width);
        
    }];
    
    // 2.改变tableView属性
    self.tableView.backgroundColor = [UIColor clearColor];// 在tableView有frame的情况下才会生效
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 40;
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
    
}
#pragma mark - UITableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYHLrcCell *cell = [MYHLrcCell lrcCellWithTableView:tableView];
    
    if (self.currentLine == indexPath.row) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:20.0f];
    }else{
        cell.lrcLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.lrcLabel.progress = 0;
    }
    // 1.取出数据模型
    MYHlrcModel *lrcLine = self.lrcList[indexPath.row];
    
    // 2.设置数据
    cell.lrcLabel.text = lrcLine.text;
    
    return cell;
}

#pragma mark - 重写lrcName
- (void)setLrcName:(NSString *)lrcName
{
    //-1 让tableView滚到中间
    [self.tableView setContentOffset:CGPointMake(0, -self.height *0.5) animated:NO];
    
    
    // 0 将currentTime设置为0
    self.currentLine = 0;
    // 1.记录歌词名
    _lrcName = [lrcName copy];
    
    // 2.解析歌词
    self.lrcList = [MYHLrcTool lrcToolWithLrcName:lrcName];
    
    // 2.1设置第一句歌词
    MYHlrcModel *firstLrcLine = self.lrcList[0];
    self.lrcLabel.text = firstLrcLine.text;
    // 3.刷新表格
    [self.tableView reloadData];
}
#pragma mark ---从写currentTime
- (void)setCurrentTime:(NSTimeInterval)currentTime{
    
 
    
    // 记录当前的时间
    _currentTime = currentTime;
    
    // 判断显示哪句歌词
    NSInteger count = self.lrcList.count;
    for (NSInteger i = 0; i < count; i ++) {
        MYHlrcModel *currentLine = self.lrcList[i];
        // 取出下一句歌词
        NSInteger nextIndex = i + 1;
        MYHlrcModel *nextLine = nil;
        if (nextIndex < count) {
            nextLine = self.lrcList[nextIndex];
        }
        // 判断用当前播放器的时间 和当前这句歌词的时间和下一句的歌词的时间比对 如果大于当前歌词播放时间 小于下一句歌词播放时间久方波当前的歌词
        if (self.currentLine !=i && currentTime >= currentLine.time && currentTime < nextLine.time) {
            // 1 将当前的这句歌词滚动到中间
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            
            NSIndexPath *previousIndex = [NSIndexPath indexPathForRow:self.currentLine inSection:0];
            
            // 2 记录当前刷新某行
            self.currentLine = i;
            
            // 3 刷新当前这句歌,并且刷新上一句歌词
            [self.tableView reloadRowsAtIndexPaths:@[indexpath,previousIndex] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES]; // 一秒钟刷新60次 Displayer的特性
            // 5 设置主界面歌词的文字
            self.lrcLabel.text = currentLine.text;
            
            // 生成锁屏图片
            [self genaratorLockImage];
            
        }
        if (self.currentLine == i) { // 是当前这句歌词
            //1 获取当前歌词
            MYHlrcModel *currentLrcLine = self.lrcList[self.currentLine];
            
            // 2 获取下一句歌词
            NSInteger nextIndex = self.currentLine + 1;
            MYHlrcModel *nextLrcLine = nil;
            if (nextIndex < self.lrcList.count) {
                nextLrcLine = self.lrcList[nextIndex];
            }
            
            // 3 取出当前歌词的时间,用当前播放器的时间减去当前歌词的时间除以(下一句歌词的时间 - 当前歌词的时间)
            CGFloat value = (currentTime - currentLrcLine.time) / (nextLrcLine.time - currentLrcLine.time);
            
            // 4 设置当前歌词的进度
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.currentLine inSection:0];
            
            MYHLrcCell *lrcCell = [self.tableView cellForRowAtIndexPath:indexpath];
            lrcCell.lrcLabel.progress= value;
            self.lrcLabel.progress = value;
        }
    }
    
}
#pragma mark ---生成锁屏图片
- (void)genaratorLockImage{

    // 1 获取当前音乐的照片
    MYHMusicModel *playingMusics = [MYHMusicTool playingMusic];
    UIImage *currentImage = [UIImage imageNamed:playingMusics.icon];
    
    // 2取出歌词
    // 2.1 取出当前歌词
    MYHlrcModel *currentLrcLine = self.lrcList[self.currentLine];
    
    // 2.2取出上一句歌词
    NSInteger previousIndex = self.currentLine - 1;
    
    MYHlrcModel *previousLrcLine = nil;
    if (previousIndex >= 0) {
        previousLrcLine = self.lrcList[previousIndex];
    }
    // 2.3 取出下一句歌词
    NSInteger nextIndex = self.currentLine + 1;
    MYHlrcModel *nextLrcLine = nil;
    if (nextIndex < self.lrcList.count) {
        nextLrcLine = self.lrcList[nextIndex];
    }
    //3生成水印图片
    // 3.1 获取上下文
    UIGraphicsBeginImageContext(currentImage.size);
    
    //3.2 将图片画上去
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    
    // 3.3将文字画上去
    CGFloat titleH = 25;
    NSMutableParagraphStyle *ParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    ParagraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor lightGrayColor],NSParagraphStyleAttributeName:ParagraphStyle};
    [previousLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH * 3, currentImage.size.width, titleH) withAttributes:attributes];
    
    [nextLrcLine.text drawInRect:CGRectMake(0,currentImage.size.height - titleH, currentImage.size.width, titleH) withAttributes:attributes];
    
    NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor greenColor],NSParagraphStyleAttributeName:ParagraphStyle};

     [currentLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH *2, currentImage.size.width, titleH) withAttributes:attributes2];
    
    // 3.4获取画好的图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 3.5 
    UIGraphicsEndImageContext();
    
    [self setupLockSreenInfoWithLockImage:lockImage];
}

#pragma mark ---设置锁屏信息
// 有问题的
- (void)setupLockSreenInfoWithLockImage:(UIImage *)image{
    
    // 0获取当前播放的歌曲
    MYHMusicModel *playingMusic = [MYHMusicTool playingMusic];
    
    // 1获取锁屏中心
    
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    //2 设置锁屏参数
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    // 2.1设置歌曲名
    [playingInfoDict setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    // 2.2设置歌手名
    [playingInfoDict setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    // 2.3 设置封面的图片 之前图片上的歌词一直画不上去 是由于这句话新建了图片赵成的  MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:playingMusic.icon]];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:image];
    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    // 2.4 设置歌曲的总长度
    [playingInfoDict setObject:@(self.duaraTime) forKey:MPMediaItemPropertyPlaybackDuration];
    
    // 2.4设置歌曲当前的播放时间
    [playingInfoDict setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];

    
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    // 3开启远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
}
@end
