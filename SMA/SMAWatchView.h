//
//  SMAWatchView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/7.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmaSliderButton.h"
typedef void (^tapBlock)(NSMutableArray *switchArr);
@interface SMAWatchView : UIView<BLConnectDelegate>
@property (nonatomic, strong) NSMutableArray *olSwitchArr;
- (instancetype)initWithWatchInfos:(NSDictionary *)dicInof watchImage:(UIImage *)image;
- (void)didButSelect:(tapBlock)callBack;
@end
