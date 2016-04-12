//
//  AppDelegate+GeTui.h
//  awesomeMobile
//
//  Created by 陈光远 on 16/1/26.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (GeTui)
- (void)receiveNotificationByLaunchingOptions:(NSDictionary *)launchOptions;
-(void)registerUserNotification;
@end
