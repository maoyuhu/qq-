//
//  MYHPlayRootVC.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/1/17.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "MYHPlayRootVC.h"
#import "UIView+RSSExtensionView.h"
#import "Masonry.h"
#import "MYHAudioTool.h"
#import "MYHMusicModel.h"
#import "MYHMusicTool.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+MYHTimeExtension.h"
#import "CALayer+PauseAimate.h"
#import "MYHLrcView.h"
#import "MYHLrcLabel.h"

#define MYHColor(r,g,b)[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 ]

@interface MYHPlayRootVC ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgimageV;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *songer;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageV;
@property (weak, nonatomic) IBOutlet MYHLrcLabel *lrcLab;
@property (weak, nonatomic) IBOutlet UILabel *allTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLab; //剩余时间
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UISlider *sliderTime;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet MYHLrcView *lrcView;

/**歌词的定时器*/

@property (nonatomic, strong) CADisplayLink *lrcTimer;

//播放器
@property (nonatomic, weak) AVAudioPlayer *currentPlayer;
// 进度条时间
@property (nonatomic, strong) NSTimer *progressTimer;

#pragma mark ---事件
- (IBAction)startOrPause;

- (IBAction)lastSong;
- (IBAction)nextSong;

@end

@implementation MYHPlayRootVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 1.添加毛玻璃效果
    [self setupBlur];
    
    // 2.改变滑块的图片
    [self.sliderTime setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 赋值label
    self.lrcView.lrcLabel = self.lrcLab;
    
    // 3.开始播放音乐
    [self startPlayingMusic];
    
    
    
    
    // 4 设置歌词view的contentsize
    self.lrcView.contentSize = CGSizeMake(self.view.width*2, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIconViewAnimate) name:@"iconViewNotification" object:nil];
}
- (void)setupBlur{
    
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [self.bgimageV addSubview:toolBar];
    toolBar.barStyle = UIBarStyleBlack;
    
    // 添加约束
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgimageV);
    }];
    
}
#pragma mark - 开始播放音乐
- (void)startPlayingMusic{
    
    //1 获取当前正在播放的音乐
    MYHMusicModel *playingMusic = [MYHMusicTool playingMusic];
    
    //2 设置界面信息
    self.bgimageV.image = [UIImage imageNamed:playingMusic.icon];
    self.middleImageV.image = [UIImage imageNamed:playingMusic.icon];
    self.songName.text = playingMusic.name;
    self.songer.text = playingMusic.singer;
    
    //播放音乐
    AVAudioPlayer *currentPlayer = [MYHAudioTool playMusicWithFileName:playingMusic.filename];
    
    self.remainTimeLab.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.allTimeLab.text = [NSString stringWithTime:currentPlayer.duration];
    self.currentPlayer = currentPlayer;
    
    // 3.1设置播放按钮
    self.stopBtn.selected = self.currentPlayer.isPlaying;
    
    // 3.2 设置歌词
    self.lrcView.lrcName = playingMusic.lrcname;
    self.lrcView.duaraTime = currentPlayer.duration;
    //开启定时器
    // 4.开启定时器
    [self removeProgressTimer];
    [self addProgressTimer];
    [self removeLrcTime];
    [self addLrcTime];
    
    // 5 添加核心动画  中间的圆一起转
    [self addIconViewAnimate];

}
#pragma mark ---添加核心动画
- (void)addIconViewAnimate{
    
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimate.fromValue = @(0);
    rotateAnimate.toValue = @(M_PI*2);
    rotateAnimate.repeatCount = NSIntegerMax;
    rotateAnimate.duration = 35;
    [self.middleImageV.layer addAnimation:rotateAnimate forKey:nil];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)addProgressTimer{
    [self updataProgressInfo];
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updataProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    
    
}

#pragma mark ---更新进度条
- (void)updataProgressInfo{
    
    // 1 更新播放时间
    self.remainTimeLab.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    
    // 2 更新进度条
    self.sliderTime.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
    
    
}
- (void)removeProgressTimer{
    
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
}
#pragma mark ---定时器的相关代理方法
- (IBAction)sliderBegin:(id)sender {
    
    //移除定时器
    [self removeProgressTimer];
    
    
}
- (IBAction)sliderEnd:(id)sender {
    // 1.更新播放的时间
    self.currentPlayer.currentTime = self.sliderTime.value * self.currentPlayer.duration;
    
    // 2.添加定时器
    [self addProgressTimer];
    
}
- (IBAction)sliderValueChange:(UISlider *)sender {
    self.remainTimeLab.text = [NSString stringWithTime:self.sliderTime.value * self.currentPlayer.duration];
    
    
}
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    // 获取点击到的点
    CGPoint point = [sender locationInView:sender.view];
    // 获取点击的比例
    CGFloat ratio = point.x / self.sliderTime.width;
    // 更新播放时间
    self.currentPlayer.currentTime = self.currentPlayer.duration * ratio;
    // 更新时间和滑块的位置
    [self updataProgressInfo];
}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    [self.middleImageV CircleViewWithsubviewfloat:self.middleImageV.width*0.5];
}
#pragma mark ---三个按钮的事件
- (IBAction)startOrPause {
    self.stopBtn.selected = !self.stopBtn.selected;
    if (self.currentPlayer.playing) {
        // 1 暂停播放
        [self.currentPlayer pause];
        //2 移除定时器
        [self removeProgressTimer];
        // 3暂停动画
        [self.middleImageV.layer pauseAnimate];
    }else{
        //1 开始播放
        [self.currentPlayer play];
        // 2 添加定时器
        [self addProgressTimer];
        // 3开始动画
        [self.middleImageV.layer resumeAnimate];
    }
    
}
#pragma Mark--上一首
- (IBAction)lastSong {
    
    
    // 获取上一首歌
    MYHMusicModel *previousMusic = [MYHMusicTool previousMusic];
    
    // 设置上一首歌为默认播放歌曲
    [self playMusicWithMusic:previousMusic];
    
   
}
#pragma mark ---下一首
- (IBAction)nextSong {
    
    // 获取下一首歌
    MYHMusicModel *nextMusic = [MYHMusicTool nextMusic];
    
    // 设置下一首歌为默认播放歌曲
    [self playMusicWithMusic:nextMusic];
    
}
- (void)playMusicWithMusic:(MYHMusicModel *)music{

    //1 获取当前播放的歌曲并停止
    MYHMusicModel *currentMusic = [MYHMusicTool playingMusic];
    [MYHAudioTool stopMusicWithFileName:currentMusic.filename];
    
    
    // 设置上/下一首歌为默认播放歌曲
    [MYHMusicTool setupPlayingMusic:music];
    
    // 播放音乐
    [self startPlayingMusic];

}
#pragma mark ---改变状态栏的颜色
- (UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    // 1 获取滑动的偏移量
    CGPoint point = scrollView.contentOffset;
    
    // 2 获取滑动比例
    CGFloat alpha = 1 - point.x / scrollView.width;

    // 3 设置alpha
    self.middleImageV.alpha = alpha;
    self.lrcLab.alpha = alpha;
   
  }
#pragma mark ---对歌词定时器的操作
- (void)addLrcTime{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}
- (void)removeLrcTime{

    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}
#pragma mark --更新歌词
- (void)updateLrcInfo{

    self.lrcView.currentTime = self.currentPlayer.currentTime;

}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{

/*
 UIEventSubtypeNone                              = 0,
 
 // for UIEventTypeMotion, available in iPhone OS 3.0
 UIEventSubtypeMotionShake                       = 1,
 
 // for UIEventTypeRemoteControl, available in iOS 4.0
 UIEventSubtypeRemoteControlPlay                 = 100,
 UIEventSubtypeRemoteControlPause                = 101,
 UIEventSubtypeRemoteControlStop                 = 102,
 UIEventSubtypeRemoteControlTogglePlayPause      = 103,
 UIEventSubtypeRemoteControlNextTrack            = 104,
 UIEventSubtypeRemoteControlPreviousTrack        = 105,
 UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
 UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
 UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
 UIEventSubtypeRemoteControlEndSeekingForward    = 109,

 */

    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:

            [self startOrPause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            
            [self nextSong];
            break;

        case UIEventSubtypeRemoteControlPreviousTrack:
     
            
            [self lastSong];
            break;

            
        default:
            break;
    }

}
@end
