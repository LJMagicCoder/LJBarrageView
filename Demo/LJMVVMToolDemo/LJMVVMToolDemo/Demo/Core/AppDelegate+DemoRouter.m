//
//  AppDelegate+DemoRouter.m
//  LJMVVMToolDemo
//
//  Created by 宋立军 on 2017/9/12.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "AppDelegate+DemoRouter.h"
#import "LJRouter.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation AppDelegate (DemoRouter)

- (void)demoRouter {
    @weakify(self)
    [[LJRouter sharedManager] viewModelWithMapping:^NSDictionary *{
        @strongify(self)
        return [self viewModelWithMapping];
    }];
    
}

- (NSDictionary *)viewModelWithMapping {
    return @{
             @"LoginViewModel":@"LoginViewController",
             @"NextViewModel":@"NextViewController"
             };
}

@end
