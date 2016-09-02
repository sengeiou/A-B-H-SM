//
//  SMAGenderViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/27.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAGenderViewController.h"
#import "UIBarButtonItem+CKQ.h"
@interface SMAGenderViewController ()

@end

@implementation SMAGenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ******创建UI
- (void)createUI{
    self.title = SMALocalizedString(@"user_title");
    
    _gentlemanLab.text = SMALocalizedString(@"user_boy");
    _ladyLab.text = SMALocalizedString(@"user_girl");
    [_nextBut setTitle:SMALocalizedString(@"user_next") forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SMAUserInfo *user = [SMAAccountTool userInfo];
    SMAAgeViewController *ageVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"smauserman"]) {
        user.userSex = @"1";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ageVC.genderImage.image = [UIImage imageNamed:@"boy_smart"];
        });
    }
    else if ([segue.identifier isEqualToString:@"smauserlady"]) {
        user.userSex = @"0";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ageVC.genderImage.image = [UIImage imageNamed:@"girl_smart"];
        });
    }
    else{
        user.userSex = @"1";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ageVC.genderImage.image = [UIImage imageNamed:@"boy_smart"];
        });
    }
    [SMAAccountTool saveUser:user];
    ageVC.title = SMALocalizedString(@"user_title");
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
