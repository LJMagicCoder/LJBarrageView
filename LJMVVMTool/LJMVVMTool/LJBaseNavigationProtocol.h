//
//  LJBaseNavigationProtocol.h
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/6.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VoidBlock)();

@class LJBaseViewModel;

@protocol LJBaseNavigationProtocol <NSObject>

- (void)pushViewModel:(LJBaseViewModel *)viewModel animated:(BOOL)animated;

- (void)popViewModelAnimated:(BOOL)animated;

- (void)popToRootViewModelAnimated:(BOOL)animated;

- (void)presentViewModel:(LJBaseViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion;

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion;

@end
