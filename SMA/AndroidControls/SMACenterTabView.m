//
//  SMACenterTabView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/2.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMACenterTabView.h"

@implementation SMACenterTabView
{
    UITableView *tabView;
    NSArray *messArr;
    NSString *selectStr;
    MyBlock didBlock;
    NSIndexPath *indPath;
    NSString *selectIma;
}

- (instancetype)initWithMessages:(NSArray *)message selectMessage:(NSString *)select selName:(NSString *)selImaName{
    self = [[SMACenterTabView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    selectIma = selImaName;
    [self createUIwithMessages:message selectMessage:select];
    return self;
}

- (void)createUIwithMessages:(NSArray *)message selectMessage:(NSString *)select{
    messArr = message;
    selectStr = select;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self addGestureRecognizer:tapGR];
    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    CGFloat tabHeight = message.count > 5 ? 5 * 44:message.count * 44;
//    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(20, MainScreen.size.height/2 - 44 *3, MainScreen.size.width - 40, tabHeight)];
//    [self addSubview:backView];
    
    tabView = [[UITableView alloc] initWithFrame:CGRectMake(20, MainScreen.size.height/2 - 44 *3, MainScreen.size.width - 40, tabHeight) style:UITableViewStylePlain];
    tabView.scrollEnabled = NO;
    if (message.count > 4) {
        tabView.scrollEnabled = YES;
    }
    tabView.layer.masksToBounds = YES;
    tabView.layer.cornerRadius = 3;
    tabView.delegate = self;
    tabView.dataSource = self;
    [self addSubview:tabView];
}

- (void)tapAction{
   [self removeFromSuperview];
}

#pragma mark ********UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tabView dequeueReusableCellWithIdentifier:@"SELECTCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SELECTCELL"];
    }
    cell.textLabel.text = messArr[indexPath.row];
    cell.textLabel.font = FontGothamLight(17);
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_normal"]];
    if ([messArr[indexPath.row] isEqualToString:selectStr]) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:selectIma]];
    }
    return cell;
}

- (void)tabViewDidSelectRow:(MyBlock)callBack{
    didBlock = callBack;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    didBlock(indexPath);
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
