//
//  SMAHGDetailViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/9/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Formatter.h"
#import "WYScrollView.h"
#import "SMADetailCell.h"
#import "SMADetailCollectionCell.h"
@interface SMAHGDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WYScrollViewLocalDelegate>
@property (nonatomic, strong) NSDate *date;
@end
