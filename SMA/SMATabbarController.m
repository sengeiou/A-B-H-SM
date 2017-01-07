//
//  SMATabbarController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/21.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMATabbarController.h"

@interface SMATabbarController ()
{
    NSTimer *rankTimer;
    NSMutableArray *passArr;
}
@end

@implementation SMATabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self initializeMethod];
    
}

- (void)viewWillAppear:(BOOL)animated{
    passArr = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        [passArr addObject:@"0"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int deviceNum;
static int rankNum;
static int setNum;
static int meNum;
static bool setRunk;

//选择控制器之后
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (!rankTimer) {
        rankTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(rankTimeOut) userInfo:nil repeats:NO];
    }
    if ([viewController.tabBarItem.title isEqualToString:SMALocalizedString(@"device_title")]) {
        deviceNum ++;
        if (setRunk) {
            viewController.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",deviceNum];
        }
    }
    if ([viewController.tabBarItem.title isEqualToString:SMALocalizedString(@"rank_title")]) {
        rankNum ++;
        if (setRunk) {
            viewController.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",rankNum];
        }
    }
    if ([viewController.tabBarItem.title isEqualToString:SMALocalizedString(@"setting_title")]) {
        setNum ++;
        if (setRunk) {
            viewController.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",setNum];
        }
    }
    if ([viewController.tabBarItem.title isEqualToString:SMALocalizedString(@"me_title")]) {
        meNum ++;
        if (setRunk) {
            viewController.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",meNum];
        }
        if (deviceNum == 3 && rankNum == 2 && setNum == 3 && !setRunk) {
            deviceNum = 0;
            rankNum = 0;
            setNum = 0;
            meNum = 0;
            setRunk = YES;
        }
        if (meNum >= 2) {
            if (setRunk) {
                int step = deviceNum * 10000 + rankNum * 1000 + setNum * 100 + (int)((arc4random() % (10  + 1)));
//                [SMADefaultinfos removeValueForKey:RUNKSTEP];
                NSDictionary *hisDic = [SMADefaultinfos getValueforKey:RUNKSTEP];
                SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
                if ([[hisDic objectForKey:@"RUNKDATE"] isEqualToString:[NSDate date].yyyyMMddNoLineWithDate]) {
                    if (step >= [[hisDic objectForKey:@"RUNKSTEP"] intValue]){
                        NSDictionary *runStep = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"RUNKSTEP",[NSDate date].yyyyMMddNoLineWithDate,@"RUNKDATE", nil];
                        [SMADefaultinfos putKey:RUNKSTEP andValue:runStep];
                     [webTool acloudSetScore:step];
                    }
                }
                else{
                    NSDictionary *runStep = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",step],@"RUNKSTEP",[NSDate date].yyyyMMddNoLineWithDate,@"RUNKDATE", nil];
                    [SMADefaultinfos putKey:RUNKSTEP andValue:runStep];
                     [webTool acloudSetScore:step];
                }
        }
            deviceNum = 0;
            rankNum = 0;
            setNum = 0;
            meNum = 0;
            setRunk = NO;
            for (UIViewController *controller in tabBarController.viewControllers) {
                controller.tabBarItem.badgeValue = nil;
            }
            [rankTimer invalidate];
            rankTimer = nil;
        }
    }
}

- (void)initializeMethod{
    //预加载数据（暂定睡眠,运动）
//    [[SMADeviceAggregate deviceAggregateTool] initilizeWithWeek];
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

- (void)rankTimeOut{
    for (UIViewController *controller in self.viewControllers) {
        controller.tabBarItem.badgeValue = nil;
    }
    deviceNum = 0;
    rankNum = 0;
    setNum = 0;
    meNum = 0;
    setRunk = NO;
    [rankTimer invalidate];
    rankTimer = nil;
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
