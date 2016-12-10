//
//  SMAChangePassViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/6.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAChangePassViewController.h"

@interface SMAChangePassViewController ()
{
    NSArray *titleArr;
    CGFloat maxWeight;
    SMAUserInfo *user;
}
@end

@implementation SMAChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    user = [SMAAccountTool userInfo];
    titleArr = @[@[SMALocalizedString(@"me_chanPass_oldPass"),SMALocalizedString(@"me_chanPass_newPass"),SMALocalizedString(@"me_chanPass_affirmPass")],@[SMALocalizedString(@"me_chanPass_putOldPass"),SMALocalizedString(@"me_chanPass_putNewPass"),SMALocalizedString(@"me_chanPass_putAffPass")]];
    NSMutableArray *weightArr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++ ) {
        CGSize size = [[titleArr [0] objectAtIndex:i] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(16)}];
        [weightArr addObject:[NSString stringWithFormat:@"%f",size.width]];
    }
   maxWeight =[[weightArr valueForKeyPath:@"@max.floatValue"] floatValue];
    [_changeBut setTitle:SMALocalizedString(@"me_chanPass_affirm") forState:UIControlStateNormal];
}

- (void)createUI{
    self.title = SMALocalizedString(@"login_findPass");
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titleArr[0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMAChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CHANGECELL"];
    if (!cell) {
         cell = (SMAChangeCell *)[[[NSBundle mainBundle] loadNibNamed:@"SMAChangeCell" owner:self options:nil] lastObject];
    }
    cell.passW.constant = maxWeight + 2;
    cell.passTitLab.text = titleArr[0][indexPath.row];
    cell.passField.placeholder = titleArr[1][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)changeSelector:(id)sender{
    SMAChangeCell *oldPassCell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    SMAChangeCell *newPassCell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    SMAChangeCell *newPassCell1 = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSLog(@"%@  %@   %@",oldPassCell.passField.text,newPassCell.passField.text,newPassCell1.passField.text);
    if (![oldPassCell.passField.text isEqualToString:user.userPass]) {
        [MBProgressHUD showError:SMALocalizedString(@"me_chanPass_passFail")];
        return;
    }
    if (![newPassCell.passField.text isEqualToString:newPassCell1.passField.text]) {
        [MBProgressHUD showError:SMALocalizedString(@"me_chanPass_newPasFail")];
        return;
    }
    SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
    [webTool acloudChangePasswordWithOld:oldPassCell.passField.text new:newPassCell.passField.text callback:^(NSString *uid, NSError *error) {
        if (!error) {
            user.userPass = newPassCell.passField.text;
            [SMAAccountTool saveUser:user];
            [MBProgressHUD showSuccess:SMALocalizedString(@"me_chanPass_chanSucc")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

        }
        else{
            [MBProgressHUD showError:[NSString stringWithFormat:@"%ld %@",(long)error.code,SMALocalizedString(@"me_chanPass_chanFail")]];
        }
    }];
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
