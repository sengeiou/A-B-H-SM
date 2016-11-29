//
//  SMATrackViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMATrackDetailView.h"
#import "SMARunHrViewController.h"
@interface SMATrackViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableDictionary *runDic;
@end
