//
//  SMAWatchCollectionController.h
//  ViewFrameDemo
//
//  Created by 有限公司 深圳市 on 2016/12/6.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAWatchCollectionCell.h"
#import "SMAWatchView.h"
#import "SmaDialSwitchView.h"
#import "UIScrollView+MJRefresh.h"
@interface SMAWatchCollectionController : UICollectionViewController<BLConnectDelegate>
@property (nonatomic, strong) NSString *watchBucket;
@end
