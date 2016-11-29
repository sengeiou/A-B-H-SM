//
//  SMAUnPaierViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/25.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAUnPaierViewController.h"

@interface SMAUnPaierViewController ()

@end

@implementation SMAUnPaierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)createUI{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = _unPairView.bounds;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:128/255.0 green:193/255.0 blue:249/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [_unPairView.layer insertSublayer:_gradientLayer atIndex:0];

    
    SMAUserInfo *user = [SMAAccountTool userInfo];
    self.title = SMALocalizedString(@"设备管理");
    _updateIma.hidden = YES;
    _unPairBut.titleLabel.numberOfLines = 2;
    [_unPairBut setTitle:SMALocalizedString(@"解除绑定") forState:UIControlStateNormal];
    _dfuVerLab.text = SMALocalizedString(@"固件升级");
    _verLab.text = [NSString stringWithFormat:@"V%@",user.watchVersion];
    
    
}

- (IBAction)unPaierSelector:(id)sender{
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"解除绑定") message: SMALocalizedString(@"是否解除绑定") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *confAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showSuccess:SMALocalizedString(@"解绑成功")];
        SMAUserInfo *user = [SMAAccountTool userInfo];
        user.watchUUID = nil;
        [SMAAccountTool saveUser:user];
        [SmaBleMgr disconnectBl];
        [SmaBleSend relieveWatchBound];
        [SmaBleMgr reunitonPeripheral:NO];//关闭重连机制
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [aler addAction:canAction];
    [aler addAction:confAction];
    [self presentViewController:aler animated:YES completion:^{
        
    }];
}

- (IBAction)dfuSelector:(id)sender{
    NSLog(@"dfu升级");
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
