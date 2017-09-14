//
//  LJRouter.h
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/6.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LJBaseViewController,LJBaseViewModel;

typedef NSDictionary *(^MappingBlock)();

@interface LJRouter : NSObject

+ (instancetype)sharedManager;

- (LJBaseViewController *)viewControllerWithViewModel:(LJBaseViewModel *)viewModel;

//调用此方法进行映射管理
- (void)viewModelWithMapping:(MappingBlock)block;

@end
