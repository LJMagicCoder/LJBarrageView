//
//  ViewController.m
//  BarrageDemo
//
//  Created by 宋立军 on 2017/7/28.
//  Copyright © 2017年 宋立军. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LJBarrageTool.h"

@interface ViewController () <LJBarrageViewDelegate>

@property (nonatomic, strong) LJBarrageView *barrageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    //初始化展示区域界面
    LJBarrageView *barrageView = [LJBarrageView lj_creatNormalWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 350)];
    [self.view addSubview:barrageView];
    self.barrageView = barrageView;
    
    //配置参数
    barrageView.barrageRow = 5;
    barrageView.barrageHeightType = BarrageHeightTypeNormal;
    barrageView.barrageShowStyle = LJBarrageShowStyleTypeVelocityScreenThan;
    barrageView.styleParameter = 0.3;
    barrageView.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //传入数据（模拟长连接不断地传）
    [self.barrageView lj_addBarrageText:[NSString stringWithFormat:@"test-test-test-test-test-test"]];
    
    for (int i = 0; i < 20; i++) {
        [self.barrageView lj_addBarrageText:[NSString stringWithFormat:@"test%d",i]];
        [self.barrageView lj_addBarrageText:[NSString stringWithFormat:@"test-test%d",i]];
    }
    
    for (int i = 0; i < 10; i++) {
        //富文本样式
        [self.barrageView lj_addBarrageText:[self dropShadowWithString:[NSString stringWithFormat:@"attributedText%d",i]]];
    }
}

//富文本样式
- (NSMutableAttributedString *)dropShadowWithString:(NSString *)string {
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 5.0;
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowColor = [UIColor orangeColor];
    
    return [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSShadowAttributeName:shadow}];
}

#pragma mark - <LJBarrageViewDelegate>

//重构弹幕样式
- (UIView *)refactoringView:(UIView *)view text:(id)text {
    //这里重写label样式
    return view;
}

//单次点击弹幕
- (void)clickBarrageWithView:(UIView *)view text:(id)text {
    
    NSLog(@"%@",text);
}

- (void)dealloc {
    // 销毁界面时需释放
    [self.barrageView shut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
