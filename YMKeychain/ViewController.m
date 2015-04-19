//
//  ViewController.m
//  YMKeychain
//
//  Created by Yiming on 15/4/19.
//  Copyright (c) 2015年 Henizaiyiqi. All rights reserved.
//

#import "ViewController.h"
#import "YMKeyChain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YMKeyChain setPassword:@"123456" forService:@"YMKeyChain" account:@"iYiming"];
    //[YMKeyChain passwordForService:@"YMKeyChain" account:@"iYiming"]; //获取密码
    //[YMKeyChain setPassword:@"1234567890" forService:@"YMKeyChain" account:@"iYiming"]; //重置密码
    //[YMKeyChain deletePasswordForService:@"YMKeyChain" account:@"iYiming"];//删除密码

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
