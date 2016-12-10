//
//  SMAWatchCollectionCell.h
//  ViewFrameDemo
//
//  Created by 有限公司 深圳市 on 2016/12/7.
//  Copyright © 2016年 Wecan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAWatchCollectionCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *switchView;
@property (nonatomic, strong) NSDictionary *watchDic;
@end
