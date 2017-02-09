//
//  SMAHelpViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/1/7.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMAHelpViewController.h"

@interface SMAHelpViewController ()

@end

@implementation SMAHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SMALocalizedString(@"me_userHelp");
    UIScrollView *healthScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64)];
    healthScroll.backgroundColor = [UIColor whiteColor];
    healthScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:healthScroll];
    UIImage *help1 = [UIImage imageNamed:@"img_bagnzhu_2"];
    
    UIImageView *help1View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,MainScreen.size.width, help1.size.height * MainScreen.size.width/help1.size.width)];
    help1View.image = help1;
    help1View.backgroundColor = [UIColor greenColor];
    [healthScroll addSubview:help1View];
    
    [healthScroll setContentSize:CGSizeMake(MainScreen.size.width, help1View.frame.size.height + 8)];
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
