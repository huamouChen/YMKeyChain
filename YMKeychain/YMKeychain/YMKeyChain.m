//
//  YMKeyChain.m
//  YMKeychain
//
//  Created by Yiming on 15/4/19.
//  Copyright (c) 2015年 Henizaiyiqi. All rights reserved.
//

#import "YMKeyChain.h"

@implementation YMKeyChain

/**
 *  @author iYiming, 15-04-19 22:20:51
 *
 *  设置密码（添加密码、修改密码）
 *
 *  @param password    密码
 *  @param serviceName 服务名称
 *  @param account     账户名称
 *
 *  @return 是否设置成功
 */
+ (BOOL) setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account{
    NSMutableDictionary *keyChainDic = [[NSMutableDictionary alloc] init];
    [keyChainDic setObject:account forKey:(__bridge id)kSecAttrAccount];
    [keyChainDic setObject:serviceName forKey:(__bridge id)kSecAttrService];
    [keyChainDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [keyChainDic setObject:[password dataUsingEncoding:NSUTF8StringEncoding]
                    forKey:(__bridge id)kSecValueData];
    [keyChainDic setObject:(__bridge id)kCFBooleanTrue
                    forKey:(__bridge id)kSecReturnAttributes];
    [keyChainDic setObject:(__bridge id)kCFBooleanTrue
                    forKey:(__bridge id)kSecReturnData];
    
    CFMutableDictionaryRef outDictionary = nil;
    OSStatus keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)keyChainDic,
                                               (CFTypeRef *)&outDictionary);
    
    BOOL resultState = NO;
    if (keychainErr == noErr) {
        NSMutableDictionary *returnDictionary = [NSMutableDictionary
                                                 dictionaryWithDictionary:(__bridge_transfer NSMutableDictionary *)outDictionary];
        [returnDictionary setObject:(__bridge id)kSecClassGenericPassword
                             forKey:(__bridge id)kSecClass];
        
        [keyChainDic removeObjectForKey:(__bridge id)kSecAttrAccount];
        [keyChainDic removeObjectForKey:(__bridge id)kSecAttrService];
        [keyChainDic removeObjectForKey:(__bridge id)kSecClass];
        [keyChainDic removeObjectForKey:(__bridge id)kSecReturnAttributes];
        [keyChainDic removeObjectForKey:(__bridge id)kSecReturnData];
        OSStatus errorCode = SecItemUpdate((__bridge CFDictionaryRef)returnDictionary, (__bridge CFDictionaryRef)keyChainDic);
        
        if (errorCode == noErr) {
            resultState = YES;
        }else{
            resultState = NO;
        }
    }else if (keychainErr == errSecItemNotFound) {
        //添加
        OSStatus errorCode = SecItemAdd(
                                        (__bridge CFDictionaryRef)keyChainDic,
                                        NULL);
        
        if (errorCode == noErr) {
            resultState = YES;
        }else{
            resultState = NO;
        }
    }
    
    return resultState;
}

/**
 *  @author iYiming, 15-04-19 22:21:38
 *
 *  获取密码
 *
 *  @param serviceName 服务名称
 *  @param account     账户名称
 *
 *  @return 密码
 */
+ (NSString *) passwordForService:(NSString *)serviceName account:(NSString *)account
{
    NSMutableDictionary *keyChainDic = [[NSMutableDictionary alloc] init];
    [keyChainDic setObject:account forKey:(__bridge id)kSecAttrAccount];
    [keyChainDic setObject:serviceName forKey:(__bridge id)kSecAttrService];
    [keyChainDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [keyChainDic setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDataRef passwordData = NULL;
    OSStatus keychainError = noErr;
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)keyChainDic,
                                        (CFTypeRef *)&passwordData);
    
    NSString *pwdStr = nil;
    if (keychainError == noErr){
        NSString *passwordString = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData *)passwordData bytes]
                                                            length:[(__bridge NSData *)passwordData length] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",passwordString);
        pwdStr = passwordString;
    }else if (keychainError == errSecItemNotFound) {
        pwdStr = nil;
    }
    
    return pwdStr;
}

/**
 *  @author iYiming, 15-04-19 22:22:10
 *
 *  删除密码
 *
 *  @param serviceName 服务名称
 *  @param account     账户名称
 *
 *  @return 是否删除成功状态
 */
+ (BOOL) deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
    NSMutableDictionary *keyChainDic = [[NSMutableDictionary alloc] init];
    [keyChainDic setObject:account forKey:(__bridge id)kSecAttrAccount];
    [keyChainDic setObject:serviceName forKey:(__bridge id)kSecAttrService];
    [keyChainDic setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [keyChainDic setObject:(__bridge id)kCFBooleanTrue
                    forKey:(__bridge id)kSecReturnAttributes];
    
    CFMutableDictionaryRef outDictionary = nil;
    
    OSStatus keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)keyChainDic,
                                                 (CFTypeRef *)&outDictionary);
    BOOL resultState = NO;
    
    if (keychainError == noErr){
        NSString *pwd = [YMKeyChain passwordForService:serviceName account:account];
        
        [keyChainDic setObject:[pwd dataUsingEncoding:NSUTF8StringEncoding]
                             forKey:(__bridge id)kSecValueData];
        
        
        OSStatus keychainError =  SecItemDelete((__bridge CFDictionaryRef)keyChainDic);
        if (keychainError == noErr){
            resultState = YES;
        }else{
            resultState = NO;
        }
    }
    
    return resultState;
}

@end
