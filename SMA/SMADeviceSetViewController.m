//
//  SMADeviceSetViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/14.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADeviceSetViewController.h"

@interface SMADeviceSetViewController ()
{
    BOOL createUI;
    SMASwitchScrollView *switchView;
    UIImagePickerController *picker;
}
@end

@implementation SMADeviceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
   
    [self updateUI];
}

- (void)viewWillLayoutSubviews{
    if (!createUI) {
        createUI = YES;
        NSArray *switchArr = @[@[@"remind_lost_pre",@"remind_disturb_pre",@"remind_call_pre",@"remind_message_pre"/*,@"remind_screen_pre"*/],@[@"remind_lost",@"remind_disturb",@"remind_call",@"remind_message"/*,@"remind_screen"*/]];
       switchView = [[SMASwitchScrollView alloc] initWithSwitchs:switchArr];
        [_switchCell.contentView addSubview:switchView];
      __block UIPageControl *pageControl;
        if ([[switchArr firstObject] count] > 4) {
            pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(50, _switchCell.frame.size.height - 30, _switchCell.frame.size.width - 100, 30)];
            pageControl.center = CGPointMake(_switchCell.frame.size.width/2, pageControl.center.y);
            pageControl.numberOfPages = 2;
            pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            pageControl.currentPageIndicatorTintColor=[SmaColor colorWithHexString:@"#7EBFF9" alpha:1];
            [_switchCell.contentView addSubview:pageControl];
            [switchView didEndDecelerating:^(CGPoint Offset) {
                pageControl.currentPage=(int)fabs(Offset.x/320);
            }];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

//判断是否允许跳转
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"SELECTDEVICE"]) {
        if (!self.userInfo.watchUUID || [self.userInfo.watchUUID isEqualToString:@""]) {
            return YES;
        }
        else{
            //跳转到解除绑定界面
            [self performSegueWithIdentifier:@"unPairDevice" sender:nil];
            return NO;
        }
    }
    return [SmaBleMgr checkBLConnectState];
}


- (void)initializeMethod{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)createUI{
    self.title = SMALocalizedString(@"setting_title");
    self.tableView.showsVerticalScrollIndicator = NO;
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
    _photoLab.text = SMALocalizedString(@"智能拍照");
    _watchLab.text = SMALocalizedString(@"setting_watchface_title");
    
//    _backlightCell.hidden = NO;
//    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]) {
//        _backlightCell.hidden = YES;
//    }
    [self updateUI];
}

- (void)updateUI{
    
    _backlightCell.hidden = NO;
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]) {
        _backlightCell.hidden = YES;
    }
    
    SmaBleMgr.BLdelegate = self;

    _userInfo = [SMAAccountTool userInfo];
    if (!self.userInfo.watchUUID || [self.userInfo.watchUUID isEqualToString:@""]) {
        _deviceLab.text = SMALocalizedString(@"setting_conDevice");
        _deviceIma.image = [UIImage imageNamed:@"add_watch"];
        _bleIma.hidden = YES;
        _batteryIma.hidden = YES;
        _deviceCell.editing = YES;
    }
    else{
        _deviceLab.text = [SMADefaultinfos getValueforKey:BANDDEVELIVE];
        _deviceIma.image = [UIImage imageNamed:@"img_shoubiao"];
        _bleIma.hidden = NO;
        _batteryIma.hidden = NO;
    }
    if (![SmaBleMgr checkBLConnectState]) {

        _bleIma.image = [UIImage imageNamed:@"buletooth_unconnected"];
        _batteryIma.image = [UIImage imageNamed:@"Battery_0"];
    }
    else{
        _bleIma.image = [UIImage imageNamed:@"buletooth_connected"];
        [SmaBleSend getElectric];
    }
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
    
    NSString *detailText = [SMADefaultinfos getIntValueforKey:VIBRATIONSET]?[NSString stringWithFormat:@"%d %@",[SMADefaultinfos getIntValueforKey:VIBRATIONSET],SMALocalizedString(@"setting_times")]:SMALocalizedString(@"setting_turnOff");
    CGSize fontsize = [detailText sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(14)}];
    UILabel *vibLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontsize.width, 44)];
    vibLab.font = FontGothamLight(13);
    vibLab.textAlignment = NSTextAlignmentRight;
    vibLab.text = detailText;
    vibLab.textColor = [UIColor grayColor];
    _vibrationCell.accessoryView = vibLab;
    
    detailText = [SMADefaultinfos getIntValueforKey:BACKLIGHTSET]?[NSString stringWithFormat:@"%d %@",[SMADefaultinfos getIntValueforKey:BACKLIGHTSET],SMALocalizedString(@"setting_seconds")]:SMALocalizedString(@"setting_turnOff");
    fontsize = [detailText sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(14)}];
    UILabel *backlightLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fontsize.width, 44)];
    backlightLab.font = FontGothamLight(13);
    backlightLab.textAlignment = NSTextAlignmentRight;
    backlightLab.text = detailText;
    backlightLab.textColor = [UIColor grayColor];
    _backlightCell.accessoryView = backlightLab;
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
//  if ([SmaBleMgr checkBLConnectState]) {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == _vibrationCell) {
        if ([SmaBleMgr checkBLConnectState]) {
//            UIAlertController *aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"setting_vibration") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//            for ( int i = 0; i <= 6; i ++) {
//                UIAlertAction *action = [UIAlertAction actionWithTitle:i == 0?SMALocalizedString(@"setting_turnOff"):i == 6?SMALocalizedString(@"setting_sedentary_cancel"):[NSString stringWithFormat:@"%d %@",i*2,SMALocalizedString(@"setting_times")] style:i == 6 ? UIAlertActionStyleCancel:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    if (i != 6) {
//                        [SMADefaultinfos putInt:VIBRATIONSET andValue:i*2];
//                    }
//                    [SmaBleSend setVibrationFrequency:[SMADefaultinfos getIntValueforKey:VIBRATIONSET]];
//                    [self updateUI];
//                }];
//                NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:SMALocalizedString(@"setting_vibration")];
//                [alertTitleStr addAttribute:NSFontAttributeName value:FontGothamBold(20) range:NSMakeRange(0, alertTitleStr.length)];
//                [aler setValue:alertTitleStr forKey:@"attributedTitle"];
//                
//                [aler addAction:action];
//            }
//            [self presentViewController:aler animated:YES completion:^{
//                
//            }];
            NSArray *timeArr1 = @[SMALocalizedString(@"setting_turnOff"),@"2",@"4",@"6",@"8"];
            NSArray *timeArr = @[@"0",@"2",@"4",@"6",@"8"];
            SMACenterTabView *timeTab = [[SMACenterTabView alloc] initWithMessages:timeArr1 selectMessage:timeArr1[[SMADefaultinfos getIntValueforKey:VIBRATIONSET]/2] selName:@"icon_selected"];
            [timeTab tabViewDidSelectRow:^(NSIndexPath *indexPath) {
                NSLog(@"indexPath=%@",indexPath);
                [SMADefaultinfos putInt:VIBRATIONSET andValue:[timeArr[indexPath.row] intValue]];
                [SmaBleSend setVibrationFrequency:[SMADefaultinfos getIntValueforKey:VIBRATIONSET]];
                [self updateUI];
            }];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:timeTab];
        }
    }
    else if (cell == _backlightCell){
        if ([SmaBleMgr checkBLConnectState]) {
//            UIAlertController *aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"setting_backlight") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//            for ( int i = 0; i <= 6; i ++) {
//                UIAlertAction *action = [UIAlertAction actionWithTitle:i == 0?SMALocalizedString(@"setting_turnOff"):i == 6?SMALocalizedString(@"setting_sedentary_cancel"):[NSString stringWithFormat:@"%d %@",i*2,SMALocalizedString(@"setting_seconds")] style:i == 6 ? UIAlertActionStyleCancel:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    if (i != 6) {
//                        [SMADefaultinfos putInt:BACKLIGHTSET andValue:i*2];
//                    }
//                    [SmaBleSend setBacklight:[SMADefaultinfos getIntValueforKey:BACKLIGHTSET]];
//                    [self updateUI];
//                }];
//                [aler addAction:action];
//            }
//            NSMutableAttributedString *alertTitleStr = [[NSMutableAttributedString alloc] initWithString:SMALocalizedString(@"setting_backlight")];
//            [alertTitleStr addAttribute:NSFontAttributeName value:FontGothamBold(20) range:NSMakeRange(0, alertTitleStr.length)];
//            [aler setValue:alertTitleStr forKey:@"attributedTitle"];
//            [self presentViewController:aler animated:YES completion:^{
//                
//            }];
            NSArray *timeArr1 = @[SMALocalizedString(@"setting_turnOff"),@"2",@"4",@"6",@"8"];
            NSArray *timeArr = @[@"0",@"2",@"4",@"6",@"8"];
            SMACenterTabView *timeTab = [[SMACenterTabView alloc] initWithMessages:timeArr1 selectMessage:timeArr1[[SMADefaultinfos getIntValueforKey:BACKLIGHTSET]/2] selName:@"icon_selected"];
            [timeTab tabViewDidSelectRow:^(NSIndexPath *indexPath) {
                NSLog(@"indexPath=%@",indexPath);
                [SMADefaultinfos putInt:BACKLIGHTSET andValue:[timeArr[indexPath.row] intValue]];
                [SmaBleSend setBacklight:[SMADefaultinfos getIntValueforKey:BACKLIGHTSET]];
                [self updateUI];
            }];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:timeTab];
        }
    }
    else if (cell == _watchChangeCell){
        SMAWatchChangeController *changeVC = [[SMAWatchChangeController alloc] init];
        changeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    else if (cell == _photoCell){
        __block UIImagePickerControllerSourceType sourceType ;
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                [SmaBleSend setBLcomera:YES];
              
                if (!picker) {
                    picker = [[UIImagePickerController alloc] init];//初始化
                    picker.delegate = self;
                    picker.allowsEditing = YES;//设置可编辑
                }
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }
            else{
                [MBProgressHUD showError:SMALocalizedString(@"me_no_photograph")];
            }
    }
//}
}

- (IBAction)antilostSelector:(UIButton *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        sender.selected = !sender.selected;
        [SMADefaultinfos putInt:ANTILOSTSET andValue:sender.selected];
        [SmaBleSend setDefendLose:[SMADefaultinfos getIntValueforKey:ANTILOSTSET]];
        [self updateUI];
    }
}

- (IBAction)noDistrubSelector:(UIButton *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        sender.selected = !sender.selected;
        [SMADefaultinfos putInt:NODISTRUBSET andValue:sender.selected];
        SmaNoDisInfo *disInfo = [[SmaNoDisInfo alloc] init];
        disInfo.isOpen = [NSString stringWithFormat:@"%d",[SMADefaultinfos getIntValueforKey:NODISTRUBSET]];
        disInfo.beginTime1 = @"0";
        disInfo.endTime1 = @"1439";
        disInfo.isOpen1 = @"1";
        [SmaBleSend setNoDisInfo:disInfo];
        [self updateUI];
    }
}

- (IBAction)callSelector:(UIButton *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        sender.selected = !sender.selected;
        [SMADefaultinfos putInt:CALLSET andValue:sender.selected];
        [SmaBleSend setphonespark:[SMADefaultinfos getIntValueforKey:CALLSET]];
        [self updateUI];
    }
}

- (IBAction)smsSelector:(UIButton *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        sender.selected = !sender.selected;
        [SMADefaultinfos putInt:SMSSET andValue:sender.selected];
        [SmaBleSend setSmspark:[SMADefaultinfos getIntValueforKey:SMSSET]];
        [self updateUI];
    }
}

- (IBAction)screenSelector:(UIButton *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        sender.selected = !sender.selected;
        [SMADefaultinfos putInt:SCREENSET andValue:sender.selected];
        [SmaBleSend setVertical:[SMADefaultinfos getIntValueforKey:SCREENSET]];
        [self updateUI];
    }
}

- (IBAction)sleepMonselector:(UIButton *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        sender.selected = !sender.selected;
        [SMADefaultinfos putInt:SLEEPMONSET andValue:sender.selected];
        [SmaBleSend setSleepAIDS:[SMADefaultinfos getIntValueforKey:SLEEPMONSET]];
        [self updateUI];
    }
}


#pragma mark *******BLConnectDelegate*****
- (void)bledidDisposeMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)data{
    switch (mode) {
        case ELECTRIC:
        {
            int electric = [[[data firstObject] stringByReplacingOccurrencesOfString:@"%" withString:@""] intValue];
            if (electric >= 80) {
                _batteryIma.image = [UIImage imageNamed:@"Battery_100"];
            }
            else if (electric >= 60){
                _batteryIma.image = [UIImage imageNamed:@"Battery_75"];
            }
            else if (electric >= 40){
                _batteryIma.image = [UIImage imageNamed:@"Battery_50"];
            }
            else if (electric >= 10){
                _batteryIma.image = [UIImage imageNamed:@"Battery_25"];
            }
            else{
                _batteryIma.image = [UIImage imageNamed:@"Battery_0"];
            }
        }
            break;
        case BOTTONSTYPE:
        {
            if ([[data firstObject] intValue] == 1) {
                [picker takePicture];
            }
            else if([[data firstObject] intValue] == 2){
                [SmaBleSend setBLcomera:NO];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)bleDisconnected:(NSString *)error{
    _bleIma.image = [UIImage imageNamed:@"buletooth_unconnected"];
    _batteryIma.image = [UIImage imageNamed:@"Battery_0"];
}

- (void)bleDidConnect{
    _bleIma.image = [UIImage imageNamed:@"buletooth_connected"];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __block UIImage* image;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"fwgwgg-----%@",NSStringFromCGSize(image.size));
     UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        
    }
     [self dismissViewControllerAnimated:YES completion:^{
         [SmaBleSend setBLcomera:NO];
    }];
}
    
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
        
        NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [SmaBleSend setBLcomera:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
