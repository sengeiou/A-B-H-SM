//
//  SMAAgeViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAAgeViewController.h"

@interface SMAAgeViewController ()

@end

@implementation SMAAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

#pragma mark *****创建UI
- (void)createUI{
    [_nextBut setTitle:SMALocalizedString(@"user_nextStep") forState:UIControlStateNormal];
    _ageTileLab.text = SMALocalizedString(@"user_age");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY";
    NSMutableArray *ageArr = [NSMutableArray array];
    for (int i = 1; i<61; i ++) {
        [ageArr addObject:[NSString stringWithFormat:@"%d",[formatter stringFromDate:[NSDate date]].intValue - 60 + i]];
    }
    NSArray *messArr = @[ageArr];
    SMAPickerView *pickView = [[SMAPickerView alloc] initWithFrame:CGRectMake(0, MainScreen.size.height - 330, MainScreen.size.width, 190) ButtonTitles:@[SMALocalizedString(@"user_lastStep"),SMALocalizedString(@"user_nextStep")] ickerMessage:messArr];
    [pickView.pickView selectRow:33 inComponent:0 animated:NO];
    [pickView setCancel:^(UIButton *button){
        NSLog(@"上步");
          [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [pickView setConfirm:^(NSInteger component){
        NSLog(@"下步");
        SMAUserInfo *user = [SMAAccountTool userInfo];
        user.userAge = _ageLab.text;
        [SMAAccountTool saveUser:user];
        [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAHighViewController"] animated:YES];
    }];
    
    [pickView setRow:^(NSInteger row , NSInteger component){
        _ageLab.text = [NSString stringWithFormat:@"%d",[formatter stringFromDate:[NSDate date]].intValue - [[messArr objectAtIndex:component][row] intValue]];
    }];
    [self.view addSubview:pickView];
}

- (IBAction)unitSelect:(UIButton *)sender{
    SMABottomSelView *selView = [[SMABottomSelView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height) title:SMALocalizedString(@"me_perso_unit") message:@[SMALocalizedString(@"me_perso_metric"),SMALocalizedString(@"me_perso_british")]];
    selView.delegate = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:selView];

}

#pragma mark *************tapSelectCellDelegate
- (void)didSelectCell:(UIButton *)butCell{
    SMAUserInfo *user = [SMAAccountTool userInfo];
    user.userAge = _ageLab.text;
    if (butCell.tag == 101) {
        user.unit = @"0";
    }
    else{
        user.unit = @"1";
    }
    [SMAAccountTool saveUser:user];
    [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAHighViewController"] animated:YES];
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
