//
//  SMAHRDetailViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/21.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMADetailCell.h"
#import "SMADetailCollectionCell.h"
#import "SMAQuietHRViewController.h"
#import "NSDate+Formatter.h"
#import "WYScrollView.h"
@interface SMAHRDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WYScrollViewLocalDelegate>
@property (nonatomic, strong) NSDate *date;
@end
