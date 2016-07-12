//
//  UCSUserDefaultManager.m
//  UCSVoipDemo
//
//  Created by tongkucky on 14-6-26.
//  Copyright (c) 2014年 UCS. All rights reserved.
//

#import "UCSUserDefaultManager.h"

@implementation UCSUserDefaultManager



// 从本地数据库获对应key值下的数据(字符串)
// aKey : key值
// 返回值，返回key值下的数据
+ (NSString *) GetLocalDataString:(NSString *)aKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || nil == aKey) {
        return nil;
    }
    
    NSString *strRet = [defaults objectForKey:aKey];
    
    return strRet;
}

/**
 *  // 设置本地数据库对应key值下的数据(字符串)
 *  // aValue   : 要保存的数据
 *  // aKey     : key值
 */
+ (void)SetLocalDataString:(NSString *)aValue key:(NSString *)aKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || nil == aKey)
    {
        return;
    }
    
    [defaults setValue:aValue forKey:aKey];
}



// 从本地数据库获对应key值下的数据(Object)
+ (id) GetLocalDataObject:(NSString *)aKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey)
    {
        return nil;
    }
    
    id strRet = [defaults objectForKey:aKey];
    
    return strRet;
}



// 设置本地数据库对应key值下的数据(字object串)
+ (void) SetLocalDataObject:(id)aValue key:(NSString *)aKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey)
    {
        return;
    }
    
    [defaults setObject:aValue forKey:aKey];
}

// 从本地数据库获对应key值下的数据(bool)
// aKey     : key值
// 返回值，返回存储的bool值
+ (bool) GetLocalDataBoolen:(NSString *)aKey
{
    bool bRet = false;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey)
    {
        bRet = false;
    }
    else
    {
        bRet = [defaults boolForKey:aKey];
    }
    
    return bRet;
}

// 设置本地数据库对应key值下的数据(bool)
// bValue   : 要保存的BOOL值
// aKey     : key值
+ (void) SetLocalDataBoolen:(bool)bValue key:(NSString *)aKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey)
    {
        return;
    }
    
    [defaults setBool:bValue forKey:aKey];
}




@end
