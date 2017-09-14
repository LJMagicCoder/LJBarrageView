//
//  LoginView.m
//  MomentsDemo
//
//  Created by 宋立军 on 2017/9/5.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    
    UITextField *accountField = [[UITextField alloc] initWithFrame:CGRectMake(60, 100, 100, 50)];
    accountField.layer.borderColor = [UIColor grayColor].CGColor;
    accountField.layer.borderWidth = 1;
    [self addSubview:accountField];
    _accountField = accountField;
    
    UITextField *passWordField = [[UITextField alloc] initWithFrame:
                                  CGRectMake(CGRectGetMinX(accountField.frame),
                                             CGRectGetMaxY(accountField.frame),
                                             CGRectGetWidth(accountField.frame),
                                             CGRectGetHeight(accountField.frame)
                                             )];
    passWordField.layer.borderColor = [UIColor grayColor].CGColor;
    passWordField.layer.borderWidth = 1;
    [self addSubview:passWordField];
    _passWordField = passWordField;
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:
                             CGRectMake(CGRectGetMinX(passWordField.frame),
                                        CGRectGetMaxY(passWordField.frame) + 10,
                                        100, 50)];
    loginButton.enabled = NO;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [loginButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self addSubview:loginButton];
    _loginButton = loginButton;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
