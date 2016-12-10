//
//  SMACenterAlerView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/1.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMACenterAlerView;
@protocol cenAlerButDelegate <NSObject>
- (void)centerAlerView:(SMACenterAlerView *)alerView didAlerBut:(UIButton *)button;

@end
@interface SMACenterAlerView : UIView
@property (nonatomic, weak) id<cenAlerButDelegate> delegate;
- (instancetype)initWithMessage:(NSString *)message buttons:(NSArray *)butArr;
@end
