# react-native-getui
react native getui

reactnative集成个推推送:

`AppDelegate.m`

```
    #import "GeTuiManager.h"

    /** SDK启动成功返回cid */
    - (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
      // [4-EXT-1]: 个推SDK已注册，返回clientId
      [GeTuiManager setClientId:clientId];
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
        NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", payloadMsg);
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

```

`index.ios.js`

```
    var {
      NativeAppEventEmitter
    } = React;

    componentDidMount: function(){
        this.unlistenNotification =  NativeAppEventEmitter.addListener(
            'notify',
            (notifData) => {
                this.factoryNotify(notifData);
            }
        );
    },
    componentWillUnmount: function() {
        this.unlistenNotification.remove();
    },
```
