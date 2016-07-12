//
//  UCSIPCCSDKLog.h
//  ucsipccsdk
//
//  Created by Jozo.Chan on 16/7/5.
//  Copyright © 2016年 i.Jozo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCSIPCCSDKLog : NSObject

+ (void) saveDemoLogInfo:(NSString *) summary withDetail:(NSString *) detail;
@end
