//
//  UCSIPCCManager.h
//  ucsipccsdk
//
//  Created by Jozo.Chan on 16/6/29.
//  Copyright © 2016年 i.Jozo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSIPCCDelegate.h"
#import "UCSIPCCClass.h"

@interface UCSIPCCManager : NSObject<UCSIPCCDelegate>

@property (nonatomic, readwrite, assign) id<UCSIPCCDelegate> delegate;      // 回调代理
@property (nonatomic, assign) BOOL speakerEnabled;                              // 是否打开扬声器
@property (nonatomic, assign, readonly) BOOL isUCSReady;                    // UCS是否已初始化
@property (nonatomic, assign, readonly) UCSCall *currentCall;                 // 当前通话



/**
 单例对象
 */
+ (UCSIPCCManager*)instance;

/**
 初始化
 */
-(void)startUCSphone;


/**
 设置登陆信息
 */
- (BOOL)addProxyConfig:(NSString*)username password:(NSString*)password displayName:(NSString *)displayName domain:(NSString*)domain port:(NSString *)port withTransport:(NSString*)transport;


/**
 注销登陆信息
 */
- (void)removeAccount;


/**
 拨打电话
 */
- (void)call:(NSString *)address displayName:(NSString*)displayName transfer:(BOOL)transfer;


/**
 接听通话
 */
- (void)acceptCall:(UCSCall *)call;


/**
 挂断通话
 */
- (void)hangUpCall;


/**
 获取通话时长
 */
- (int)getCallDuration;


/**
获取对方号码
*/
- (NSString *)getRemoteAddress;


/**
 获取对方昵称
 */
- (NSString *)getRemoteDisplayName;


/**
获取通话参数
*/
- (UCSCallParams *)getCallParams;


/**
 将int转为标准格式的NSString时间
 */
+ (NSString *)durationToString:(int)duration;

@end
