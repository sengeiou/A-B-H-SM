//
//  SMARepairDfuCollectionController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/3/7.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "SMARepairDfuCollectionController.h"

@interface SMARepairDfuCollectionController ()
{
    NSMutableArray *imageArr;
    NSMutableArray *nameArr;
}
@end

@implementation SMARepairDfuCollectionController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const sectionHeaderIdentifier = @"SectionHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMARepairDfuCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"SMAReoaurDfuReusableView" bundle:nil] forCellWithReuseIdentifier:sectionHeaderIdentifier];
     [self.collectionView registerNib:[UINib nibWithNibName:@"SMAReoaurDfuReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self initializeMethod];
    self.title = SMALocalizedString(@"me_repairDfu");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
//    imageArr = @[[UIImage imageWithName:@"img_07"],[UIImage imageWithName:@"img_07"],/*[UIImage imageWithName:@"img_jiexie"],[UIImage imageWithName:@"A2(pah8002_sma_2)"],*/[UIImage imageWithName:@"img_xiaoQerdai"],[UIImage imageWithName:@"img_xiaoQerdai"],[UIImage imageWithName:@"A2(pah8002_sma_2)"],[UIImage imageWithName:@"A2(pah8002_sma_2)"]];
//    nameArr = @[@"SM07",@"MOSW007"/*,@"A1(pah8002_sma-a1)",@"A2(pah8002_sma-a2)"*/,@"ble_app_sma10b",@"NW1135",@"SMA-A1",@"SMA-A2"];
    
    nameArr = [NSMutableArray array];
    imageArr = [NSMutableArray array];
    SmaAnalysisWebServiceTool *tool = [[SmaAnalysisWebServiceTool alloc] init];
    [tool acloudDfuFileWithFirmwareType:firmware_smaProducts callBack:^(NSArray *finish, NSError *error) {
        for (int i = 0; i < finish.count; i++) {
            NSDictionary *firmareDic = finish[i];
            if ([firmareDic[@"filename"] rangeOfString:@"(2)"].location != NSNotFound) {
                //                NSDictionary *firmareDic = @{@"downloadUrl":firmareDic[@"downloadUrl"],};
                NSMutableDictionary *objectDic = [firmareDic[@"extendAttrs"][@"objectData"] mutableCopy];
                [objectDic setObject:firmareDic[@"downloadUrl"] forKey:@"downloadUrl"];
                [imageArr addObject:objectDic];
            }
        }
        NSLog(@"gehhth   %@",finish);
        [self.collectionView reloadData];
    }];

}

- (void)viewWillDisappear:(BOOL)animated{
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
    SmaBleMgr.repairDfu = NO;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SMARepairDfuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//  cell.backgroundColor = [UIColor redColor];
    // Configure the cell
   
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
         cell.topShow = YES;
    }
    cell.titleLab.text = [imageArr objectAtIndex:indexPath.row][@"product_name"];
    cell.imageUrl = [imageArr objectAtIndex:indexPath.row][@"downloadUrl"];
    cell.bottomShow = YES;
    if (indexPath.row%3 == 0) {
        cell.rightShow = YES;
    }
    if (indexPath.row%3 == 1) {
        cell.rightShow = YES;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SMAReoaurDfuReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderIdentifier forIndexPath:indexPath];
    headerView.titleLab1.text = SMALocalizedString(@"me_repairSelect");
    return headerView;
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 20)/3;
    return CGSizeMake(width, 125);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMARepairTableViewController *repairDeviceVC = [[SMARepairTableViewController alloc] init];
    
    repairDeviceVC.deviceName = [[imageArr objectAtIndex:indexPath.row] objectForKey:@"firmware_prefix"];
    repairDeviceVC.bleCustom = [[imageArr objectAtIndex:indexPath.row] objectForKey:@"firmware_prefix"];
    repairDeviceVC.dfuName = [[imageArr objectAtIndex:indexPath.row] objectForKey:@"dfu_name"];
    
//    if (indexPath.row == 0) {
//    repairDeviceVC.deviceName = @"SM07";
//    repairDeviceVC.bleCustom = @"SmartCare";
//        repairDeviceVC.dfuName = @"DfuTarg";
//    }
//    if (indexPath.row == 1) {
//        repairDeviceVC.deviceName = @"MOSW007";
//        repairDeviceVC.bleCustom = @"SmartCare";
//        repairDeviceVC.dfuName = @"DfuTarg";
//    }
//    if (indexPath.row == 2) {
//        repairDeviceVC.deviceName = @"SMA-Q2";
//        repairDeviceVC.bleCustom = @"SmartCare";
//        repairDeviceVC.dfuName = @"Dfu10B10";
//    }
//    if (indexPath.row == 3) {
//        repairDeviceVC.deviceName = @"NW1135";
//        repairDeviceVC.bleCustom = @"SmartCare";
//        repairDeviceVC.dfuName = @"Dfu10B10";
//    }
//    if (indexPath.row == 4) {
//        repairDeviceVC.deviceName = @"SMA-A1";
//        repairDeviceVC.bleCustom = @"SmartCare";
//        repairDeviceVC.dfuName = @"DfuTarg";
//    }
//    if (indexPath.row == 5) {
//        repairDeviceVC.deviceName = @"SMA-A2";
//        repairDeviceVC.bleCustom = @"SmartCare";
//        repairDeviceVC.dfuName = @"DfuTarg";
//    }
//    if (indexPath.row == 5) {
//        repairDeviceVC.deviceName = @"NW1135";
//        repairDeviceVC.bleCustom = @"SmartCare";
//        repairDeviceVC.dfuName = @"Dfu10B10";
//    }
//    else{
//        repairDeviceVC.deviceName = @"SMA-Q2";
//        repairDeviceVC.bleCustom = @"SmartCare";
//        repairDeviceVC.dfuName = @"Dfu10B10";
//    }
    
    [self.navigationController pushViewController:repairDeviceVC animated:YES];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
