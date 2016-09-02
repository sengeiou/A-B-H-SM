//
//  ViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
}

#pragma mark *******创建UI
- (void)createUI{

    // 4、设置导航栏透明并隐藏导航栏下黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
     self.navigationController.navigationBar.translucent = true;
    self.extendedLayoutIncludesOpaqueBars = YES;
    _titLab.text = SMALocalizedString(@"login_smaTit");
    [_loginBut setTitle:SMALocalizedString(@"login_login") forState:UIControlStateNormal];
    [_regisBut setTitle:SMALocalizedString(@"login_regis") forState:UIControlStateNormal];
}

@end
