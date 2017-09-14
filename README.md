# LJMVVMTool是一款基于rac实现的响应式编程工具类。

其中实现了ViewModel push ViewModel的效果，也实现了ViewModel与ViewController之间映射管理。

支持 pod 'LJMVVMTool'

集成后需要继承LJBaseViewController与LJBaseViewModel为基类，然后在AppDelegate设置映射管理(代码如下)就可以使用了

     - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
        //设置映射管理
        [[LJRouter sharedManager] viewModelWithMapping:^NSDictionary *{
            return @{
                     @"DemoViewModel":@"DemoViewController",
                     @"NextViewModel":@"NextViewController"
                     };
        }];
        
        return YES;
    }

创建ViewController时代码如下。默认直接进行ViewModel之间交互，无需创建。

     ViewController *vc = [[ViewController alloc] initWithViewModel:[ViewModel new]];
    
