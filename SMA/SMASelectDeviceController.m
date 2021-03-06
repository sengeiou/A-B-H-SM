//
//  SMASelectDeviceController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/30.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASelectDeviceController.h"

@interface SMASelectDeviceController ()
{
    NSArray *deviceArr;
}
@end

@implementation SMASelectDeviceController

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
    if (_isSelect) {
        self.navigationController.leftItemHidden = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    if (_isSelect) {
//        self.navigationController.leftItemHidden = NO;
    }
}

- (UIBarButtonItem *)backItemWithTarget:(id)target Hidden:(BOOL)hidden action:(SEL)action
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame =CGRectMake(0, 0, 25, 22);
    backButton.hidden = hidden;
    if ([[[UIDevice currentDevice]systemVersion] doubleValue]>=7.0) {
        [backButton setImage:[[UIImage imageNamed:@"icon_return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"icon_return"]  forState:UIControlStateNormal];
    }
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)initializeMethod{
     deviceArr = @[@[@"SMART A1",SMALocalizedString(@"setting_band_07detail"),@"img_jiexie"]/*,@[@"SMA-A2",SMALocalizedString(@"setting_band_07detail"),@"img_launcher"]*/,@[@"SMART WATCH-01",SMALocalizedString(@"setting_band_07detail"),@"img_xiaoQerdai"],@[@"SMART BAND-01",SMALocalizedString(@"setting_band_07detail"),@"img_07"],@[@"SMART BAND-02",SMALocalizedString(@"setting_band_07detail"),@"img_B2"],@[@"SMART BAND-03",SMALocalizedString(@"setting_band_07detail"),@"img_B3"],@[@"SMART M1",SMALocalizedString(@"setting_band_07detail"),@"img_r1"]];
//   deviceArr = @[@[@"SMA-A1",SMALocalizedString(@"setting_band_07detail"),@"img_jiexie"],@[@"SMA-Q2",SMALocalizedString(@"setting_band_07detail"),@"img_xiaoQerdai"],@[@"SMA-COACH",SMALocalizedString(@"setting_band_07detail"),@"img_07"]];
    
}
- (void)createUI{
    self.title = SMALocalizedString(@"setting_band_title");
    _selectTView.delegate = self;
    _selectTView.dataSource = self;
    _selectTView.tableFooterView = [[UIView alloc] init];
    [_buyBut setTitle:SMALocalizedString(@"setting_band_buywatch") forState:UIControlStateNormal];
    [_unPairBut setTitle:SMALocalizedString(@"setting_band_unPair") forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [self backItemWithTarget:self Hidden:NO action:@selector(unPairSelector:)];
}

- (IBAction)buySelector:(id)sender{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatch.com/Store"]];
}

- (IBAction)unPairSelector:(id)sender{
    SMATabbarController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SMAMainTabBarController"];
    controller.isLogin = NO;
    NSArray *itemArr = @[SMALocalizedString(@"device_title"),SMALocalizedString(@"rank_title"),SMALocalizedString(@"setting_title"),SMALocalizedString(@"me_title")];
    NSArray *arrControllers = controller.viewControllers;
    for (int i = 0; i < arrControllers.count; i ++) {
    SMANavViewController *nav = [arrControllers objectAtIndex:i];
    nav.tabBarItem.title = itemArr[i];
    }
    [UIApplication sharedApplication].keyWindow.rootViewController=controller;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return deviceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 150;
    }
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 1) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
//        }
//        return cell;
//    }

    SMASelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECTCELL"];
    if (!cell) {
        cell = (SMASelectCell *) [[[NSBundle mainBundle] loadNibNamed:@"SMASelectCell" owner:nil options:nil] lastObject];
    }
    cell.coachIma.image = [UIImage imageNamed:[[deviceArr objectAtIndex:indexPath.row] objectAtIndex:2]];
    cell.coachLab.text = [[deviceArr objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.detailLab.text = [[deviceArr objectAtIndex:indexPath.row] objectAtIndex:1];
    UIImageView *backgroundIma = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170)];
    backgroundIma.image = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#FFFFFF" alpha:1],[SmaColor colorWithHexString:@"#F7F7F7" alpha:1]] ByGradientType:0 size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 170)];
    cell.backgroundView = backgroundIma;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SMA-A1"];
    }
//    if (indexPath.row == 1) {
//        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SMA-A2"];
//    }
    if (indexPath.row == 1){
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SMA-Q2"];
    }
    if (indexPath.row == 2) {
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SM07"];
    }
    if (indexPath.row == 3) {
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SMA-B2"];
    }
    if (indexPath.row == 4) {
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SMA-B3"];
    }
    if (indexPath.row == 5) {
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SMA-R1"];
    }
    self.navigationController.leftItemHidden = NO;
    [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"SMAPairViewController"] animated:YES];
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
