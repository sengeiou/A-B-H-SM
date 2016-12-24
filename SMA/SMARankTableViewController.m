//
//  SMARankTableViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/28.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARankTableViewController.h"

@interface SMARankTableViewController ()
{
    NSMutableArray *rankList;
    NSArray *rankImaArr;
}
@end

@implementation SMARankTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    rankImaArr = @[@"gold_medal",@"silver_medal",@"bronze_medal"];
}

- (void)createUI{
    self.title = SMALocalizedString(@"rank_title");
    self.tableView.tableFooterView = [[UIView alloc] init];
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
//    [webTool acloudSetScore:13670];
}


- (void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
        [webTool acloudCheckRankingCallBack:^(NSMutableArray *list, NSError *error) {
            if (list) {
                rankList = list;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rankList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMARankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DATACELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SMARankTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < 3) {
        [cell.rankBut setImage:[UIImage imageWithName:rankImaArr[indexPath.row]] forState:UIControlStateDisabled];
    }
    else{
        [cell.rankBut setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1] forState:UIControlStateDisabled];
    }
    [cell setrankList:[rankList objectAtIndex:indexPath.row]];
//    cell.rankIma.image = [[rankList objectAtIndex:indexPath.row] objectForKey:@"IMAGE"];
//    cell.nameLab.text = [[rankList objectAtIndex:indexPath.row] objectForKey:@"NAME"];
//    cell.stepsLab.text = [NSString stringWithFormat:@"%d%@",[[[rankList objectAtIndex:indexPath.row] objectForKey:@"SCORE"] intValue],[[[rankList objectAtIndex:indexPath.row] objectForKey:@"SCORE"] intValue] > 1 ? SMALocalizedString(@"device_SP_steps"):SMALocalizedString(@"device_SP_step")];
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
