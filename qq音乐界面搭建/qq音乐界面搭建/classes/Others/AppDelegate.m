//
//  AppDelegate.m
//  qq音乐界面搭建
//
//  Created by maoxiaohu on 17/1/16.
//  Copyright © 2017年 rss. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1 获取音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    // 2 设置为后台类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"iconViewAnimate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
     }
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    BOOL  isEnterBack = [[NSUserDefaults standardUserDefaults]boolForKey:@"iconViewAnimate"];
    if (!isEnterBack) return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"iconViewNotification" object:nil];
        
        }
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
