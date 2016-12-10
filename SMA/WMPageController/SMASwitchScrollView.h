//
//  SMASwitchScrollView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/9.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^endDeceBlock)(CGPoint Offset);
@interface SMASwitchScrollView : UIScrollView<UIScrollViewDelegate>
- (instancetype)initWithSwitchs:(NSArray *)switchs;
- (void)didEndDecelerating:(endDeceBlock)callBack;
@end
