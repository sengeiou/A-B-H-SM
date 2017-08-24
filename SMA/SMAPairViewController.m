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
    CALayer *searchImalayer;
    SMABottomAlerView *nofondAler, *bondFailAler;
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

- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)initializeMehtod{
    [SmaBleMgr reunitonPeripheral:NO];//关闭重连机制
    [SmaBleMgr disconnectBl];
    [SmaBleMgr stopSearch];
    SmaBleMgr.sortedArray = nil;//清除设备信息
    //     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)updateUI{
    SmaBleMgr.BLdelegate = self;
}

- (void)createUI{
    SmaBleMgr.BLdelegate = self;
    self.title = SMALocalizedString(@"setting_band_title");
    _deviceTableView.delegate = self;
    _deviceTableView.dataSource = self;
    _searchBut.layer.masksToBounds = YES;
    _searchBut.layer.cornerRadius = 126/2;
    _searchBut.titleLabel.numberOfLines = 2;
    _searchBut.titleLabel.textAlignment = NSTextAlignmentCenter;
    _searchBut.selected = YES;
    [_searchBut setTitle:SMALocalizedString(@"setting_band_search") forState:UIControlStateNormal];
    [_searchBut setTitle:SMALocalizedString(@"setting_band_searching") forState:UIControlStateSelected];
//    _ignoreLab.text = SMALocalizedString(@"setting_band_remind07");
//    _nearLab.text = SMALocalizedString(@"setting_band_attention");
//    _ignoreLab.text = [SmaLocalizeableInfo localizedStringDic:@"setting_band_remind07" comment:@" "];
    _ignoreLab.text = SMALocalizedString(@"setting_band_remindNot");
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
    
    searchImalayer = [CALayer layer];
    searchImalayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"icon-xuanzhuan"].CGImage);
    searchImalayer.frame       = _searchBut.bounds;
    [_searchBut.layer addSublayer:searchImalayer];
    [searchImalayer addAnimation:[self searchAnimation] forKey:nil];
    
//     `SmaBleMgr.scanName = [SMADefaultinfos getValueforKey:BANDDEVELIVE];
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"]) {
        SmaBleMgr.scanNameArr = @[@"NW1135",@"SMA-Q2",@"Noise Ignite"];
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
        SmaBleMgr.scanNameArr = @[@"SM07",@"MOSW007",@"HERA Fit"];
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A1"]){
        SmaBleMgr.scanNameArr = @[@"SMA-A1",@"SMA-A2"];
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A2"]){
        SmaBleMgr.scanNameArr = @[@"SMA-A2"];
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"]){
        SmaBleMgr.scanNameArr = @[@"SMA-B2",@"B2"];
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"]){
        SmaBleMgr.scanNameArr = @[@"M1",@"Technos_SR",@"MOSRAA"];
    }
    [SmaBleMgr scanBL:12];
}

- (IBAction)searchSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [searchImalayer addAnimation:[self searchAnimation] forKey:nil];
        if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"]) {
            SmaBleMgr.scanNameArr = @[@"NW1135",@"SMA-Q2",@"Noise Ignite"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
            SmaBleMgr.scanNameArr = @[@"SM07",@"MOSW007"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A1"]){
            SmaBleMgr.scanNameArr = @[@"SMA-A1",@"SMA-A2"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A2"]){
            SmaBleMgr.scanNameArr = @[@"SMA-A2"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"]){
            SmaBleMgr.scanNameArr = @[@"SMA-B2",@"B2"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"]){
            SmaBleMgr.scanNameArr = @[@"M1",@"Technos_SR",@"MOSRAA"];
        }
        [SmaBleMgr scanBL:12];
    }
    else{
        [SmaBleMgr stopSearch];
        [searchImalayer removeAllAnimations];
    }
}

- (CABasicAnimation *)searchAnimation{
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 10000;
    return animation;
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
        cell.rrsiIma.image = [self rrsiImageWithRrsi:peripheral.RSSI];
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
        [searchImalayer removeAllAnimations];
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
    _ignoreLab.text = SMALocalizedString(@"setting_band_remindNot");
    if (SmaBleMgr.sortedArray.count > 0) {
        NSArray *array = [SmaBleMgr.sortedArray valueForKeyPath:@"@distinctUnionOfObjects.peripheral.name"];
        NSString *str = [array componentsJoinedByString:@"/"];
        _ignoreLab.text = [SmaLocalizeableInfo localizedStringDic:@"setting_band_remind07" comment:str];
    }
    [_deviceTableView reloadData];
}

- (void)searchTimeOut{
    _searchBut.selected = NO;
    [remindView removeFromSuperview];
    [searchImalayer removeAllAnimations];
    if (SmaBleMgr.sortedArray.count == 0) {
        nofondAler = [[SMABottomAlerView alloc] initWithMessage:SMALocalizedString(@"setting_band_noDevice") leftMess:SMALocalizedString(@"setting_band_unPair") rightMess:SMALocalizedString(@"setting_band_tryAgain")];
        nofondAler.delegate = self;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:nofondAler];
        _ignoreLab.text = SMALocalizedString(@"setting_band_remindNot");
    }
    NSLog(@"搜索超时");
}

- (void)bleDisconnected:(NSString *)error{
    if (error) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [MBProgressHUD hideHUD];
        [SmaBleMgr stopSearch];
        [remindView removeFromSuperview];
        _searchBut.selected = NO;
        [searchImalayer removeAllAnimations];
        //        UIAlertController *aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"setting_band_connectfail") message:nil preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *canAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_band_unPair") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //            [self.navigationController popViewControllerAnimated:YES];
        //        }];
        //        UIAlertAction *confAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_band_tryAgain") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //            [searchImalayer addAnimation:[self searchAnimation] forKey:nil];
        //            SmaBleMgr.scanName = [SMADefaultinfos getValueforKey:BANDDEVELIVE];
        //            [SmaBleMgr scanBL:12];
        //        }];
        //        [aler addAction:canAction];
        //        [aler addAction:confAction];
        //        [self presentViewController:aler animated:YES completion:^{
        //
        //        }];
        
        if ([error isEqualToString:@"蓝牙关闭"]) {
            //[MBProgressHUD showError:SMALocalizedString(@"setting_band_connectfail")];
        }
        else{
            bondFailAler = [[SMABottomAlerView alloc] initWithMessage:SMALocalizedString(@"setting_band_failRemind") leftMess:SMALocalizedString(@"setting_band_unPair") rightMess:SMALocalizedString(@"setting_band_tryAgain")];
            bondFailAler.delegate = self;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:bondFailAler];
        }
    }
}

- (void)bleBindState:(int)state{
    NSLog(@"bleBindState");
    if (state == 0) {
        [MBProgressHUD hideHUD];
//        [MBProgressHUD showMessage:SMALocalizedString(@"setting_band_binding")];
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
        [MBProgressHUD showSuccess:SMALocalizedString(@"setting_band_bindsuccess")];
        [SmaBleMgr reunitonPeripheral:YES];//开启重连机制
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"绑定成功===%@",[[SMAAccountTool userInfo] watchUUID]);
            // [self.navigationController popToRootViewControllerAnimated:YES];
            SMATabbarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
            controller.isLogin = YES;
            NSArray *itemArr = @[SMALocalizedString(@"device_title"),SMALocalizedString(@"rank_title"),SMALocalizedString(@"setting_title"),SMALocalizedString(@"me_title")];
            NSArray *arrControllers = controller.viewControllers;
            for (int i = 0; i < arrControllers.count; i ++) {
                SMANavViewController *nav = [arrControllers objectAtIndex:i];
                nav.tabBarItem.title = itemArr[i];
            }
            [UIApplication sharedApplication].keyWindow.rootViewController=controller;
        });
    }
    else if (state == 2){
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [remindView removeFromSuperview];
        //  [MBProgressHUD hideHUD];
        //  [MBProgressHUD showError:SMALocalizedString(@"setting_band_bindfail")];
        
        [MBProgressHUD hideHUD];
        [SmaBleMgr disconnectBl];
        //        [SmaBleMgr stopSearch];
        [searchImalayer removeAllAnimations];
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"setting_band_bindfail") message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *canAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_band_unPair") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *confAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_band_tryAgain") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [searchImalayer addAnimation:[self searchAnimation] forKey:nil];
            _searchBut.selected = YES;
            if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"]) {
                SmaBleMgr.scanNameArr = @[@"NW1135",@"SMA-Q2",@"Noise Ignite"];
            }
            else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
                SmaBleMgr.scanNameArr = @[@"SM07",@"MOSW007"];
            }
            else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A1"]){
                SmaBleMgr.scanNameArr = @[@"SMA-A1",@"SMA-A2"];
            }
            else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A2"]){
                SmaBleMgr.scanNameArr = @[@"SMA-A2"];
            }
            else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"]){
                SmaBleMgr.scanNameArr = @[@"SMA-B2",@"B2"];
            }
            else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"]){
                SmaBleMgr.scanNameArr = @[@"M1",@"Technos_SR",@"MOSRAA"];
            }
            [SmaBleMgr scanBL:12];
        }];
        [aler addAction:canAction];
        [aler addAction:confAction];
        //        [self presentViewController:aler animated:YES completion:^{
        //
        //        }];
        bondFailAler = [[SMABottomAlerView alloc] initWithMessage:SMALocalizedString(@"setting_band_failRemind") leftMess:SMALocalizedString(@"setting_band_unPair") rightMess:SMALocalizedString(@"setting_band_tryAgain")];
        bondFailAler.delegate = self;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:bondFailAler];
    }
}

- (void)endConnect{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    //    [MBProgressHUD hideHUD];
    //    [MBProgressHUD showError:SMALocalizedString(@"setting_band_connectTimeOut")];
    [SmaBleMgr disconnectBl];
    [MBProgressHUD hideHUD];
    //    [SmaBleMgr stopSearch];
    [searchImalayer removeAllAnimations];
    //    UIAlertController *aler = [UIAlertController alertControllerWithTitle:SMALocalizedString(@"setting_band_connectTimeOut") message:nil preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *canAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_band_unPair") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }];
    //    UIAlertAction *confAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_band_tryAgain") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [searchImalayer addAnimation:[self searchAnimation] forKey:nil];
    //        SmaBleMgr.scanName = [SMADefaultinfos getValueforKey:BANDDEVELIVE];
    //        [SmaBleMgr scanBL:12];
    //
    //    }];
    //    [aler addAction:canAction];
    //    [aler addAction:confAction];
    //    [self presentViewController:aler animated:YES completion:^{
    //
    //    }];
    nofondAler = [[SMABottomAlerView alloc] initWithMessage:SMALocalizedString(@"setting_band_connectTimeOut") leftMess:SMALocalizedString(@"setting_band_unPair") rightMess:SMALocalizedString(@"setting_band_tryAgain")];
    nofondAler.delegate = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:nofondAler];
}

- (UIImage *)rrsiImageWithRrsi:(int)rrsi{
    UIImage *image;
    if (rrsi > -50) {
        image = [UIImage imageWithName:@"icon_xinhao_1"];
    }
    else if (rrsi <= -50 && rrsi > -70){
        image = [UIImage imageWithName:@"icon_xinhao_2"];
    }
    else if (rrsi <= -70 && rrsi > -90){
        image = [UIImage imageWithName:@"icon_xinhao_3"];
    }
    else{
        image = [UIImage imageWithName:@"icon_xinhao_4"];
    }
    return image;
}

#pragma mark ***********tapAlerButDelegate
- (void)bottomAlerView:(SMABottomAlerView *)alerView didAlerBut:(UIButton *)button{
    if (button.tag == 101) {
        [remindView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [remindView removeFromSuperview];
        [searchImalayer addAnimation:[self searchAnimation] forKey:nil];
        if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"]) {
            SmaBleMgr.scanNameArr = @[@"NW1135",@"SMA-Q2",@"Noise Ignite"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
//            SmaBleMgr.scanName = @"SM07";
            SmaBleMgr.scanNameArr = @[@"SM07",@"MOSW007"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A1"]){
            SmaBleMgr.scanNameArr = @[@"SMA-A1",@"SMA-A2"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A2"]){
            SmaBleMgr.scanNameArr = @[@"SMA-A2"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"]){
            SmaBleMgr.scanNameArr = @[@"SMA-B2",@"B2"];
        }
        else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"]){
            SmaBleMgr.scanNameArr = @[@"M1",@"Technos_SR",@"MOSRAA"];
        }
        [SmaBleMgr scanBL:12];
    }
    //    if (alerView == nofondAler) {
    //        if (button.tag == 101) {
    //             [self.navigationController popViewControllerAnimated:YES];
    //        }
    //        else{
    //            [searchImalayer addAnimation:[self searchAnimation] forKey:nil];
    //            SmaBleMgr.scanName = [SMADefaultinfos getValueforKey:BANDDEVELIVE];
    //            [SmaBleMgr scanBL:12];
    //        }
    //    }
    //    else{
    //
    //    }
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
