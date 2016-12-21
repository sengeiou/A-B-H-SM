//
//  ViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSTimer *changeBgTimer;
    int index;
    NSArray *titLabArr;
}
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
    titLabArr = @[SMALocalizedString(@"login_smaTit"),SMALocalizedString(@"login_smaTitS"),SMALocalizedString(@"login_smaTitT")];
    _titLab.text = SMALocalizedString(@"login_smaTit");
    [_loginBut setTitle:SMALocalizedString(@"login_login") forState:UIControlStateNormal];
    [_regisBut setTitle:SMALocalizedString(@"login_regis") forState:UIControlStateNormal];
    
    if (changeBgTimer) {
        [changeBgTimer invalidate];
        changeBgTimer = nil;
    }
    index = 0;
    changeBgTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeSubview) userInfo:nil repeats:YES];
}

- (void)changeSubview{
//    int random = [self getRandomNumber:1 to:3];
    index ++;
    _titLab.text = titLabArr[index - 1];
    _backIma.image = [UIImage imageWithName:[NSString stringWithFormat:@"new_feature_%d",index]];
    if (index == 3) {
        index = 0;
    }
}

//获取一个随机整数，范围在[from,to），包括from，包括to
                 
- (int)getRandomNumber:(int)from to:(int)to{

    return (int)(from + (arc4random() % (to - from + 1)));
    
}

@end
