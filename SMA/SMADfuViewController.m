//
//  SMADfuViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADfuViewController.h"

@interface SMADfuViewController ()
{
    SMAUserInfo *user;
}
@end

@implementation SMADfuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    user = [SMAAccountTool userInfo];
    self.title = SMALocalizedString(@"setting_unband_dfuUpdate");
    [_dfuBut setTitle:SMALocalizedString(@"setting_dfu_newest") forState:UIControlStateNormal];
    _dfuBut.titleLabel.numberOfLines = 3;
    [_remindLab setText:SMALocalizedString(@"setting_dfu_remind")];
    _nowVerTitLab.text = SMALocalizedString(@"setting_dfu_nowVer");
    _nowVerLab.text = [NSString stringWithFormat:@"V%@",user.watchVersion];
}

- (IBAction)dfuSelector:(id)sender{
//    NSTimer *TIME = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setPregress:) userInfo:nil repeats:YES];
}

static float bb;
- (void)setPregress:(id)sender{
    NSTimer *timer = (NSTimer *)sender;
    bb = bb + 0.1;
    
    _dfuView.progress = bb;
    if (bb > 2) {
        bb = 0;
        [timer invalidate];
    }
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
