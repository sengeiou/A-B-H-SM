//
//  SMAHGView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2017/9/4.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didBar)(NSDictionary *barDic, NSInteger selInteger);
@interface SMAHGView : UIView
- (void)drawPolyline:(NSDictionary *)Dic;
- (void)drawBarGraph:(NSDictionary *)Dic;
- (void)didSelectBar:(didBar)callBack;
@end
