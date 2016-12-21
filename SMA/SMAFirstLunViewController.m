//
//  SMAFirstLunViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/10.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAFirstLunViewController.h"

@interface SMAFirstLunViewController ()
{
    UIButton *but;
    NSTimer *timer;
}
@end

@implementation SMAFirstLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    scrollview.delegate = self;
    scrollview.pagingEnabled = YES;
    [self.view addSubview:scrollview];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    NSArray *array = @[@"img_zhuye",@"img_yundong",@"img_xinlv",@"img_shuimian"];
    if (![preferredLang isEqualToString:@"zh"]){
        array = @[@"img_zhuye_en",@"img_yundong_en",@"img_xinlv_en",@"img_shuimian_en"];
    }
    scrollview.contentSize = CGSizeMake(MainScreen.size.width * array.count, MainScreen.size.height);
    for (int i = 0; i < array.count; i ++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0 + MainScreen.size.width * i, 0, MainScreen.size.width, MainScreen.size.height)];
        image.image = [UIImage imageNamed:array[i]];
        image.userInteractionEnabled = YES;
        [scrollview addSubview:image];
        if (i == array.count - 1) {
            but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(0, MainScreen.size.height + 10, MainScreen.size.width - 120, 40);
            but.titleLabel.font = FontGothamLight(17);
            but.layer.masksToBounds = YES;
            but.layer.cornerRadius = 20.0;
            but.backgroundColor = [SmaColor colorWithHexString:@"#7EBFF9" alpha:1];
            but.center = CGPointMake(MainScreen.size.width/2, but.center.y);
            [but setTitle:SMALocalizedString(@"firstLun_taste") forState:UIControlStateNormal];
            [but addTarget:self action:@selector(setAction:) forControlEvents:UIControlEventTouchUpInside];
            [image addSubview:but];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAction:(UIButton *)sender{
    sender.enabled = NO;
    UINavigationController *loginNav = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
    [UIApplication sharedApplication].keyWindow.rootViewController=loginNav;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
//    if (scrollView.contentOffset.x >= MainScreen.size.width * 3) {
//        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(schedule) userInfo:nil repeats:NO];
//        }
//    }
}

- (void)schedule{
    [UIView animateWithDuration:0.5 animations:^{
        but.transform = CGAffineTransformMakeTranslation(0, -80);
    }];
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
