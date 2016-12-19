//
//  SMAAboutUsViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAAboutUsViewController.h"

@interface SMAAboutUsViewController ()

@end

@implementation SMAAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _aboutUsView.text = SMALocalizedString(@"me_set_about_content");
}

- (void)viewDidAppear:(BOOL)animated{
     [_aboutUsView setContentOffset:CGPointMake(0, 0)];
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
