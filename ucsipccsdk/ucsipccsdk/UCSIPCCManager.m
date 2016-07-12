//
//  UCSIPCCManager.m
//  ucsipccsdk
//
//  Created by Jozo.Chan on 16/6/29.
//  Copyright © 2016年 i.Jozo. All rights reserved.
//

#import "UCSIPCCManager.h"

#define LC ([LinphoneManager getLc])

@interface UCSIPCCManager() {
@public
    NSDictionary *dict;
    NSDictionary *changedDict;
}

@end

@implementation UCSIPCCManager

static UCSIPCCManager* theUCSIPCCManager = nil;
static id _ucsIPCCDelegate =nil; //代理对象，用于回调

/**
 @author Jozo, 16-06-30 11:06:07
 
 实例化
 */
+ (UCSIPCCManager*)instance {
    if(theUCSIPCCManager == nil) {
        theUCSIPCCManager = [UCSIPCCManager new];
    }
    return theUCSIPCCManager;
}

- (id)init {
    self = [super init];
    if (self) {
        dict = [[NSMutableDictionary alloc] init];
        changedDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/**
 @author Jozo, 16-07-01 15:07:51
 
 扬声器状态
 */
- (BOOL)speakerEnabled {
    return [LinphoneManager instance].speakerEnabled;
}
- (void)setSpeakerEnabled:(BOOL)speakerEnabled {
    [UCSIPCCSDKLog saveDemoLogInfo:[NSString stringWithFormat:@"设置扬声器为%d", speakerEnabled] withDetail:nil];
    [[LinphoneManager instance] setSpeakerEnabled:speakerEnabled];
}


/**
 @author Jozo, 16-07-01 15:07:37
 
 获取当前通话
 */
- (UCSCall *)currentCall {
    return linphone_core_get_current_call(LC) ? linphone_core_get_current_call(LC) : nil;
}


/**
 @author Jozo, 16-07-01 15:07:06
 
 UCS是否已经准备好
 */
- (BOOL)isUCSReady {
     return [LinphoneManager isLcReady];
}


/*!
 *  @brief  设置代理
 */
//- (void)setDelegate:(id<UCSIPCCDelegate>)delegate
//{
//    [UCSIPCCManager instance].delegate = delegate;
////    _ucsIPCCDelegate = delegate;
//}


/**
 @author Jozo, 16-06-30 11:06:18
 
 初始化
 */
- (void)startUCSphone {
    
    [[LinphoneManager instance] startLibLinphone];
    [UCSIPCCSDKLog saveDemoLogInfo:@"初始化成功" withDetail:nil];
    
}


/**
 @author Jozo, 16-06-30 11:06:13
 
 登陆
 
 @param username  用户名
 @param password  密码
 @param displayName  昵称
 @param domain    域名或IP
 @param port      端口
 @param transport 连接方式

 */
- (BOOL)addProxyConfig:(NSString*)username password:(NSString*)password displayName:(NSString *)displayName domain:(NSString*)domain port:(NSString *)port withTransport:(NSString*)transport {
    LinphoneCore* lc = [LinphoneManager getLc];
    
    if (lc == nil) {
        [self startUCSphone];
        lc = [LinphoneManager getLc];
    }
    
    LinphoneProxyConfig* proxyCfg = linphone_core_create_proxy_config(lc);
    NSString* server_address = domain;
    
    char normalizedUserName[256];
    linphone_proxy_config_normalize_number(proxyCfg, [username cStringUsingEncoding:[NSString defaultCStringEncoding]], normalizedUserName, sizeof(normalizedUserName));
    
    
    const char *identity = [[NSString stringWithFormat:@"sip:%@@%@", username, domain] cStringUsingEncoding:NSUTF8StringEncoding];
    
    LinphoneAddress* linphoneAddress = linphone_address_new(identity);
    linphone_address_set_username(linphoneAddress, normalizedUserName);
    if (displayName && displayName.length != 0) {
        linphone_address_set_display_name(linphoneAddress, (displayName.length ? displayName.UTF8String : NULL));
    }
    if( domain && [domain length] != 0) {
        if( transport != nil ){
            server_address = [NSString stringWithFormat:@"%@:%@;transport=%@", server_address, port, [transport lowercaseString]];
        }
        // when the domain is specified (for external login), take it as the server address
        linphone_proxy_config_set_server_addr(proxyCfg, [server_address UTF8String]);
        linphone_address_set_domain(linphoneAddress, [domain UTF8String]);
        
    }
    
    // 添加了昵称后的identity
    identity = linphone_address_as_string(linphoneAddress);
    
//    char* extractedAddres = linphone_address_as_string_uri_only(linphoneAddress);
    linphone_address_destroy(linphoneAddress);
//    LinphoneAddress* parsedAddress = linphone_address_new(extractedAddres);
//    ms_free(extractedAddres); // 释放
    
//    if( parsedAddress == NULL || !linphone_address_is_sip(parsedAddress) ){
//        if( parsedAddress ) linphone_address_destroy(parsedAddress);
//        UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Check error(s)",nil)
//                                                            message:NSLocalizedString(@"Please enter a valid username", nil)
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"Continue",nil)
//                                                  otherButtonTitles:nil,nil];
//        [errorView show];
//        return FALSE;
//    }
//    
//    char *c_parsedAddress = linphone_address_as_string_uri_only(parsedAddress);
////    linphone_proxy_config_set_identity(proxyCfg, c_parsedAddress);
//    linphone_address_destroy(parsedAddress);
    LinphoneAuthInfo* info = linphone_auth_info_new([username UTF8String]
                                                    , NULL, [password UTF8String]
                                                    , NULL
                                                    , linphone_proxy_config_get_realm(proxyCfg)
                                                    ,linphone_proxy_config_get_domain(proxyCfg));
    
    [self setDefaultSettings:proxyCfg];
    
    [self clearProxyConfig];
    
//    linphone_core_clear_all_auth_info(lc);
    linphone_proxy_config_set_identity(proxyCfg, identity);
    linphone_proxy_config_set_expires(proxyCfg, 2000);
    linphone_proxy_config_enable_register(proxyCfg, true);
    linphone_core_add_auth_info(lc, info);
    linphone_core_add_proxy_config(lc, proxyCfg);
    linphone_core_set_default_proxy_config(lc, proxyCfg);
    ms_free(identity);

    
    [UCSIPCCSDKLog saveDemoLogInfo:@"登陆信息配置成功" withDetail:[NSString stringWithFormat:@"username:%@,\npassword:%@,\ndisplayName:%@\ndomain:%@,\nport:%@\ntransport:%@", username, password, displayName, domain, port, transport]];
    

    
    return TRUE;
}


/**
 @author Kohler, 16-07-04 17:07:33
 
 注销登陆信息
 */
- (void)removeAccount {
    [UCSIPCCSDKLog saveDemoLogInfo:@"注销登陆信息" withDetail:nil];
    if (self.isUCSReady == YES) {
        [self clearProxyConfig];
//        [[LinphoneManager instance] destroyLibLinphone];
        [[LinphoneManager instance] lpConfigSetBool:FALSE forKey:@"pushnotification_preference"];
        
        LinphoneCore *lc = [LinphoneManager getLc];
        LCSipTransports transportValue={5060,5060,-1,-1};
        
        if (linphone_core_set_sip_transports(lc, &transportValue)) {
            [LinphoneLogger logc:LinphoneLoggerError format:"cannot set transport"];
        }
        
        [[LinphoneManager instance] lpConfigSetString:@"" forKey:@"sharing_server_preference"];
        [[LinphoneManager instance] lpConfigSetBool:FALSE forKey:@"ice_preference"];
        [[LinphoneManager instance] lpConfigSetString:@"" forKey:@"stun_preference"];
        linphone_core_set_stun_server(lc, NULL);
        linphone_core_set_firewall_policy(lc, LinphonePolicyNoFirewall);
    }
}


- (void)clearProxyConfig {
    linphone_core_clear_proxy_config([LinphoneManager getLc]);
    linphone_core_clear_all_auth_info([LinphoneManager getLc]);
}


- (void)setDefaultSettings:(LinphoneProxyConfig*)proxyCfg {
    LinphoneManager* lm = [LinphoneManager instance];
    
    [lm configurePushTokenForProxyConfig:proxyCfg];
    
}


/**
 @author Jozo, 16-06-30 11:06:52
 
 拨打电话
 
 @param address     ID
 @param displayName 昵称
 @param transfer    transfer
 */
- (void)call:(NSString *)address displayName:(NSString*)displayName transfer:(BOOL)transfer {
    // 号码有效性判断
    if (![self checkPhoneNumInput:address]) {
        
        [UCSIPCCSDKLog saveDemoLogInfo:@"请输入正确的号码" withDetail:[NSString stringWithFormat:@"address:%@,\ndisplayName:%@", address, displayName]];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"号码错误，请输入正确的号码" forKey:@"message"];
        [self.delegate onDialFailed:UCSCallNumberError withMessage:dic];
        return;
    }
    
    [[LinphoneManager instance] call:address displayName:displayName transfer:transfer];
    [UCSIPCCSDKLog saveDemoLogInfo:@"拨打电话操作" withDetail:[NSString stringWithFormat:@"address:%@,\ndisplayName:%@", address, displayName]];
}


/**
 @author Jozo, 16-06-30 20:06:43
 
 接听电话
 */
- (void)acceptCall:(UCSCall *)call {
    [[LinphoneManager instance] acceptCall:call];
    [UCSIPCCSDKLog saveDemoLogInfo:@"接听电话操作" withDetail:nil];
}


/**
 @author Jozo, 16-06-30 11:06:41
 
 挂断电话
 */
- (void)hangUpCall {
    
    LinphoneCore* lc = [LinphoneManager getLc];
    LinphoneCall* currentcall = linphone_core_get_current_call(lc);
    if (linphone_core_is_in_conference(lc) || // In conference
        (linphone_core_get_conference_size(lc) > 0) // Only one conf
        ) {
        linphone_core_terminate_conference(lc);
    } else if(currentcall != NULL) { // In a call
        linphone_core_terminate_call(lc, currentcall);
    } else {
        const MSList* calls = linphone_core_get_calls(lc);
        if (ms_list_size(calls) == 1) { // Only one call
            linphone_core_terminate_call(lc,(LinphoneCall*)(calls->data));
        }
    }
    
//    [UCSIPCCSDKLog saveDemoLogInfo:@"挂断电话成功" withDetail:nil];
}


/**
 @author Jozo, 16-06-30 17:06:47
 
 获取通话状态
 */
- (UCSCallState)getCallState:(UCSCall *)call {
    return linphone_call_get_state(call);
}


/**
 @author Jozo, 16-06-30 18:06:06
 
 获取通话时长
 */
- (int)getCallDuration {
    if (LC == nil || self.isUCSReady == NO) {
        return 0;
    }
    int duration =
    linphone_core_get_current_call(LC) ? linphone_call_get_duration(linphone_core_get_current_call(LC)) : 0;
    
    return duration;
}


/**
 @author Jozo, 16-06-30 18:06:19
 
 获取对方号码
 */
- (NSString *)getRemoteAddress {
    if (self.currentCall == nil) {
        return nil;
    }
    LinphoneAddress *address = linphone_call_get_remote_address(self.currentCall);
    
    char *uri = linphone_address_as_string_uri_only(address);
    NSString *addressStr = [NSString stringWithUTF8String:uri];
    NSString *normalizedSipAddress = [[addressStr
                                       componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@" "];
    LinphoneAddress *addr = linphone_core_interpret_url(LC, [addressStr UTF8String]);
    
    if (addr != NULL) {
        linphone_address_clean(addr);
        char *tmp = linphone_address_as_string(addr);
        normalizedSipAddress = [NSString stringWithUTF8String:tmp];
        ms_free(tmp);
        linphone_address_destroy(addr);
    }
    
//    char *name = linphone_address_get_username(address);
//    NSString *addressStr = [NSString stringWithUTF8String:name];
   
    return addressStr;
}


/**
 @author Jozo, 16-06-30 18:06:19
 
 获取对方昵称
 */
- (NSString *)getRemoteDisplayName {
    if (self.currentCall == nil) {
        return nil;
    }
    LinphoneAddress *address = linphone_core_get_current_call_remote_address(LC);
//    LinphoneAddress *parsed = linphone_core_get_primary_contact_parsed(LC);
    
    char *uri = linphone_address_get_display_name(address);
    if (uri) {
        return [NSString stringWithUTF8String:uri];
    }
    return @"";
}


/**
 @author Jozo, 16-07-04 09:07:50
 
 获取通话参数
 */
- (UCSCallParams *)getCallParams {
    if (!self.currentCall) {
        return nil;
    }
    return linphone_call_get_current_params(self.currentCall);
}




/**
 @author Jozo, 16-07-01 15:07:19
 
  将int转为标准格式的NSString时间
 */
+ (NSString *)durationToString:(int)duration {
    NSMutableString *result = [[NSMutableString alloc] init];
    if (duration / 3600 > 0) {
        [result appendString:[NSString stringWithFormat:@"%02i:", duration / 3600]];
        duration = duration % 3600;
    }
    return [result stringByAppendingString:[NSString stringWithFormat:@"%02i:%02i", (duration / 60), (duration % 60)]];
}


- (BOOL)checkPhoneNumInput:(NSString *)mobileNum
{
    if (mobileNum.length == 14)
    {
        return YES;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
    * 大陆地区固话及小灵通
    * 区号：010,020,021,022,023,024,025,027,028,029
    * 号码：七位或八位
    */
     NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//+ (LinphoneAddress *)normalizeSipOrPhoneAddress:(NSString *)value {
//    if (!value) {
//        return NULL;
//    }
//    
//    LinphoneProxyConfig *cfg = linphone_core_get_default_proxy_config(LC);
//    LinphoneAddress *addr = linphone_proxy_config_normalize_sip_uri(cfg, value.UTF8String);
//    
//    // since user wants to escape plus, we assume it expects to have phone numbers by default
//    if (addr && cfg && linphone_proxy_config_get_dial_escape_plus(cfg)) {
//        char *phone = linphone_proxy_config_normalize_phone_number(cfg, value.UTF8String);
//        if (phone) {
//            linphone_address_set_username(addr, phone);
//            ms_free(phone);
//        }
//    }
//
//    return addr;
//}


@end
