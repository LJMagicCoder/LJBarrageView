//
//  LJBaseViewModel.h
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/5.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "LJBaseViewModelServices.h"

@class LJBaseNavigationService;

@interface LJBaseViewModel : NSObject

@property (nonatomic, strong, readonly) id<LJBaseViewModelServices> services;

//初始化信号
- (void)setUpSignal;

- (void)changeServices:(LJBaseNavigationService *)services;

@end
