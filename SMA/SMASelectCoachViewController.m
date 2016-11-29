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
    deviceArr = @[@[@"SMA-COACH",SMALocalizedString(@"setting_band_07detail")],@[@"SMA-07B",SMALocalizedString(@"setting_band_07detail")],SMALocalizedString(@"setting_band_buywatch")];
}

- (void)createUI{
    self.title = SMALocalizedString(@"setting_band_title");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return deviceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < deviceArr.count - 1) {
        return 170;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < deviceArr.count - 1) {
          SMASelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SELECTCELL"];
        cell.coachLab.text = [[deviceArr objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.detailLab.text = [[deviceArr objectAtIndex:indexPath.row] objectAtIndex:1];
        UIImageView *backgroundIma = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170)];
        backgroundIma.image = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#FFFFFF" alpha:1],[SmaColor colorWithHexString:@"#F7F7F7" alpha:1]] ByGradientType:0 size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 170)];
        cell.backgroundView = backgroundIma;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BUYCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BUYCELL"];
        UIButton *buyBut = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBut.frame = CGRectMake(0, 0, 300, 40);
        buyBut.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 22);
        UIImageView *backGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        backGroundView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 22);
        backGroundView.image = [UIImage buttonImageFromColors:@[[SmaColor colorWithHexString:@"#75A7F7" alpha:1],[SmaColor colorWithHexString:@"#5781F9" alpha:1]] ByGradientType:leftToRight size:CGSizeMake(300, 40)];
        backGroundView.layer.cornerRadius = 20;
        backGroundView.layer.masksToBounds = YES;
        [cell addSubview:backGroundView];
        
        UILabel *buyLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        buyLab.center  = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 22);
        buyLab.font = FontGothamLight(16);
        buyLab.textColor = [UIColor whiteColor];
        buyLab.textAlignment = NSTextAlignmentCenter;
        buyLab.text = [deviceArr lastObject];
        [cell addSubview:buyLab];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath==%lD",indexPath.row);
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"SM07"];
    }
    else if (indexPath.row == 1){
        [SMADefaultinfos putKey:BANDDEVELIVE andValue:@"up01"];
    }
    if (indexPath.row == deviceArr.count - 1) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatch.com/Store"]];
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
