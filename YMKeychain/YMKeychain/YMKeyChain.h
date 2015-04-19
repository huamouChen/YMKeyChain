//
//  YMKeyChain.h
//  YMKeychain
//
//  Created by Yiming on 15/4/19.
//  Copyright (c) 2015年 Henizaiyiqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMKeyChain : NSObject

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
+ (BOOL) setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account;

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
+ (NSString *) passwordForService:(NSString *)serviceName account:(NSString *)account;

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
+ (BOOL) deletePasswordForService:(NSString *)serviceName account:(NSString *)account;

@end
