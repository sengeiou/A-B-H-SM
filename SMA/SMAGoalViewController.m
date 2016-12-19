//
//  SMAGoalViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/14.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAGoalViewController.h"

@interface SMAGoalViewController ()
{
    SMAUserInfo *user;
}
@end

@implementation SMAGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createUI{
    self.title = SMALocalizedString(@"device_SP_goal");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[SmaColor colorWithHexString:@"#5790F9" alpha:1] size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    _rulerBackView.backgroundColor = [SmaColor colorWithHexString:@"#5790F9" alpha:1];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (!user) {
        user = [SMAAccountTool userInfo];
    }
    _ruleView.starTick = 0;
    _ruleView.stopTick = 21;
    _ruleView.multiple = 1000;
    _ruleView.showTick = user.userGoal.intValue/1000;
    _ruleView.clearance = 70;
    UIFont *font = FontGothamLight(17);
    NSMutableParagraphStyle *style=[[NSMutableParagraphStyle alloc]init]; // 段落样式
    style.alignment = NSTextAlignmentCenter;
    _ruleView.textStyleDict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:[UIColor blackColor]};
    _ruleView.alarmDelegate = self;
    _saveLab.text = SMALocalizedString(@"setting_sedentary_achieve");
    _walkLab.text = SMALocalizedString(@"device_SP_walking");
    _runLab.text = SMALocalizedString(@"device_SP_running");
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5790F9" alpha:1],[SmaColor colorWithHexString:@"#80C1F9" alpha:1]] ByGradientType:topToBottom size:CGSizeMake(MainScreen.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Table view data source

- (void)scrollDidEndDecelerating:(NSString *)ruler scrollView:(SMAAlarmRulerView *)scrollview{
    user.userGoal = [NSString stringWithFormat:@"%d",ruler.intValue * _ruleView.multiple];
    NSLog(@"%@",ruler);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *lab;
    if (section == 0) {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        lab.text = SMALocalizedString(@"me_goal_approximate");
        lab.font = FontGothamLight(14);
        lab.textColor = [SmaColor colorWithHexString:@"#AAABAD" alpha:1];
    }
    return lab;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if ([SmaBleMgr checkBLConnectState]) {
            [SMAAccountTool saveUser:user];
            [MBProgressHUD showSuccess:SMALocalizedString(@"setting_setSuccess")];
            SmaAnalysisWebServiceTool *webser=[[SmaAnalysisWebServiceTool alloc]init];
            
            [webser acloudPutUserifnfo:user success:^(NSString *result) {
                
            } failure:^(NSError *erro) {
                
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}

@end
