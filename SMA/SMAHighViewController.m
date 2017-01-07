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
{
    SMAUserInfo *user;
}
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
        [SMAAccountTool saveUser:user];
}

#pragma mark ******创建UI
- (void)createUI{
   self.title = SMALocalizedString(@"user_title");
    _highTitLab.text = SMALocalizedString(@"user_hight");
    [_backBut setTitle:SMALocalizedString(@"user_lastStep") forState:UIControlStateNormal];
    [_nextBut setTitle:SMALocalizedString(@"user_nextStep") forState:UIControlStateNormal];
     user = [SMAAccountTool userInfo];
    _genderIma.image = [UIImage imageNamed:user.userSex.intValue?@"boy_smart":@"girl_smart"];
//    SMARulerScrollView *sce = [[SMARulerScrollView alloc] initWithFrame:CGRectMake(10, 200, 300, 80)starTick:70 stopTick:230];
//    sce.scrRulerdelegate = self;
//    sce.transform = CGAffineTransformMakeRotation(M_PI_2);
//    sce.center = CGPointMake(MainScreen.size.width - 50, MainScreen.size.height/2);
//    sce.rulerView.transFloat = M_PI_2;
//    [self.view addSubview:sce];
    
    NSMutableArray *unArr = [NSMutableArray array];
    NSMutableArray *unArr1 = [NSMutableArray array];
    NSArray *messArr;
    if (user.unit.intValue == 0) {
        for (int i = 0; i < 161; i ++) {
            [unArr addObject:[NSString stringWithFormat:@"%d",i + 70]];
        }
         messArr = @[unArr];
        _highLab.attributedText = [self attributedStringWithArr:@[@"170",SMALocalizedString(@"me_perso_cm")]];
    }
    else{
        for (int i = 0; i < 12; i ++) {
            [unArr addObject:[NSString stringWithFormat:@"%d'",i]];
            [unArr1 addObject:[NSString stringWithFormat:@"%d\"",i]];
        }
        float inch = [SMACalculate convertToInch:170];
//        int inchInt = roundf(inch);
//        NSString *inStr = [NSString stringWithFormat:@"%.0f",inch];
        NSString *ftInch = [SMACalculate convertToFt:(int)roundf(inch)];
        _highLab.attributedText = [self attributedStringWithArr:@[ftInch]];
         messArr = @[unArr,unArr1];
    }
    __block NSInteger ft = 4;
    __block NSInteger inch = 7;
    SMAPickerView *pickView = [[SMAPickerView alloc] initWithFrame:CGRectMake(0, MainScreen.size.height - 330, MainScreen.size.width, 190) ButtonTitles:@[SMALocalizedString(@"user_lastStep"),SMALocalizedString(@"user_nextStep")] ickerMessage:messArr];
     if (user.unit.intValue == 0) {
         user.userHeight = [messArr objectAtIndex:0][100];
         [pickView.pickView selectRow:100 inComponent:0 animated:NO];
     }
     else{
        user.userHeight = [NSString stringWithFormat:@"%.0f",[SMACalculate convertToCm:(ft + 1)*12.0 + inch]];
         [pickView.pickView selectRow:ft inComponent:0 animated:NO];
         [pickView.pickView selectRow:inch inComponent:1 animated:NO];
     }
    [pickView setRow:^(NSInteger row, NSInteger component){
        
        if (user.unit.intValue == 0) {
            _highLab.attributedText = [self attributedStringWithArr:@[[messArr objectAtIndex:component][row],SMALocalizedString(@"me_perso_cm")]];
            user.userHeight = [messArr objectAtIndex:component][row];
        }
        else{
            if (component == 0) {
                ft = row;
            }
            else{
                inch = row;
            }
            _highLab.attributedText = [self attributedStringWithArr:@[[NSString stringWithFormat:@"%ld'%ld\"",ft + 1,inch]]];
            user.userHeight = [NSString stringWithFormat:@"%.0f",[SMACalculate convertToCm:(ft + 1)*12.0 + inch]];
        }
    }];
    [self.view addSubview:pickView];
}

- (IBAction)nextSelector:(id)sender{
//   [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAHighViewController"] animated:YES];
}

#pragma mark ******smaRulerScrollDelegate
- (void)scrollDidEndDecelerating:(NSString *)ruler{
    NSLog(@"身高===%@",ruler);
    _highLab.text = [NSString stringWithFormat:@"%@cm",ruler];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
