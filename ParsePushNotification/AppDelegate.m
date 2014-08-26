#import <Parse/Parse.h>
#import "AppDelegate.h"


@implementation AppDelegate


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:@"1iOLxbSepihmM2y9YfuM0fQFkaw6TkPb2okFmm0T" clientKey:@"WYNq2aJdq4J6S5zYjg1hdUMG2vI1NXvV4y3Bo8ZZ"];
    // ****************************************************************************
    
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    
    
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (userInfo != nil) {
        // アプリが終了していた時にLocal通知をタップして起動
        NSLog(@"didFinishLaunchingWithOptions Local通知");
    }
    
    NSDictionary *user = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (user) {
        // アプリが終了していた時にPush通知をタップして起動
        NSLog(@"didFinishLaunchingWithOptions Push通知");
    }
    
    NSLog(@"didFinishLaunchingWithOptions 呼ばれた！！！！！！！！！！！！！！");

    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    // push://hoge/fuga?abc=123
    
    // URL = push://hoge/fuga?abc=123
    // scheme = push
    // Query = abc=123
    
    
    NSString *scheme = [url scheme];
    NSString *controller = [url host];
    NSString *action = [url lastPathComponent];
    NSString *query = [url query];
    
    NSNumber *port = [url port];
    NSString *user = [url user];
    NSString *password = [url password];
    NSString *path = [url path];
    NSString *fragment = [url fragment];
    NSString *parameterString = [url parameterString];
    NSString *relativePath = [url relativePath];
    NSString *relativeString = [url relativeString];
    
    NSString *baseURL = [[url baseURL] description];
    NSString *absoluteURL = [[url absoluteURL] description];
    
//    NSString *baseURL = [NSString stringWithContentsOfURL:[url baseURL] encoding:NSUTF8StringEncoding error:nil];
//    NSString *absoluteURL = [NSString stringWithContentsOfURL:[url absoluteURL] encoding:NSUTF8StringEncoding error:nil];
    
    NSString *msg = [NSString stringWithFormat:@"[URL] = %@\n[schame] = %@\n[host] = %@\n[lastPathComponent] = %@\n[Query] = %@",
                     [url absoluteString], scheme,controller,action, query];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL scheme"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
    
    NSLog(@"------------ 呼ばれた！！！！！！！！ didRegisterForRemoteNotificationsWithDeviceToken   ------------ ");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
    
    NSLog(@"-----------  呼ばれた！！！！！！！！ didFailToRegisterForRemoteNotificationsWithError -----------");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
    NSLog(@"------------ 呼ばれた！！！！！！！！ didReceiveRemoteNotification ---------------------");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    
//    // アプリに登録されている全ての通知を削除
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // userInfoの内容を出力
    for (NSString *str in userInfo) {
        NSLog(@"%@ = %@",str,[userInfo valueForKey:str]);
    }
    
    UIRemoteNotificationType userConfig = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    
    [self performSelector:@selector(removeRemoteNotification) withObject:nil afterDelay:1.0];

    switch (userConfig) {
        case 0:
            
            NSLog(@"Push通知すべてオフ");
            break;
        case 1:
            NSLog(@"Push通知バッヂのみオン");
            break;
        case 2:
            NSLog(@"Push通知サウンドだけオン");
            break;
        case 3:
            NSLog(@"Push通知バッヂとサウンドがオン");
            break;
        case 4:
            NSLog(@"Push通知アラート(テキスト)のみオン");
            break;
        case 5:
            NSLog(@"Push通知バッヂとアラート(テキスト)がオン");
            break;
        case 6:
            NSLog(@"Push通知サウンドとアラート(テキスト)がオン");
            break;
        case 7:
            NSLog(@"Push通知すべてオン");
            break;
            
            
        default:
            break;
    }
    
    // userInfoの中身
    // "aps" : { "alert": "アラートで表示されるもの", "sound": ""} Default
    // "aps" : { "alert": "アラートで表示されるもの", "sound": "", "a": { "b": "c", "d": "e" }}  アレンジ
    
    // "aps" : { "alert": "アラートで表示されるもの", "sound": "","badge":9999} Default
    
    // "aps" : { "alert": "犬です。", "sound": "dog.mp3"}
    // "aps" : { "alert": "猫です。", "sound": "cat.mp3"}
    // {"alert": "New Message","badge": 3,"sound": "dog.mp3","content-available": 1}
    // {"alert": "", "sound": "s.mp3","badge":32}
    
    
// このJSONでもOK
//    {
//        "aps":{
//            "alert": "New Message",
//            "badge": 3,
//            "sound": "sound1.aiff",
//            "content-available": 1
//        },
//        "name": "value"
//    }

    
    // 通知をタップして起動した時に呼ばれる(BecomeActive:より前に呼ばれる)
    if (application.applicationState == UIApplicationStateInactive) {
        // アプリケーションが起動中でない時(ロック画面から開いた時もここが呼ばれる)

        NSLog(@"UIApplicationStateInactive");
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
    
    NSMutableDictionary *mDict = [userInfo valueForKey:@"aps"];
    NSLog(@"alert = %@",[mDict valueForKey:@"alert"]);
    
    if (application.applicationState == UIApplicationStateActive) {
        // アプリケーションが起動中の時
        NSLog(@"UIApplicationStateActive");
        
        
        
        // インスタンス生成
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        // 5分後に通知をする（設定は秒単位）
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        // タイムゾーンの設定
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 通知時に表示させるメッセージ内容
        notification.alertBody = [mDict valueForKey:@"alert"];
        // 通知に鳴る音の設定
        notification.soundName = [mDict valueForKey:@"sound"];
        
        // 通知の登録
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (application.applicationState == UIApplicationStateBackground) {
        // アプリケーションがバックグラウンドの時("content-available"のキーが有る時のみ呼ばれる)
        NSLog(@"UIApplicationStateBackground");
    }
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    [mdict setObject:[mDict valueForKey:@"alert"] forKey:@"alert"];
    [mdict setObject:[mDict valueForKey:@"sound"] forKey:@"sound"];
    
    if ([mDict valueForKey:@"badge"]) {
        [mdict setObject:[mDict valueForKey:@"badge"] forKey:@"badge"];
    }
    
    
    
    // 通知の実行(通知名は"TestPost")
    // 通知先にデータを渡す場合はuserInfoにデータを指定
    [nc postNotificationName:@"TestPost"
                      object:self
                    userInfo:mdict];
    
    NSLog(@"呼ばれた！！ didReceiveRemoteNotification fetchCompletionHandler");
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateActive) {
        //パターン２：画面が既に表示されていて通知が飛んできた時に勝手に呼ばれる
        return;
    }
    
    if (application.applicationState == UIApplicationStateInactive) {
        //パターン３：アプリがバックグラウンドでは生きている時に通知をタップ
        return;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    UIRemoteNotificationType userConfig = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//    
//    NSLog(@"userConfig = %d",userConfig);
    
//    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
//    if (currentInstallation.badge != 0) {
//        currentInstallation.badge = 0;
//        [currentInstallation saveEventually];
//    }
//    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    
    [self removeRemoteNotification];
    
}

- (void)removeRemoteNotification
{
//    // アプリに登録されている全ての通知を削除
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive) {
        NSLog(@"Sent to background by locking screen");
    } else if (state == UIApplicationStateBackground) {
        // ホームボタンを押下してアプリを終了した時
        NSLog(@"Sent to background by home button/switching to other app");
    } 
}



#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}


@end
