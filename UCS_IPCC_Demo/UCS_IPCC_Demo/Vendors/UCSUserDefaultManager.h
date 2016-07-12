//
//  UCSUserDefaultManager.h
//  UCSVoipDemo
//
//  Created by tongkucky on 14-6-26.
//  Copyright (c) 2014年 UCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCSUserDefaultManager : NSObject

+ (NSString *) GetLocalDataString:(NSString *)aKey;
/**
 *  // 设置本地数据库对应key值下的数据(字符串)
 *  // aValue   : 要保存的数据
 *  // aKey     : key值
 */
+ (void)SetLocalDataString:(NSString *)aValue key:(NSString *)aKey;
+ (id) GetLocalDataObject:(NSString *)aKey;
+ (void) SetLocalDataObject:(id)aValue key:(NSString *)aKey;
+ (bool) GetLocalDataBoolen:(NSString *)aKey;
+ (void) SetLocalDataBoolen:(bool)bValue key:(NSString *)aKey;

@end
