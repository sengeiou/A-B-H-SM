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
//    self.genderImage.image = [UIImage imageNamed:@"girl_smart"];
    NSLog(@"ewfwef==%@",_ageTileLab.text);
    [_nextBut setTitle:SMALocalizedString(@"user_next") forState:UIControlStateNormal];
    _ageTileLab.text = SMALocalizedString(@"user_age");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY";
    NSMutableArray *ageArr = [NSMutableArray array];
    for (int i = 1; i<61; i ++) {
        [ageArr addObject:[NSString stringWithFormat:@"%d",[formatter stringFromDate:[NSDate date]].intValue - 60 + i]];
    }
    SMAPickerView *pickView = [[SMAPickerView alloc] initWithFrame:CGRectMake(0, MainScreen.size.height - 240, MainScreen.size.width, 240) ButtonTitles:@[SMALocalizedString(@"user_lastStep"),SMALocalizedString(@"user_nextStep")] ickerMessage:ageArr];
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
    
    [pickView setRow:^(NSInteger row){
        _ageLab.text = [NSString stringWithFormat:@"%d",[formatter stringFromDate:[NSDate date]].intValue - [ageArr[row] intValue]];
    }];
    [self.view addSubview:pickView];
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
