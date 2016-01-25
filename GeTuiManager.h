//
//  GeTuiManager.h
//  awesomeMobile
//
//  Created by scott on 15/12/16.
//  Copyright © 2015年 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "RCTRootView.h"

@interface GeTuiManager : NSObject <RCTBridgeModule>

+(void) setClientId:(NSString *)newClientId;
+(instancetype)sharedInstance;
-(void)handleRemoteNotificationReceived:(NSString *)payloadMsg withRoot:(RCTRootView *) rootView;
@end
