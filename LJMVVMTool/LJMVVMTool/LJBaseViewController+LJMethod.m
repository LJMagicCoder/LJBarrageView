//
//  LJBaseViewController+LJMethod.m
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/6.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LJBaseViewController+LJMethod.h"
#import <objc/runtime.h>

static char kHoldObjectKey;

@implementation LJBaseViewController (LJMethod)

-(void)holdObject:(LJBaseViewModel *)vm {
    objc_setAssociatedObject(vm, &kHoldObjectKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation LJBaseViewModel (LJMethod)

- (LJBaseViewController *)setHoldObject {
    return objc_getAssociatedObject(self, &kHoldObjectKey);
}

@end

