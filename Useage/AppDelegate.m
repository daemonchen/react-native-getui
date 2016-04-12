/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import "RCTRootView.h"
#import "RCTLinkingManager.h"

#import "CodePush.h"

#import "RCTPushNotificationManager.h"
#import "GeTuiManager.h"
#import "AppDelegate+GeTui.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  // 注册APNS包括getui
  [self registerUserNotification];

  // 处理远程通知启动APP
  [self receiveNotificationByLaunchingOptions:launchOptions];

  //react native js bundle file
  NSURL *jsCodeLocation;
#ifdef DEBUG
  jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios&dev=true"];
#else
//  jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
  jsCodeLocation = [CodePush bundleURL];
#endif


  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"awesomeMobile"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  self.rootView = rootView;
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [[UIViewController alloc] init];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];


  return YES;
}

#pragma mark - 远程通知(推送)回调

/** 远程通知注册成功委托 */
// Required for the register event.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

  NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  myToken = [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSLog(@"\n>>>[DeviceToken ]:%@\n\n",deviceToken);

  [GeTuiSdk registerDeviceToken:myToken];

  [RCTPushNotificationManager didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

/** 远程通知注册失败委托 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

  [GeTuiSdk registerDeviceToken:@""];

  NSLog(@"\n>>>[DeviceToken Error]:%@\n\n",error.description);
}

#pragma mark - APP运行中接收到通知(推送)处理

// Required for the notification event.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification
{
  [RCTPushNotificationManager didReceiveRemoteNotification:notification];
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
  // [4-EXT-1]: 个推SDK已注册，返回clientId
  [GeTuiManager setClientId:clientId];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
  // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
  NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId andOffLine:(BOOL)offLine fromApplication:(NSString *)appId {

  // [4]: 收到个推消息
  NSData *payload = [GeTuiSdk retrivePayloadById:payloadId];
  NSString *payloadMsg = nil;
  if (payload) {
    payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
  }

//  NSString *msg = [NSString stringWithFormat:@" payloadId=%@,taskId=%@,messageId:%@,payloadMsg:%@%@",payloadId,taskId,aMsgId,payloadMsg,offLine ? @"<离线消息>" : @""];
//    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", payloadMsg);
    GeTuiManager *geTuiManager = [GeTuiManager sharedInstance];
  [geTuiManager handleRemoteNotificationReceived:payloadMsg withRoot:self.rootView];
  /**
   *汇报个推自定义事件
   *actionId：用户自定义的actionid，int类型，取值90001-90999。
   *taskId：下发任务的任务ID。
   *msgId： 下发任务的消息ID。
   *返回值：BOOL，YES表示该命令已经提交，NO表示该命令未提交成功。注：该结果不代表服务器收到该条命令
   **/
  [GeTuiSdk sendFeedbackMessage:90001 taskId:taskId msgId:aMsgId];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  return [RCTLinkingManager application:application openURL:url
                      sourceApplication:sourceApplication annotation:annotation];
}

@end
