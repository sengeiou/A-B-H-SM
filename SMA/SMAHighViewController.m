//
//  SMAHighViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAHighViewController.h"
#import "SMARulerView.h"
#import "SMARulerScrollView.h"
@interface SMAHighViewController ()

@end

@implementation SMAHighViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"hight"]) {
        SMAUserInfo *user = [SMAAccountTool userInfo];
        user.userHeight = [_highLab.text stringByReplacingOccurrencesOfString:@"cm" withString:@""];
        [SMAAccountTool saveUser:user];
    }
}

#pragma mark ******创建UI
- (void)createUI{
   self.title = SMALocalizedString(@"user_title");
    _highTitLab.text = SMALocalizedString(@"user_hight");
    [_skipBut setTitle:SMALocalizedString(@"user_next") forState:UIControlStateNormal];
    [_backBut setTitle:SMALocalizedString(@"user_lastStep") forState:UIControlStateNormal];
    [_nextBut setTitle:SMALocalizedString(@"user_nextStep") forState:UIControlStateNormal];
    SMAUserInfo *user = [SMAAccountTool userInfo];
    _genderIma.image = [UIImage imageNamed:user.userSex.intValue?@"boy_smart":@"girl_smart"];
    SMARulerScrollView *sce = [[SMARulerScrollView alloc] initWithFrame:CGRectMake(10, 200, 300, 80)starTick:70 stopTick:230];
    sce.scrRulerdelegate = self;
    sce.transform = CGAffineTransformMakeRotation(M_PI_2);
    sce.center = CGPointMake(MainScreen.size.width - 50, MainScreen.size.height/2);
    sce.rulerView.transFloat = M_PI_2;
    [self.view addSubview:sce];
}

- (IBAction)backSelector:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ******smaRulerScrollDelegate
- (void)scrollDidEndDecelerating:(NSString *)ruler{
    NSLog(@"身高===%@",ruler);
    _highLab.text = [NSString stringWithFormat:@"%@cm",ruler];
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
