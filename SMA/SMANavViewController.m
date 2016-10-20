//
//  SMANavViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/27.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMANavViewController.h"

@interface SMANavViewController ()

@end

@implementation SMANavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5790F9" alpha:1],[SmaColor colorWithHexString:@"#80C1F9" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
     self.navigationBar.translucent = NO; //不透明处理
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];//隐藏导航栏下黑线
   //改变title文字格式
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:FontGothamLight(20),NSForegroundColorAttributeName:[UIColor whiteColor]}];
   //修改BarItem 字体颜色样式
    [[UITabBarItem  appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: FontGothamLight(11), NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (/*viewController.navigationItem.leftBarButtonItem == nil && */self.childViewControllers.count >= 1) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithTarget:self Hidden:self.leftItemHidden action:@selector(_didClickBackBarButtonItem:)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)_didClickBackBarButtonItem:(id)sender{
    [self popViewControllerAnimated:YES];
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
