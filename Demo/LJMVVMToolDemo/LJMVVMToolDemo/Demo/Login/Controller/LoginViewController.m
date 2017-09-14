//
//  LoginViewController.m
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/5.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (nonatomic, weak) LoginView *loginView;

@property (nonatomic, strong, readonly) LoginViewModel *viewModel;

@end

@implementation LoginViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建UI 
    [self loadUI];
    
    //添加ViewModel
    [self setUpViewModel];
    
    //处理交互
    [self interactiveProcessing];
    
    // Do any additional setup after loading the view.
}

- (void)loadUI {
    self.view.backgroundColor = [UIColor whiteColor];
    LoginView *loginView = [[LoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loginView];
    _loginView = loginView;

}

- (void)setUpViewModel {
    
    //绑定账号密码的信号
    RAC(self.viewModel ,accountString) = self.loginView.accountField.rac_textSignal;
    RAC(self.viewModel ,pwdString) = self.loginView.passWordField.rac_textSignal;

}

- (void)interactiveProcessing {
    
    RAC(self.loginView.loginButton ,enabled) = self.viewModel.loginEnableSiganl;

    @weakify(self);
    //监听按钮点击(view交互通知ViewModel信号)
    [[self.loginView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel.loginCommand execute:nil];
        
    }];
    
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
