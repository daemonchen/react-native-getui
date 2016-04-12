//
//  AppDelegate+GeTui.m
//  awesomeMobile
//
//  Created by 陈光远 on 16/1/26.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "AppDelegate+GeTui.h"

@implementation AppDelegate (GeTui)

/** 注册用户通知 */
- (void)registerUserNotification {
  // 通过 appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
  [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
  /*
   注册通知(推送)
   申请App需要接受来自服务商提供推送消息
   */
  // 判读系统版本是否是“iOS 8.0”以上
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
      [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
    
    // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    
    // 定义用户通知设置
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    // 注册用户通知 - 根据用户通知设置
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //    NSLog(@"----did registerUserNotificationSettings as ios version > 8.0");
    
  }
  else {      // iOS8.0 以前远程推送设置方式
    // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    
    // 注册远程通知 -根据远程通知类型
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    //    NSLog(@"----did registerUserNotificationSettings as ios version < 8.0");
  }
}

/** 自定义：APP被“推送”启动时处理推送消息处理（APP 未启动--》启动）*/
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions {
  if (!launchOptions) return;
  
  /*
   通过“远程推送”启动APP
   UIApplicationLaunchOptionsRemoteNotificationKey 远程推送Key
   */
  NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (userInfo) {
    NSLog(@"\n>>>[Launching RemoteNotification]:%@",userInfo);
  }
}

@end
