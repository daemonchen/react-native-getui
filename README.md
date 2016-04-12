# react-native-getui
react native getui

reactnative集成个推推送:

### useage:

add `GeTuiManager.h` & `GeTuiManager.m` to your project,

and then change your `AppDelegate.m` like the `./Useage/AppDelegate.m` & `./Useage/AppDelegate.h`,

add `AppDelegate+GeTui` category like the `./Useage/AppDelegate+GeTui.h` & `./Useage/AppDelegate+GeTui.m`



and in your react-native code:

`index.ios.js`

```
    import React, {NativeAppEventEmitter} from 'react-native'

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

dive in & have fun

author: 503802922 [scott chen](http://www.classical1988.com/)

mail: cgyqqcgy@gmail.com