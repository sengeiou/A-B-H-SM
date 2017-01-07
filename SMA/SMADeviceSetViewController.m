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
    BOOL unpair;
    SMASwitchScrollView *switchView;
    UIImagePickerController *picker;
    NSDictionary *webFirmwareDic;
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
    if (SmaBleMgr.peripheral.state == CBPeripheralStateConnected) {
        [self chectFirmwareVewsionWithWeb];
    }
}

- (void)viewWillLayoutSubviews{
    if (!createUI) {
        createUI = YES;
        NSArray *switchArr;
        if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
             switchArr = @[@[@"remind_lost_pre",@"remind_disturb_pre",@"remind_call_pre",@"remind_message_pre",@"remind_screen_pre"],@[@"remind_lost",@"remind_disturb",@"remind_call",@"remind_message",@"remind_screen"]];
        }
        else{
            switchArr = @[@[@"remind_lost_pre",@"remind_disturb_pre",@"remind_call_pre",@"remind_message_pre"],@[@"remind_lost",@"remind_disturb",@"remind_call",@"remind_message"]];
        }
        switchView = [[SMASwitchScrollView alloc] initWithSwitchs:switchArr];
        [_switchCell.contentView addSubview:switchView];
      __block UIPageControl *pageControl;
//        if ([[switchArr firstObject] count] > 4) {
            pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _switchCell.frame.size.height - 29, _switchCell.frame.size.width, 29)];
            pageControl.center = CGPointMake(_switchCell.frame.size.width/2, pageControl.center.y);
            pageControl.numberOfPages = [[switchArr firstObject] count] > 4 ? 2:1;
            pageControl.backgroundColor = [UIColor whiteColor];
            pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            pageControl.currentPageIndicatorTintColor=[SmaColor colorWithHexString:@"#5891f9" alpha:1];
            [_switchCell.contentView addSubview:pageControl];
            [switchView didEndDecelerating:^(CGPoint Offset) {
                pageControl.currentPage=(int)fabs(Offset.x/320);
            }];
//        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DFUUPDATE"] ) {
        SMADfuViewController*subVC = segue.destinationViewController;
        subVC.dfuInfoDic = webFirmwareDic;
    }
}
//判断是否允许跳转
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"SELECTDEVICE"]) {
        if (!self.userInfo.watchUUID || [self.userInfo.watchUUID isEqualToString:@""]) {
            return YES;
        }
        else{
            //跳转到解除绑定界面
//            [self performSegueWithIdentifier:@"unPairDevice" sender:nil];
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
    _HRSetLab.text = SMALocalizedString(@"setting_heart_monitor");
    _vibrationLab.text = SMALocalizedString(@"setting_vibration");
    _backlightLab.text = SMALocalizedString(@"setting_backlight");
    _photoLab.text = SMALocalizedString(@"setting_photograph");
    _watchLab.text = SMALocalizedString(@"setting_watchface_title");
    _dfuUpdateLab.text = SMALocalizedString(@"setting_unband_dfuUpdate");
    _unPairLab.text = SMALocalizedString(@"setting_unband_remove");
    _updateView.layer.masksToBounds = YES;
    _updateView.layer.cornerRadius = 3.0f;
    _updateView.layer.shouldRasterize = YES;
    _updateView.layer.rasterizationScale =  [UIScreen mainScreen].scale;
    _updateView.hidden = YES;
//    _backlightCell.hidden = NO;
//    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]) {
//        _backlightCell.hidden = YES;
//    }
    [self updateUI];
}

- (void)updateUI{
    
    _backlightCell.hidden = NO;
    _watchChangeCell.hidden = NO;
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]) {
        _backlightCell.hidden = YES;
        _watchChangeCell.hidden = YES;
    }
    
    SmaBleMgr.BLdelegate = self;

    _userInfo = [SMAAccountTool userInfo];
    if (!self.userInfo.watchUUID || [self.userInfo.watchUUID isEqualToString:@""]) {
        _deviceLab.text = SMALocalizedString(@"setting_conDevice");
        _deviceIma.image = [UIImage imageNamed:@"add_watch"];
        _bleIma.hidden = YES;
        _batteryIma.hidden = YES;
        _deviceCell.editing = YES;
        CGSize deviceSize = [_deviceLab.text sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        _deviceLead.constant = MainScreen.size.width/2 - deviceSize.width/2 - 25;
        _deviceW.constant = 20;
        _deviceH.constant = 20;
    }
    else{
        _deviceLab.text = [SMADefaultinfos getValueforKey:BANDDEVELIVE];
        _deviceIma.image = [UIImage imageNamed:[[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"] ? @"SMA_07":@"SMA_10B"];
        _bleIma.hidden = NO;
        _batteryIma.hidden = NO;
        _deviceLead.constant = 15;
        _deviceW.constant = 40;
        _deviceH.constant = 40;
    }
    if (![SmaBleMgr checkBLConnectState] && !unpair) {
        _bleIma.image = [UIImage imageNamed:@"buletooth_unconnected"];
        _batteryIma.image = [UIImage imageNamed:@"Battery_0"];
    }
    else{
        _bleIma.image = [UIImage imageNamed:@"buletooth_connected"];
        if (!unpair) {
             [SmaBleSend getElectric];
        }
    }
    if (unpair) {
        unpair = NO;
        _bleIma.image = [UIImage imageNamed:@"buletooth_unconnected"];
        _batteryIma.image = [UIImage imageNamed:@"Battery_0"];
    }
    _antiLostIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:ANTILOSTSET] ? @"remind_lost_pre":@"remind_lost"];
    _noDistrubIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:NODISTRUBSET] ? @"remind_disturb_pre":@"remind_disturb"];
    _callIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:CALLSET] ? @"remind_call_pre":@"remind_call"];
    _smsIma.image = [UIImage imageNamed:![SMADefaultinfos getIntValueforKey:SMSSET] ? @"remind_message_pre":@"remind_message"];
//    NSLog(@"fwegrgrhg---%d",[SMADefaultinfos getIntValueforKey:SCREENSET]);
    _screenIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:SCREENSET] ? @"remind_screen_pre":@"remind_screen"];
    _sleepMonIma.image = [UIImage imageNamed:[SMADefaultinfos getIntValueforKey:SLEEPMONSET] ? @"remind_heart_pre":@"remind_heart"];
    
    _antiLostBut.selected = [SMADefaultinfos getIntValueforKey:ANTILOSTSET];
    _noDistrubBut.selected = [SMADefaultinfos getIntValueforKey:NODISTRUBSET];
    _callBut.selected = [SMADefaultinfos getIntValueforKey:CALLSET];
    _smsBut.selected = [SMADefaultinfos getIntValueforKey:SMSSET];
    _screenBut.selected = ![SMADefaultinfos getIntValueforKey:SCREENSET];
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

- (void)chectFirmwareVewsionWithWeb{
//    NSString *firmwareType = firmware_smav2;
//     if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
//         if ([[SMADefaultinfos getValueforKey:SMACUSTOM] isEqualToString:@""]) {
//             
//         }
//         firmwareType = firmware_sma07c;
//     }
    SmaAnalysisWebServiceTool *webSer = [[SmaAnalysisWebServiceTool alloc] init];
    [webSer acloudDfuFileWithFirmwareType:firmware_smav2 callBack:^(NSArray *finish, NSError *error) {
        for (int i = 0; i < finish.count; i ++) {
            NSString *filename = [[finish objectAtIndex:i] objectForKey:@"filename"];
            NSString *fileType = [[filename componentsSeparatedByString:@"_"] firstObject];
            if ([fileType isEqualToString:[SMADefaultinfos getValueforKey:BANDDEVELIVE]]) {
                NSString *webFirmwareVer = [[filename substringWithRange:NSMakeRange(filename.length - 9, 5)] stringByReplacingOccurrencesOfString:@"." withString:@""];
                if ([[SMAAccountTool userInfo].watchVersion stringByReplacingOccurrencesOfString:@"." withString:@""].intValue <= webFirmwareVer.intValue) {
                    _updateView.hidden = NO;
                    webFirmwareDic = [finish objectAtIndex:i];
                }
                else{
                    _updateView.hidden = YES;
                    webFirmwareDic = nil;
                }
            }
        }
//        if (finish.count > 0) {
//            NSString *filename = [[finish firstObject] objectForKey:@"filename"];
//            NSString *webFirmwareVer = [[filename substringWithRange:NSMakeRange(filename.length - 9, 5)] stringByReplacingOccurrencesOfString:@"." withString:@""];
//            if ([[SMAAccountTool userInfo].watchVersion stringByReplacingOccurrencesOfString:@"." withString:@""].intValue <= webFirmwareVer.intValue) {
//                _updateView.hidden = NO;
//                webFirmwareDic = [finish firstObject];
//            }
//            else{
//                _updateView.hidden = YES;
//                webFirmwareDic = nil;
//            }
//        }
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    if (section == 1 || section == 2) {
        return 30;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"] && indexPath.section == 3 && indexPath.row == 0 ) {
        return 0;
    }
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"] && indexPath.section == 4 && indexPath.row == 0) {
        return 0;
    }
    if (indexPath.section == 1) {
        return 222;
    }
    if (indexPath.section == 0) {
        return 60;
    }
    return 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 15)];
    lab.font = FontGothamLight(14);
    lab.textColor = [SmaColor colorWithHexString:@"#AAABAD" alpha:1];
    
    if (section == 1 || section == 2) {
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
                SmaVibrationInfo *vibration = [[SmaVibrationInfo alloc] init];
                vibration.type = @"5";
                vibration.freq = [NSString stringWithFormat:@"%d",[SMADefaultinfos getIntValueforKey:VIBRATIONSET]];
                [SmaBleSend setVibration:vibration];
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
    else if (cell == _unPairCell){
        SMAUserInfo *user = [SMAAccountTool userInfo];
        if (!user.watchUUID) {
            [MBProgressHUD showError:SMALocalizedString(@"aler_bandDevice")];
            return;
        }
        SMACenterAlerView *cenAler = [[SMACenterAlerView alloc] initWithMessage: SMALocalizedString(@"setting_unband_remind") buttons:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_unband")]];
        cenAler.delegate = self;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:cenAler];
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
        [SMADefaultinfos putInt:SCREENSET andValue:!sender.selected];
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

#pragma mark ***********cenAlerButDelegate
- (void)centerAlerView:(SMACenterAlerView *)alerView didAlerBut:(UIButton *)button{
    if (button.tag == 102) {
        [MBProgressHUD showSuccess:SMALocalizedString(@"setting_unband_success")];
        SMAUserInfo *user = [SMAAccountTool userInfo];
        user.watchUUID = nil;
        [SMAAccountTool saveUser:user];
        [SmaBleSend relieveWatchBound];
        [SmaBleMgr reunitonPeripheral:NO];//关闭重连机制
//        unpair = YES;
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateUI];
            [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//            //             [SmaBleMgr disconnectBl];
//            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end
