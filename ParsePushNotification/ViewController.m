//
//  ViewController.m
//  ParsePushNotification
//
//  Created by KentarOu on 2014/08/14.
//  Copyright (c) 2014年 KentarOu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *schemeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectSwitch;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSNotificationCenter *nc =
    [NSNotificationCenter defaultCenter];
    
    // 通知の受け取り登録("TestPost"という通知名の通知を受け取る)
    // 通知を受け取ったら自身のreceive:メソッドを呼び出す
    [nc addObserver:self selector:@selector(receive:) name:@"TestPost" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)applicationDidBecomeActive
{
    
//    // アプリに登録されている全ての通知を削除
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


/**
 * 通知を受け取ったときの処理
 * @param center 通知のインスタンス
 */
- (void)receive:(NSNotification *)center
{
     NSString *alert = [[center userInfo] objectForKey:@"alert"];
    _alertLabel.text = [NSString stringWithFormat:@"alert:%@",alert];
     NSString *sound = [[center userInfo] objectForKey:@"sound"];
    _soundLabel.text = [NSString stringWithFormat:@"sound:%@",sound];
    
    if ([[center userInfo] objectForKey:@"badge"]) {
        NSString *badge = [[center userInfo] objectForKey:@"badge"];
        _badgeLabel.text = [NSString stringWithFormat:@"badge:%@",badge];
    }
}

- (IBAction)cancelNotification:(id)sender
{
    if (_selectSwitch.on) {
        
        // アプリに登録されている全ての通知を削除
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSLog(@"cancelAllLocalNotifications");
    }
}

- (IBAction)clearButton:(id)sender
{
    _alertLabel.text = @"alert:";
    _soundLabel.text = @"sound:";
    _badgeLabel.text = @"badge:";
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
