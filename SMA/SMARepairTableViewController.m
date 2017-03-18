//
//  SMARepairTableViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/7.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMARepairTableViewController.h"

@interface SMARepairTableViewController ()
@end

@implementation SMARepairTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SmaBleMgr.repairDfu = YES;
    [self initializeMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [SmaBleMgr stopSearch];
}

- (void)initializeMethod{
    self.tableView.tableFooterView = [UIView new];
    SmaBleMgr.sortedArray = nil;
    SmaBleMgr.BLdelegate = self;
    SmaBleMgr.scanNameArr = @[self.dfuName];
    [SmaBleMgr scanBL:12];
//    [self chectFirmwareVewsionWithWeb];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return SmaBleMgr.sortedArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
//
//- (void)chectFirmwareVewsionWithWeb{
//    SmaAnalysisWebServiceTool *webSer = [[SmaAnalysisWebServiceTool alloc] init];
//    [webSer acloudDfuFileWithFirmwareType:firmware_smav2 callBack:^(NSArray *finish, NSError *error) {
//        for (int i = 0; i < finish.count; i ++) {
//            NSString *filename = [[finish objectAtIndex:i] objectForKey:@"filename"];
//            NSString *filneNameNow = [NSString stringWithFormat:@"%@_%@_firmware_%@",self.deviceName,self.bleCustom,[[filename componentsSeparatedByString:@"_"] lastObject]];
//            if ([filneNameNow isEqualToString:filename]) {
//                [self downDfuWithFile:(NSMutableDictionary *)[finish objectAtIndex:i]];
//            }
//        }
//    }];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        SMADfuViewController *dfuVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"SMADfuViewController"];
        ScannedPeripheral *peripheral = [SmaBleMgr.sortedArray objectAtIndex:indexPath.row];
        dfuVC.epairPeripheral = peripheral.peripheral;
        dfuVC.repairBleCustom = self.bleCustom;
        dfuVC.repairDeviceName = self.deviceName;
       SmaBleMgr.repairDfu = YES;
        [self.navigationController pushViewController:dfuVC animated:YES];
  }

//- (void)downDfuWithFile:(NSMutableDictionary *)fileDic{
//    SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
//    web.chaImageName = fileDic[@"filename"];
//    [web acloudDownFileWithsession:[fileDic objectForKey:@"downloadUrl"] callBack:^(float progress, NSError *error) {
//
//    } CompleteCallback:^(NSString *filePath) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (filePath) {
//                SmaDfuManager.fileUrl = [[NSURL alloc] initWithString:filePath];
//            }
//        });
//    }];
//}

#pragma mark *******BLConnectDelegate
- (void)reloadView{
    [self.tableView reloadData];
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
@end
