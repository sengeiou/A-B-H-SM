//
//  SMAPairViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/18.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAPairViewController.h"

@interface SMAPairViewController ()
{
    NSTimer *timer;
    SMABindRemindView *remindView;
}
@end

@implementation SMAPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",[SMADefaultinfos getValueforKey:BANDDEVELIVE]);
    [self initializeMehtod];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMehtod{
    SmaBleMgr.BLdelegate = self;
}

- (void)createUI{
    self.title = SMALocalizedString(@"setting_band_title");
    _deviceTableView.delegate = self;
    _deviceTableView.dataSource = self;
    _searchBut.layer.masksToBounds = YES;
    _searchBut.layer.cornerRadius = 126/2;
    _searchBut.titleLabel.numberOfLines = 2;
    _searchBut.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_searchBut setTitle:SMALocalizedString(@"setting_band_search") forState:UIControlStateNormal];
    [_searchBut setTitle:SMALocalizedString(@"setting_band_searching") forState:UIControlStateSelected];
    _ignoreLab.text = SMALocalizedString(@"setting_band_remind07");
    _nearLab.text = SMALocalizedString(@"setting_band_attention");
    
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
 
    
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height*0.6);
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:128/255.0 green:193/255.0 blue:249/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [_searchView.layer insertSublayer:_gradientLayer atIndex:0];

}

- (IBAction)searchSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        SmaBleMgr.scanName = [SMADefaultinfos getValueforKey:BANDDEVELIVE];
        [SmaBleMgr scanBL:0];
    }
    else{
//        [SmaBleMgr scanBL:0];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (SmaBleMgr.sortedArray && SmaBleMgr.sortedArray.count > 0) {
        return SmaBleMgr.sortedArray.count;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMADeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DEVICECELL"];
    if (!cell) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"SMADeviceCell" owner:self options:nil] lastObject];
    }
    
    if (SmaBleMgr.sortedArray && SmaBleMgr.sortedArray.count > 0 && indexPath.row < SmaBleMgr.sortedArray.count) {
        ScannedPeripheral *peripheral = [SmaBleMgr.sortedArray objectAtIndex:indexPath.row];
        cell.peripheralName.text = [peripheral name];
        cell.RSSI.text = [NSString stringWithFormat:@"%d",peripheral.RSSI];
        cell.UUID.text = peripheral.UUIDstring;
    }
    else{
        cell.peripheralName.text = @"";
        cell.RSSI.text = @"";
        cell.UUID.text =@"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (SmaBleMgr.sortedArray && SmaBleMgr.sortedArray.count > 0 && indexPath.row < SmaBleMgr.sortedArray.count) {
        [SmaBleMgr stopSearch];
        _searchBut.selected = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD showMessage:SMALocalizedString(@"setting_band_connecting")];
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        
        timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(endConnect) userInfo:[[SmaBleMgr.sortedArray objectAtIndex:indexPath.row] peripheral] repeats:NO];
        [SmaBleMgr connectBl:[[SmaBleMgr.sortedArray objectAtIndex:indexPath.row] peripheral]];
    }
}

#pragma mark *******BLConnectDelegate
- (void)reloadView{
    [_deviceTableView reloadData];
}

- (void)bleDisconnected:(NSString *)error{
    if (error) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [MBProgressHUD hideHUD];
        if ([error isEqualToString:@"蓝牙关闭"]) {
//            [MBProgressHUD showError:SMALocalizedString(@"setting_band_connectfail")];
        }
        else{
        [MBProgressHUD showError:SMALocalizedString(@"setting_band_connectfail")];
        }
    }
}

- (void)bleBindState:(int)state{
    NSLog(@"bleBindState");
    if (state == 0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showMessage:SMALocalizedString(@"setting_band_binding")];
         remindView = [[SMABindRemindView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
         AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:remindView];
    }
    else if (state == 1){
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [remindView removeFromSuperview];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SMALocalizedString(@"setting_band_bindsuccess")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
    else if (state == 2){
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [remindView removeFromSuperview];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SMALocalizedString(@"setting_band_bindfail")];
    }
}

- (void)endConnect{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:SMALocalizedString(@"setting_band_connectTimeOut")];
    [SmaBleMgr disconnectBl];
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
