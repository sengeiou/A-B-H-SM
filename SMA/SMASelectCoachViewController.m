//
//  SMASelectCoachViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/18.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASelectCoachViewController.h"
#import "SMASelectViewCell.h"
@interface SMASelectCoachViewController ()
{
    NSArray *deviceArr;
}
@end

@implementation SMASelectCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    deviceArr = @[@[@"SMA-COACH",SMALocalizedString(@"setting_band_07detail")],@[@"SMA-07B",SMALocalizedString(@"setting_band_07detail")],@[@"SMA-07B",SMALocalizedString(@"setting_band_07detail")],SMALocalizedString(@"setting_band_buywatch")];
}

- (void)createUI{
    self.title = SMALocalizedString(@"setting_band_title");
    self.tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0, 64, MainScreen.size.width, MainScreen.size.height - 64)  style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [SmaColor colorWithHexString:@"#F7F7F7" alpha:1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return deviceArr.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row < deviceArr.count - 1) {
        return 170;
//    }
//    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row < deviceArr.count - 1) {
        SMASelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECTCELL"];
    if (!cell) {
        cell = (SMASelectCell *) [[[NSBundle mainBundle] loadNibNamed:@"SMASelectCell" owner:nil options:nil] lastObject];
    }
        cell.coachLab.text = [[deviceArr objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.detailLab.text = [[deviceArr objectAtIndex:indexPath.row] objectAtIndex:1];
        UIImageView *backgroundIma = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170)];
        backgroundIma.image = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#FFFFFF" alpha:1],[SmaColor colorWithHexString:@"#F7F7F7" alpha:1]] ByGradientType:0 size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 170)];
        cell.backgroundView = backgroundIma;
        return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath==%lD",indexPath.row);
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SM07"];
    }
    else if (indexPath.row == 1){
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SMA-Q2"];
    }
//    if (indexPath.row == deviceArr.count - 1) {
//         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatch.com/Store"]];
//    }
}

- (void)butAction:(UIButton *)sender{
    if (sender.tag == 1001) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatch.com/Store"]];
    }
    else{
        
    }
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
