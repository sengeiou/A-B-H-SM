//
//  SMADeviceDataTableViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/2.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADeviceDataTableViewController.h"

@interface SMADeviceDataTableViewController ()

@end

@implementation SMADeviceDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.title = SMALocalizedString(@"device_title");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMADieviceDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DATACELL"];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DATACELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMADieviceDataCell" owner:self options:nil] lastObject];
        //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DATACELL"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //        cell.imageView.image = [UIImage buttonImageFromColors:@[[UIColor blueColor],[UIColor orangeColor]] ByGradientType:0 radius:20 size:CGSizeMake(40, 40)];
        //        cell.imageView.layer.shouldRasterize = YES;
        //        cell.imageView.backgroundColor = [UIColor yellowColor];
        //        cell.textLabel.text = @"fwefewfewfwefwf";
        
        if (indexPath.row == 0) {
            cell.pulldownView.hidden = NO;
            cell.roundView.progressViewClass = [SDLoopProgressView class];
            cell.roundView.progressView.progress = 0.801;
            cell.roundView.progressView.titleLab = @"800008";
            cell.titLab.text = SMALocalizedString(@"device_SP_goal");
            cell.dialLab.text = SMALocalizedString(@"20000");
            cell.stypeLab.text = SMALocalizedString(@"device_SP_step");

            cell.detailsTitLab1.text = SMALocalizedString(@"device_SP_sit");
            cell.detailsTitLab2.text = SMALocalizedString(@"device_SP_walking");
            cell.detailsTitLab3.text = SMALocalizedString(@"device_SP_running");
            cell.detailsLab1.text = @"00h33m";
            cell.detailsLab2.text = @"00h33m";
            cell.detailsLab3.text = @"00h88m";
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#5B6B78" alpha:1],[SmaColor colorWithHexString:@"#5B6B78" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#7DBEF9" alpha:1],[SmaColor colorWithHexString:@"#7DBEF9" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#1F90EA" alpha:1],[SmaColor colorWithHexString:@"#1F90EA" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 绘制操作完成
                    cell.roundView1.image = cornerImage;
                    cell.roundView2.image = cornerImage1;
                    cell.roundView3.image = cornerImage2;
                });
                
            });
        }
        else
            if (indexPath.row == 1){
                cell.pulldownView.hidden = YES;
                cell.roundView.progressViewClass = [SDRotationLoopProgressView class];
                cell.roundView.progressView.progress = 128/200.0;
                cell.titLab.text = SMALocalizedString(@"device_HR_monitor");
                cell.dialLab.text = SMALocalizedString(@"device_HR_typeT");
                cell.stypeLab.text = @"";
                cell.detailsTitLab1.text = SMALocalizedString(@"device_HR_rest");
                cell.detailsTitLab2.text = SMALocalizedString(@"device_HR_mean");
                cell.detailsTitLab3.text = SMALocalizedString(@"device_HR_max");
                cell.detailsLab1.text = @"228bpm";
                cell.detailsLab2.text = @"228bpm";
                cell.detailsLab3.text = @"228bpm";
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#F8A3BD" alpha:1],[SmaColor colorWithHexString:@"#F8A3BD" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#D7B7EF" alpha:1],[SmaColor colorWithHexString:@"#D7B7EF" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#EA1F75" alpha:1],[SmaColor colorWithHexString:@"#EA1F75" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 绘制操作完成
                        cell.roundView1.image = cornerImage;
                        cell.roundView2.image = cornerImage1;
                        cell.roundView3.image = cornerImage2;
                    });
                    
                });
                
            }
            else if (indexPath.row == 2){
                cell.pulldownView.hidden = YES;
                cell.roundView.progressViewClass = [SDPieLoopProgressView class];
                cell.roundView.progressView.progress = 0.001;
                cell.roundView.progressView.startTime = 12;
                cell.roundView.progressView.endTime = 53;
                cell.titLab.text = SMALocalizedString(@"device_SL_qualith");
                cell.stypeLab.text = SMALocalizedString(@"device_SL_typeS");
                cell.dialLab.text = SMALocalizedString(@"00h33m");
                cell.detailsTitLab1.text = SMALocalizedString(@"device_SL_deep");
                cell.detailsTitLab2.text = SMALocalizedString(@"device_SL_light");
                cell.detailsTitLab3.text = SMALocalizedString(@"device_SL_awake");
                cell.detailsLab1.text = @"00h33m";
                cell.detailsLab2.text = @"00h33m";
                cell.detailsLab3.text = @"00h88m";
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *cornerImage = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#8DE3BF" alpha:1],[SmaColor colorWithHexString:@"#8DE3BF" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    UIImage *cornerImage1 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#00C6AE" alpha:1],[SmaColor colorWithHexString:@"#00C6AE" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    UIImage *cornerImage2 = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#2CCB6F" alpha:1],[SmaColor colorWithHexString:@"#2CCB6F" alpha:1]] ByGradientType:0 radius:5 size:CGSizeMake(10, 10)];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 绘制操作完成
                        cell.roundView1.image = cornerImage;
                        cell.roundView2.image = cornerImage1;
                        cell.roundView3.image = cornerImage2;
                    });
                    
                });
            }
        
    }
    
    return cell;
}


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
