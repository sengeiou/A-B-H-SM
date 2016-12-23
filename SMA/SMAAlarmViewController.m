//
//  SMAAlarmViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/8.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAAlarmViewController.h"

@interface SMAAlarmViewController ()
{
    NSMutableArray *alarmArr;
    NSIndexPath *replacePath;
    BOOL editIng;
}
@end

@implementation SMAAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addAlarm"] ) {
        SMAAlarmSubViewController*subVC = segue.destinationViewController;
//        SMAAlarmSubViewController *subVC = [[navigationController viewControllers] objectAtIndex:0]; ;
        subVC.delegate = self;
    }
}

//判断是否允许跳转
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"addAlarm"] ) {
        
        if ( alarmArr.count > 7) {
            [MBProgressHUD showError:SMALocalizedString(@"setting_alarm_limit")];
            return NO;
        }
    }
    return YES;
}

- (void)initializeMethod{
    SMADatabase *smaDal = [[SMADatabase alloc] init];
    alarmArr = [smaDal selectClockList];
}

- (void)createUI{
    self.title = SMALocalizedString(@"setting_alarm_title");
    _alarmTView.delegate = self;
    _alarmTView.dataSource = self;
    _alarmTView.tableFooterView = [[UIView alloc] init];
    [_editBut setTitle:SMALocalizedString(@"setting_alarm_edit") forState:UIControlStateNormal];
    [_addBut setTitle:SMALocalizedString(@"setting_alarm_add") forState:UIControlStateNormal];
}

- (IBAction)editSelector:(UIButton *)sender{
    if ( alarmArr.count > 0) {
    sender.selected = !sender.selected;
    editIng = sender.selected;
    for (int i = 0; i < alarmArr.count; i ++ ) {
        SMASedentEditCell *cell = [_alarmTView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.edit = editIng;
    }
  }
}

- (IBAction)addSelector:(id)sender{
    
}

#pragma mark UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return alarmArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMASedentEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ALARMCELL"];
    if (!cell) {
        cell = (SMASedentEditCell *) [[[NSBundle mainBundle] loadNibNamed:@"SMASedentEditCell" owner:nil options:nil] lastObject];
    }
    cell.alarmInfo = (SmaAlarmInfo *)[alarmArr objectAtIndex:indexPath.row];;
    [cell setPushBlock:^(SmaAlarmInfo *info){
        replacePath = indexPath;
        SMAAlarmSubViewController *subVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAAlarmSubViewController"];
        subVC.delegate = self;
        subVC.alarmInfo = info;
        [self.navigationController pushViewController:subVC animated:YES];
    }];
    if (editIng) {
        cell.edit = editIng;
    }
    cell.indexPath = indexPath;
    [cell setDeleteBlock:^(SmaAlarmInfo *info,SMASedentEditCell *cell){
        if ([SmaBleMgr checkBLConnectState]) {
            SMADatabase *smaDal = [[SMADatabase alloc] init];
            [smaDal deleteClockInfo:info.aid callback:^(BOOL result) {
            NSInteger row = [alarmArr indexOfObject:info];
            [alarmArr removeObjectAtIndex:row];
                NSMutableArray *colockArry=[NSMutableArray array];
                int aid=0;
                for (int i=0; i<alarmArr.count; i++) {
                    SmaAlarmInfo *info=(SmaAlarmInfo *)alarmArr[i];
                    if([info.isOpen intValue]>0)
                    {
                        info.aid=[NSString stringWithFormat:@"%d",aid];
                        [colockArry addObject:info];
                        aid++;
                    }
                }

            [SmaBleSend setClockInfoV2:colockArry];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }];
        }
    }];
    
    [cell tapSwitchBlock:^(UISwitch *openSwitch, SmaAlarmInfo *alarminfo) {
        if ([SmaBleMgr checkBLConnectState]) {
            SMADatabase *smaDal = [[SMADatabase alloc] init];
            [alarmArr insertObject:alarminfo atIndex:indexPath.row];
            [smaDal insertClockInfo:alarminfo account:[SMAAccountTool userInfo].userID callback:^(BOOL result) {
                [self initializeMethod];
                NSMutableArray *colockArry=[NSMutableArray array];
                int aid=0;
                for (int i=0; i<alarmArr.count; i++) {
                    SmaAlarmInfo *info=(SmaAlarmInfo *)alarmArr[i];
                    if([info.isOpen intValue]>0)
                    {
                        info.aid=[NSString stringWithFormat:@"%d",aid];
                        [colockArry addObject:info];
                        aid++;
                    }
                }
                [SmaBleSend setClockInfoV2:colockArry];
            }];
        }
    }];
    return cell;
}


#pragma mark *******alarmEditDelegate
- (void)didEditAlarmInfo:(SmaAlarmInfo *)alarmInfo{
    [self initializeMethod];
    NSMutableArray *colockArry=[NSMutableArray array];
    int aid=0;
    for (int i=0; i<alarmArr.count; i++) {
        SmaAlarmInfo *info=(SmaAlarmInfo *)alarmArr[i];
        if([info.isOpen intValue]>0)
        {
            info.aid=[NSString stringWithFormat:@"%d",aid];
            [colockArry addObject:info];
            aid++;
        }
    }
    [SmaBleSend setClockInfoV2:colockArry];
    [_alarmTView reloadData];
}


//  十进制转二进制
- (NSString *)toBinarySystemWithDecimalSystem:(NSString *)decimal
{
    int num = [decimal intValue];
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    NSString * prepare = @"";
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        if (divisor == 0)
        {
            break;
        }
    }
    NSString * result = @"";
    for (int i = (int)prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)],i==0?@"":@","];
    }
    return result;
}


//  二进制转十进制
- (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    return result;
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
