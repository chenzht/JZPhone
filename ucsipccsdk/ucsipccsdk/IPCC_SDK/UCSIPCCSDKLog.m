//
//  UCSIPCCSDKLog.m
//  ucsipccsdk
//
//  Created by Jozo.Chan on 16/7/5.
//  Copyright © 2016年 i.Jozo. All rights reserved.
//

#import "UCSIPCCSDKLog.h"

@implementation UCSIPCCSDKLog


+ (void) saveDemoLogInfo:(NSString *) summary withDetail:(NSString *) detail
{
    //    NSLog(@"%@ -- %@", summary, detail);
    
    NSString *strSummary = nil;
    if (nil != summary)
    {
        strSummary = [summary retain];
    }
    else
    {
        strSummary = [[NSString alloc] initWithString:@""];
    }
    
    NSString *strDetail = @"";
    if (nil != detail)
    {
        strDetail = [detail retain];
    }
    else
    {
        strDetail = [[NSString alloc] initWithString:@""];
    }
    
    [UCSIPCCSDKLog demologc_Write:strSummary andStrDetail:strDetail];
    
}


/******/
//将日志写入指定文件
+(void) demologc_Write:(NSString*)strSummary andStrDetail:(NSString*)strDetail
{
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:yesterday]];
    [formatter release];
    
    NSString *url = [NSString stringWithFormat:@"\n\n=============sdk日志=============时间:%@\nSummary:\n%@\n\nstrDetail:\n%@\n\n",timeString,strSummary,strDetail];
    NSString *path = demo_applicationDocumentsDirectory();// stringByAppendingPathComponent:@"Exception.txt"];
    
    NSLog(@"%@",url);
    
    //一次性读写
    //    [url writeToFile:path atomically:YES encoding:(NSUTF8StringEncoding) error:nil];
    
    
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:path];
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    
    [outFile writeData:[url dataUsingEncoding:NSUTF8StringEncoding]];
    //关闭读写文件
    [outFile closeFile];
    
    
}
//日志存放路径
NSString *demo_applicationDocumentsDirectory()
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"ucs_ipccsdk"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentsDirectory])
    {
        NSError *err = nil;
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&err];
        
        NSString *filePathMe = [documentsDirectory stringByAppendingPathComponent:@"ios_ipcc_log.txt"];
        //查找文件，如果不存在，就创建一个文件
        if (![fileManager fileExistsAtPath:filePathMe])
        {
            [fileManager createFileAtPath:filePathMe contents:nil attributes:nil];
            
        }
        else
        {
            //如果文件存在并且它的大小大于1M，则删除并且重新创建一个
            long long filesizes  = [[fileManager attributesOfItemAtPath:filePathMe error:nil] fileSize];
            if ((filesizes/(1024.0*1024.0))>1) {
                
                //删除当前文件
                [fileManager removeItemAtPath:filePathMe error:nil];
                //重新创建一个文件
                [fileManager createFileAtPath:filePathMe contents:nil attributes:nil];
            }
            
        }
        
        if (err) {
            
            return nil;
        }
        else
        {
            return [documentsDirectory stringByAppendingPathComponent:@"ios_ipcc_log.txt"];
        }
    }
    else
    {
        return [documentsDirectory stringByAppendingPathComponent:@"ios_ipcc_log.txt"];
    }
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



@end
