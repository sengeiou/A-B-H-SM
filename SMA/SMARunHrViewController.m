//
//  SMARunHrViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/24.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARunHrViewController.h"

@interface SMARunHrViewController ()

@end

@implementation SMARunHrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI{
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568 - 64) style:UITableViewStyleGrouped];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hrArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"time: %@",[NSString stringWithFormat:@"%D:%D",[[_hrArr[indexPath.row] objectForKey:@"TIME"] intValue]/60,[[_hrArr[indexPath.row] objectForKey:@"TIME"] intValue]%60]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ bpm",[_hrArr[indexPath.row] objectForKey:@"REAT"]];
    
    return cell;
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
