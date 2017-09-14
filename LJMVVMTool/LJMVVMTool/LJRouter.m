//
//  LJRouter.m
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/6.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LJRouter.h"
#import "LJBaseViewController.h"
#import "LJBaseViewModel.h"

@interface LJRouter ()

@property (nonatomic ,strong) MappingBlock block;

@end

@implementation LJRouter

+ (instancetype)sharedManager {
    static LJRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (LJBaseViewController *)viewControllerWithViewModel:(LJBaseViewModel *)viewModel {
    
    NSString *viewController = self.mappings[NSStringFromClass(viewModel.class)];
    
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[LJBaseViewController class]]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)mappings {
    if (!self.block) return @{};
    return self.block();
}

- (void)viewModelWithMapping:(MappingBlock)block {
    self.block = block;
}

@end
