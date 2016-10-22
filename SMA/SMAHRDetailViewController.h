//
//  SMAHRDetailViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/21.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScattView.h"
#import "SMADetailCell.h"
#import "ZXRollView.h"
#import "SMADetailCollectionCell.h"
#import "NSDate+Formatter.h"
@interface SMAHRDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,corePlotViewDelegate,ZXRollViewDelegate>
@property (nonatomic, strong) NSDate *date;
@end
