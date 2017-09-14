//
//  LJBaseViewModel.m
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/5.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LJBaseViewModel.h"
#import "LJRouter.h"
#import <objc/runtime.h>
#import "LJBaseNavigationService.h"
#import "LJBaseViewController+LJMethod.h"

@interface LJBaseViewModel()

@property (nonatomic, strong) id<LJBaseViewModelServices> services;

@end

@implementation LJBaseViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    LJBaseViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel rac_signalForSelector:@selector(init)] subscribeNext:^(id x) {
        @strongify(viewModel)
        [viewModel setUpSignal];
        [viewModel registerNavigationMethodHooks];
        
    }];
    
    return viewModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)changeServices:(LJBaseNavigationService *)services {
    
    self.services = services;
    [self registerNavigationMethodHooks];
}

- (void)setUpSignal {}

-(id<LJBaseViewModelServices>)services {
    
    if (!_services) {
        _services = [[LJBaseNavigationService alloc] init];
    }
    return _services;
}

- (void)registerNavigationMethodHooks {
    
    @weakify(self)
    [[(NSObject *)self.services rac_signalForSelector:@selector(pushViewModel:animated:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        
        UIViewController *viewController = (UIViewController *)[LJRouter.sharedManager viewControllerWithViewModel:tuple.first];
        viewController.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:viewController animated:[tuple.second boolValue]];
    }];
    
    [[(NSObject *)self.services rac_signalForSelector:@selector(popViewModelAnimated:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [[self viewController].navigationController popViewControllerAnimated:[tuple.first boolValue]];
    }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToRootViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [[self viewController].navigationController popToRootViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services rac_signalForSelector:@selector(presentViewModel:animated:completion:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        UIViewController *viewController = (UIViewController *)[LJRouter.sharedManager viewControllerWithViewModel:tuple.first];
        
        [[self viewController] presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
    }];
    
    [[(NSObject *)self.services rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)] subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        [[self viewController].navigationController dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
    }];
    
}

- (UIViewController *)viewController {
    return  [self setHoldObject];
}

@end
