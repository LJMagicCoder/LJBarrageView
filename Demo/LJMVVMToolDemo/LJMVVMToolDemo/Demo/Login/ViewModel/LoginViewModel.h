//
//  LoginViewModel.h
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/5.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJBaseViewModel.h"

@interface LoginViewModel : LJBaseViewModel

//登录账号
@property (nonatomic, strong) NSString *accountString;

//登录密码
@property (nonatomic, strong) NSString *pwdString;
    
//登录按钮点击许可
@property (nonatomic, strong, readonly) RACSignal *loginEnableSiganl;
    
//登录按钮返回信号
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end

