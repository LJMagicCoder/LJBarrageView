//
//  LJBaseViewController.m
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/6.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LJBaseViewController.h"
#import "LJBaseViewController+LJMethod.h"

@interface LJBaseViewController ()

@property (nonatomic, strong, readwrite) LJBaseViewModel *viewModel;

@end

@implementation LJBaseViewController

- (instancetype)initWithViewModel:(LJBaseViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
        [self holdObject:viewModel];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
