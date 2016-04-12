/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"
#import "RCTRootView.h"

#define kGtAppId           @"your getui kGtAppId"
#define kGtAppKey          @"your getui kGtAppKey"
#define kGtAppSecret       @"your getui kGtAppSecret"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic) RCTRootView *rootView;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

@end
