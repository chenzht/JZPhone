//
//  UCSIPCCClass.h
//  ucsipccsdk
//
//  Created by Jozo.Chan on 16/6/30.
//  Copyright © 2016年 i.Jozo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCSIPCCClass : NSObject


typedef enum _UCSRegistrationState{
    UCSRegistrationNone, /**<登陆信息初始化*/
    UCSRegistrationProgress, /**<登陆中 */
    UCSRegistrationOk,	/**< 登陆成功 */
    UCSRegistrationCleared, /**< 注销成功 */
    UCSRegistrationFailed	/**<登陆失败 */
}UCSRegistrationState;


typedef enum _UCSCallState{
    UCSCallIdle,					/**<通话初始化 */
    UCSCallIncomingReceived, /**<收到来电 */
    UCSCallOutgoingInit, /**<呼出电话初始化 */
    UCSCallOutgoingProgress, /**<呼出电话拨号中 */
    UCSCallOutgoingRinging, /**<呼出电话正在响铃 */
    UCSCallOutgoingEarlyMedia, /**<An outgoing call is proposed early media */
    UCSCallConnected, /**<通话连接成功*/
    UCSCallStreamsRunning, /**媒体流已建立*/
    UCSCallPausing, /**<通话暂停中 */
    UCSCallPaused, /**< 通话暂停成功*/
    UCSCallResuming, /**<通话被恢复*/
    UCSCallRefered, /**通话转移*/
    UCSCallError, /**<通话错误*/
    UCSCallEnd, /**<通话正常结束*/
    UCSCallPausedByRemote, /**<通话被对方暂停*/
    UCSCallUpdatedByRemote, /**<对方请求更新通话参数 */
    UCSCallIncomingEarlyMedia, /**<We are proposing early media to an incoming call */
    UCSCallUpdating, /**<A call update has been initiated by us */
    UCSCallReleased, /**< 通话被释放 */
    UCSCallEarlyUpdatedByRemote, /*<通话未应答.*/
    UCSCallEarlyUpdating, /*<通话未应答我方*/
    UCSCallNumberError /*<号码有误*/
} UCSCallState;

extern NSString *const kUCSRegistrationUpdate;

extern NSString *const kUCSCallUpdate;

extern NSString *const kUCSCoreUpdate;

// 通话strut
typedef struct _LinphoneCall UCSCall;
typedef struct _LinphoneCallParams UCSCallParams;

@end
