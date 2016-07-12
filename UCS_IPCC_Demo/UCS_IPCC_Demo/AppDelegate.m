//
//  AppDelegate.m
//  UCS_IPCC_Demo
//
//  Created by Jozo.Chan on 16/6/29.
//  Copyright © 2016年 i.Jozo. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingViewController.h"
#import "DialerViewController.h"

#import "CallOutgoingView.h"
#import "CallIncomingView.h"

@interface AppDelegate () <UCSIPCCDelegate>
@property (nonatomic, strong) SettingViewController *vc;
@property (nonatomic, strong) DialerViewController *dialerVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma mark - 设置window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [UCSUserDefaultManager SetLocalDataString:@"UDP" key:@"login_transport"];         // 默认UDP接入
    [self setNotification];
    [self setUCSSDK];
    
    self.dialerVC = [DialerViewController new];
    
    self.window.rootViewController = self.dialerVC;
    
    return YES;
}


- (void)setNotification{
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callStateUpdateEvent:) name:kUCSCallUpdate object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdateEvent:) name:kUCSRegistrationUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userConfigSucceedEvent) name:@"addConfigSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userConfigSucceedEvent) name:@"removeConfigSucceed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goConfigEvent) name:@"goConfig" object:nil];
    
    
}

- (void)setUCSSDK {
    
    [[UCSIPCCManager instance] startUCSphone];
    
    [[UCSIPCCManager instance] setDelegate:self];
    
    NSString *name = [UCSUserDefaultManager GetLocalDataString:@"login_user_name"];
    NSString *password = [UCSUserDefaultManager GetLocalDataString:@"login_password"];
    NSString *domain = [UCSUserDefaultManager GetLocalDataString:@"login_domain"];
    NSString *port = [UCSUserDefaultManager GetLocalDataString:@"login_port"];
    NSString *transport = [UCSUserDefaultManager GetLocalDataString:@"login_transport"];
    NSString *displayName = [UCSUserDefaultManager GetLocalDataString:@"login_displayName"];
    
    if (name.length != 0 && password.length != 0 && domain.length != 0 && port.length != 0) {
        // 自动设置注册信息
        [[UCSIPCCManager instance] addProxyConfig:name password:password displayName:displayName domain:domain port:port withTransport:transport];
    }
    
    
}

/**
 @author Jozo, 16-06-30 15:06:51
 
 呼叫成功回调
 
 @param notif 通知传参
 */
//- (void)callStateUpdateEvent:(NSNotification *)notif {
//    
//    NSLog(@"%@", notif);
//    [self callStateUpdate:[[notif.userInfo objectForKey: @"state"] intValue] andCall:[[notif.userInfo objectForKey: @"call"] pointerValue]];
//}
//
//
//
//
//
//- (void)callStateUpdate:(UCSCallState)state andCall:(UCSCall *)call{
//    switch (state) {
//        case UCSCallOutgoingInit: {
//            CallOutgoingView *vc = [CallOutgoingView new];
//            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
//                
//            }];
//            break;
//        }
//            
//        case UCSCallIncomingReceived: {
//            
//            CallIncomingView *vc = [CallIncomingView new];
//            vc.call = call;
//            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
//                
//            }];
//            break;
//        }
//         
//            
//        case UCSCallConnected: {
//            
//            break;
//        }
//            
////        case UCSCallReleased:
//        case UCSCallEnd: {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"UCS_Call_Released" object:nil userInfo:nil];
//            break;
//        }
//            
//        default:
//            break;
//            
//    }
//}

- (void)userConfigSucceedEvent {
    
    self.vc = nil;
    self.dialerVC = [DialerViewController new];
    self.window.rootViewController = self.dialerVC;
}

- (void)goConfigEvent {
    // 进入设置
    self.dialerVC = nil;
//    self.vc = (ViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    self.vc = [SettingViewController new];
    self.window.rootViewController = self.vc;
}


- (void)onRegisterStateChange:(UCSRegistrationState)state message:(const char *)message
{
//    NSLog(@"{\nstate:%d, \nmessage:%s\n}", state, message);
    [self.dialerVC onRegisterStateChange:state message:message];
}

- (void)onOutgoingCall:(UCSCall *)call withState:(UCSCallState)state withMessage:(NSDictionary *)message
{
    CallOutgoingView *vc = [CallOutgoingView new];
    [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)onIncomingCall:(UCSCall *)call withState:(UCSCallState)state withMessage:(NSDictionary *)message
{
    CallIncomingView *vc = [CallIncomingView new];
    vc.call = call;
    [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)onDialFailed:(UCSCallState)state withMessage:(NSDictionary *)message {
    [SVProgressHUD showErrorWithStatus:@"请输入正确的号码"];
}

- (void)onHangUp:(UCSCall *)call withState:(UCSCallState)state withMessage:(NSDictionary *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UCS_Call_Released" object:nil userInfo:nil];
}

//- (void)onCall:(UCSCall *)call StateChanged:(UCSCallState)state withMessage:(NSDictionary *)message
//{
////    NSLog(@"{\nstate:%d, \nmessage:%s\n}", state, message);
//    switch (state) {
//        case UCSCallOutgoingInit: {
//            CallOutgoingView *vc = [CallOutgoingView new];
//            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
//                
//            }];
//            break;
//        }
//            
//        case UCSCallIncomingReceived: {
//            
//            CallIncomingView *vc = [CallIncomingView new];
//            vc.call = call;
//            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
//                
//            }];
//            break;
//        }
//            
//            
//        case UCSCallConnected: {
//            
//            break;
//        }
//            
//        case UCSCallReleased:
//        case UCSCallEnd: {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"UCS_Call_Released" object:nil userInfo:nil];
//            break;
//        }
//            
//        case UCSCallNumberError: {
//
//            [SVProgressHUD showErrorWithStatus:@"请输入正确的号码"];
//            break;
//        }
//            
//        default:
//            break;
//            
//    }
//
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
