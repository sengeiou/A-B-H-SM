//
//  SMADeviceSetViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/14.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADeviceSetViewController.h"

@interface SMADeviceSetViewController ()

@end

@implementation SMADeviceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.title = SMALocalizedString(@"setting_title");
    _antiLostLab.text = SMALocalizedString(@"setting_antiLost");
    _noDistrubLab.text = SMALocalizedString(@"setting_noDistrub");
    _callLab.text = SMALocalizedString(@"setting_callNot");
    _smsLab.text = SMALocalizedString(@"setting_smsNot");
    _screenLab.text = SMALocalizedString(@"setting_screen");
    _sleepMonLab.text = SMALocalizedString(@"setting_sleepMon");
    _sedentaryLab.text = SMALocalizedString(@"setting_sedentary");
    _alarmLab.text = SMALocalizedString(@"setting_alarm");
    _HRSetLab.text = SMALocalizedString(@"setting_heart");
    _vibrationLab.text = SMALocalizedString(@"setting_vibration");
    _backlightLab.text = SMALocalizedString(@"setting_backlight");
    SMAUserInfo *user = [SMAAccountTool userInfo];
    if (!user.watchUUID.UUIDString || [user.watchUUID.UUIDString isEqualToString:@""]) {
        _deviceLab.text = SMALocalizedString(@"setting_conDevice");
        _deviceIma.image = [UIImage imageNamed:@"add_watch"];
        _bleIma.hidden = YES;
        _batteryIma.hidden = YES;
    }
    [self updateUI];
//    _backlightCell.hidden = YES;
}

- (void)updateUI{
    _antiLostIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:ANTILOSTSET]?@"remind_lost_pre":@"remind_lost"];
    _noDistrubIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:NODISTRUBSET]?@"remind_disturb_pre":@"remind_disturb"];
    _callIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:CALLSET]?@"remind_call_pre":@"remind_call"];
    _smsIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:SMSSET]?@"remind_message_pre":@"remind_message"];
    _screenIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:SCREENSET]?@"remind_screen_pre":@"remind_screen"];
    _sleepMonIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:SLEEPMONSET]?@"remind_heart_pre":@"remind_heart"];
    
    _antiLostBut.selected = [SMADefaultinfos getIntValueforKey:ANTILOSTSET];
    _noDistrubBut.selected = [SMADefaultinfos getIntValueforKey:NODISTRUBSET];
    _callBut.selected = [SMADefaultinfos getIntValueforKey:CALLSET];
    _smsBut.selected = [SMADefaultinfos getIntValueforKey:SMSSET];
    _screenBut.selected = [SMADefaultinfos getIntValueforKey:SCREENSET];
    _sleepMonBut.selected = [SMADefaultinfos getIntValueforKey:SLEEPMONSET];
    
    NSString *detailText = [SMADefaultinfos getValueforKey:VIBRATIONSET]?[SMADefaultinfos getValueforKey:VIBRATIONSET]:@"";
    detailText = @"5 min";
    CGSize fontsize = [detailText sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(14)}];
    UILabel *vibLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontsize.width, 44)];
    vibLab.font = FontGothamLight(13);
    vibLab.textAlignment = NSTextAlignmentRight;
    vibLab.text = detailText;
    vibLab.textColor = [UIColor grayColor];
    _vibrationCell.accessoryView = vibLab;
    
//    detailText = [SMADefaultinfos getValueforKey:BACKLIGHTSET]?[SMADefaultinfos getValueforKey:BACKLIGHTSET]:@"";
//    fontsize = [detailText sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(14)}];
//    UILabel *backlightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontsize.width, 44)];
//    backlightLab.font = FontGothamLight(13);
//    backlightLab.textAlignment = NSTextAlignmentRight;
//    backlightLab.text = detailText;
//    backlightLab.textColor = [UIColor grayColor];
//    _backlightCell.accessoryView = backlightLab;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 15;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 15)];
    lab.font = FontGothamLight(14);
    lab.textColor = [SmaColor colorWithHexString:@"#AAABAD" alpha:1];

    if (section != 0) {
            lab.text = @[SMALocalizedString(@"setting_title"),SMALocalizedString(@"setting_other")][section - 1];        
    }
    return lab;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)antilostSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    [SMADefaultinfos putInt:ANTILOSTSET andValue:sender.selected];
    [self updateUI];
}

- (IBAction)noDistrubSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    [SMADefaultinfos putInt:NODISTRUBSET andValue:sender.selected];
   [self updateUI];
}

- (IBAction)callSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    [SMADefaultinfos putInt:CALLSET andValue:sender.selected];
    [self updateUI];
}

- (IBAction)smsSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    [SMADefaultinfos putInt:SMSSET andValue:sender.selected];
    [self updateUI];
}

- (IBAction)screenSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    [SMADefaultinfos putInt:SCREENSET andValue:sender.selected];
    [self updateUI];
}

- (IBAction)sleepMonselector:(UIButton *)sender{
    sender.selected = !sender.selected;
    [SMADefaultinfos putInt:SLEEPMONSET andValue:sender.selected];
    [self updateUI];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
