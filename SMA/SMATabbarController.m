//
//  SMATabbarController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/21.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMATabbarController.h"

@interface SMATabbarController ()

@end

@implementation SMATabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeMethod];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    //预加载数据（暂定睡眠,运动）
    [[SMADeviceAggregate deviceAggregateTool] initilizeWithWeek];
    if (!_isLogin) {
            SmaAnalysisWebServiceTool *webService = [[SmaAnalysisWebServiceTool alloc] init];
//            [webService acloudDownLDataWithAccount:[SMAAccountTool userInfo].userID callBack:^(id finish) {
//                if ([finish isEqualToString:@"finish"]) {
//                    NSNotification *updateNot = [NSNotification notificationWithName:@"updateData" object:@{@"UPDATE":@"updateUI"}];
//                    [SmaNotificationCenter postNotification:updateNot];
//                }
//            }];
//        });
    }
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
