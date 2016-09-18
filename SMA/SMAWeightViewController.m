//
//  SMAWeightViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/31.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAWeightViewController.h"

@interface SMAWeightViewController ()
{
    SMADialMainView *dialView;
}
@end

@implementation SMAWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
   
}


#pragma mark ******创建UI
- (void)createUI{
    self.title = SMALocalizedString(@"user_title");
    _weightTitLab.text = SMALocalizedString(@"user_weight");
    SMAUserInfo *user = [SMAAccountTool userInfo];
    _genderIma.image = [UIImage imageNamed:user.userSex.intValue?@"boy_smart":@"girl_smart"];
    [_skipBut setTitle:SMALocalizedString(@"user_next") forState:UIControlStateNormal];
    NSArray *processTit = @[SMALocalizedString(@"user_lastStep"),SMALocalizedString(@"user_nextStep")];
    NSArray *processColor = @[[SmaColor colorWithHexString:@"#999999" alpha:1],[SmaColor colorWithHexString:@"#5790F9" alpha:1]];
    NSMutableArray *diaArr = [NSMutableArray array];

    for (int i = 0; i < 121 ; i ++) {
        [diaArr addObject:[NSString stringWithFormat:@"%D",30 + i*1]];
    }
    dialView = [[SMADialMainView alloc] initWithFrame:CGRectMake(0,0,MainScreen.size.width, MainScreen.size.width)];
    dialView.center = CGPointMake(MainScreen.size.width/2, MainScreen.size.height - 40);
    dialView.patientiaDial = 70;
    dialView.dialText = diaArr;
    dialView.delegate = self;
    [self.view addSubview:dialView];
    UILabel *weightNotLab = [[UILabel alloc] initWithFrame:CGRectMake(10, MainScreen.size.height - MainScreen.size.width/2 - 100, MainScreen.size.width - 20, 50)];
    weightNotLab.text = SMALocalizedString(@"user_weightNot");
    weightNotLab.textAlignment = NSTextAlignmentCenter;
    weightNotLab.font = FontGothamLight(15);
    [self.view addSubview:weightNotLab];
    _weightLab.text = [NSString stringWithFormat:@"%dkg",dialView.patientiaDial];
    for (int i = 0; i<2; i++) {
        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0 + MainScreen.size.width/2 *i, MainScreen.size.height - 40, MainScreen.size.width/2, 40);
        but.tag = 101 +i;
        but.titleLabel.font = FontGothamLight(17);
        but.backgroundColor = processColor[i];
        [but setTitle:processTit[i] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(processSelector:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
    }
}

- (void)processSelector:(UIButton *)sender{
    if (sender.tag == 101) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else{
        SMAUserInfo *user = [SMAAccountTool userInfo];
        user.userWeigh = [_weightLab.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
        [SMAAccountTool saveUser:user];
        UITabBarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)skipSelector:(id)sender{
    UITabBarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark *******smaDialViewDelegate
- (void)moveViewFinish:(NSString *)selectTit{
    _weightLab.text = [NSString stringWithFormat:@"%@kg",selectTit];
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
