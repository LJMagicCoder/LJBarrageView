//
//  LoginViewModel.m
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/5.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LoginViewModel.h"
#import "NextViewModel.h"

@implementation LoginViewModel

//初始化信号配置
- (void)setUpSignal {
    [super setUpSignal];
    
    // 1.处理是否可以点击登录的信号
    _loginEnableSiganl = [RACSignal combineLatest:@[RACObserve(self, accountString),RACObserve(self, pwdString)] reduce:^id(NSString *account,NSString *pwd){
        return @(account.length && pwd.length);
    }];
    
    // 2.处理登录点击命令
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            // 发送数据
            [subscriber sendNext:@"请求登录的数据"];
            [subscriber sendCompleted];
            
            return nil;
            
        }];
    }];
    
    // 3.处理登录请求返回的结果
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.处理登录执行过程
    [[_loginCommand.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            //添加蒙版
            //[MBProgressHUD showMessage:@"正在登录ing.."];
        }else{
            //执行完成
            //解除蒙版
            //[MBProgressHUD hideHUD];
            //push(只需要将下一个界面所需的viewModel传入就可以跳转)
            [self.services pushViewModel:[NextViewModel new] animated:YES];
            NSLog(@"执行完成");
        }
        
    }];
    
}

@end
