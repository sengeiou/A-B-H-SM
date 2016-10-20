//
//  SMASportDetailViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADetailCell.h"
#import "SMADetailCollectionCell.h"
#import "ScattView.h"
#import "NSDate+Formatter.h"
#import "ZXRollView.h"
@interface SMASportDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,corePlotViewDelegate,ZXRollViewDelegate>
@property (nonatomic, strong) NSDate *date;
@end
