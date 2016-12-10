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
    SMAUserInfo *user;
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
    [_nextBut setTitle:SMALocalizedString(@"user_nextStep") forState:UIControlStateNormal];
    user = [SMAAccountTool userInfo];
    _genderIma.image = [UIImage imageNamed:user.userSex.intValue?@"boy_smart":@"girl_smart"];
    
    NSMutableArray *unArr = [NSMutableArray array];
    NSArray *messArr;
    if (user.unit.intValue == 0) {
        _weightLab.attributedText = [self attributedStringWithArr:@[@"60.0",SMALocalizedString(@"me_perso_kg")]];
        for (int i = 0; i < 101; i ++) {
            [unArr addObject:[NSString stringWithFormat:@"%d",i + 30]];
        }
        NSMutableArray *cycleArr = [NSMutableArray array];
        for (int j = 0; j < 100; j++) {
            [cycleArr addObjectsFromArray:unArr];
        }
        messArr = @[cycleArr,@[@".0",@".5"]];
    }
    else{
        for (int i = 0; i < 231; i ++) {
            [unArr addObject:[NSString stringWithFormat:@"%d",i + 60]];
        }
        NSMutableArray *cycleArr = [NSMutableArray array];
        for (int j = 0; j < 100; j++) {
            [cycleArr addObjectsFromArray:unArr];
        }
         _weightLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%.0f",[SMACalculate convertToLbs:60.0]],SMALocalizedString(@"me_perso_lbs")]];
        messArr = @[cycleArr];
    }

    __block NSInteger ft = 30;
    __block NSInteger inch = 0;
    SMAPickerView *pickView = [[SMAPickerView alloc] initWithFrame:CGRectMake(0, MainScreen.size.height - 330, MainScreen.size.width, 190) ButtonTitles:@[SMALocalizedString(@"user_lastStep"),SMALocalizedString(@"user_nextStep")] ickerMessage:messArr];
    if (user.unit.intValue == 0) {
        [pickView.pickView selectRow:ft + (101 * 50) inComponent:0 animated:NO];
        [pickView.pickView selectRow:inch inComponent:1 animated:NO];
    }
    else{
        [pickView.pickView selectRow:72 + (231 * 50) inComponent:0 animated:NO];
    }
    [pickView setRow:^(NSInteger row, NSInteger component){
        if (user.unit.intValue == 0) {
            if (component == 0) {
                ft = row;
            }
            else{
                inch = row;
            }
            _weightLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%@%@",[[messArr objectAtIndex:0] objectAtIndex:ft],[[messArr objectAtIndex:1] objectAtIndex:inch]],SMALocalizedString(@"me_perso_kg")]];
            user.userWeigh = [NSString stringWithFormat:@"%@%@",[[messArr objectAtIndex:0] objectAtIndex:ft],[[messArr objectAtIndex:1] objectAtIndex:inch]];
        }
        else{
            _weightLab.attributedText = [self attributedStringWithArr:@[[[messArr objectAtIndex:0] objectAtIndex:row],SMALocalizedString(@"me_perso_lbs")]];
            user.userWeigh = [NSString stringWithFormat:@"%.1f",[SMACalculate convertToKg:[[[messArr objectAtIndex:0] objectAtIndex:row] floatValue]]];
        }
    }];
    [self.view addSubview:pickView];
    
//    for (int i = 0; i < 121 ; i ++) {
//        [diaArr addObject:[NSString stringWithFormat:@"%D",30 + i*1]];
//    }
//    dialView = [[SMADialMainView alloc] initWithFrame:CGRectMake(0,0,MainScreen.size.width, MainScreen.size.width)];
//    dialView.center = CGPointMake(MainScreen.size.width/2, MainScreen.size.height - 40);
//    dialView.patientiaDial = 70;
//    dialView.dialText = diaArr;
//    dialView.delegate = self;
//    [self.view addSubview:dialView];
//    UILabel *weightNotLab = [[UILabel alloc] initWithFrame:CGRectMake(10, MainScreen.size.height - MainScreen.size.width/2 - 100, MainScreen.size.width - 20, 50)];
//    weightNotLab.text = SMALocalizedString(@"user_weightNot");
//    weightNotLab.textAlignment = NSTextAlignmentCenter;
//    weightNotLab.font = FontGothamLight(15);
//    [self.view addSubview:weightNotLab];
//    _weightLab.text = [NSString stringWithFormat:@"%dkg",dialView.patientiaDial];
//    for (int i = 0; i<2; i++) {
//        UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
//        but.frame = CGRectMake(0 + MainScreen.size.width/2 *i, MainScreen.size.height - 40, MainScreen.size.width/2, 40);
//        but.tag = 101 +i;
//        but.titleLabel.font = FontGothamLight(17);
//        but.backgroundColor = processColor[i];
//        [but setTitle:processTit[i] forState:UIControlStateNormal];
//        [but addTarget:self action:@selector(processSelector:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:but];
//    }
}

//- (void)processSelector:(UIButton *)sender{
//    if (sender.tag == 101) {
//        [self.navigationController popViewControllerAnimated:NO];
//    }
//    else{
//        SMAUserInfo *user = [SMAAccountTool userInfo];
//        user.userWeigh = [_weightLab.text stringByReplacingOccurrencesOfString:@"kg" withString:@""];
//        [SMAAccountTool saveUser:user];
//        UITabBarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
//        [self presentViewController:controller animated:YES completion:nil];
//    }
//}

- (IBAction)skipSelector:(id)sender{
    UITabBarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark *******smaDialViewDelegate
- (void)moveViewFinish:(NSString *)selectTit{
    _weightLab.text = [NSString stringWithFormat:@"%@kg",selectTit];
}

- (NSMutableAttributedString *)attributedStringWithArr:(NSArray *)strArr{
    NSMutableAttributedString *showStr = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < strArr.count; i ++) {
        NSDictionary *textDic = @{NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#3D81EA" alpha:1],NSFontAttributeName:FontGothamLight(30)};
        if (i%2!=0) {
            textDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(18)};
        }
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:strArr[i] attributes:textDic];
        [showStr appendAttributedString:str];
    }
    return showStr;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SMASpGoalViewController *goalVC = (SMASpGoalViewController *)segue.destinationViewController;
    goalVC.isSelect = YES;
}


@end
