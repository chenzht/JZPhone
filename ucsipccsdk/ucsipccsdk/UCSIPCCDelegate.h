//
//  UCSIPCCDelegate.h
//  ucsipccsdk
//
//  Created by Jozo.Chan on 16/6/30.
//  Copyright © 2016年 i.Jozo. All rights reserved.
//

#ifndef UCSIPCCDelegate_h
#define UCSIPCCDelegate_h
#import "UCSIPCCClass.h"
@protocol UCSIPCCDelegate <NSObject>
@optional


//  登陆状态变化回调
- (void)onRegisterStateChange:(UCSRegistrationState) state message:(const char*) message;

// 发起来电回调
- (void)onOutgoingCall:(UCSCall *)call withState:(UCSCallState)state withMessage:(NSDictionary *) message;

// 收到来电回调
- (void)onIncomingCall:(UCSCall *)call withState:(UCSCallState)state withMessage:(NSDictionary *) message;

// 接听回调
-(void)onAnswer:(UCSCall *)call withState:(UCSCallState)state withMessage:(NSDictionary *) message;

// 释放通话回调
- (void)onHangUp:(UCSCall *)call withState:(UCSCallState)state withMessage:(NSDictionary *) message;

// 呼叫失败回调
- (void)onDialFailed:(UCSCallState)state withMessage:(NSDictionary *) message;


@end

#endif /* UCSIPCCDelegate_h */
