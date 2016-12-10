//
//  SMAChangePassViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/6.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAChangeCell.h"
@interface SMAChangePassViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UIButton *changeBut;
@end
