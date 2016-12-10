//
//  SMASelectDeviceController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/30.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMASelectCell.h"
#import "SMAPairViewController.h"
#import "SMANavViewController.h"
#import "SMATabbarController.h"
@interface SMASelectDeviceController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UIButton *buyBut, *unPairBut;
@property (nonatomic, weak) IBOutlet UITableView *selectTView;
@property (nonatomic, assign) BOOL isSelect;
@end
