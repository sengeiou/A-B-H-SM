//
//  SMABottomAlerView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/1.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMABottomAlerView;
@protocol tapAlerButDelegate <NSObject>
- (void)bottomAlerView:(SMABottomAlerView *)alerView didAlerBut:(UIButton *)button;

@end

@interface SMABottomAlerView : UIView
@property (nonatomic, weak) id<tapAlerButDelegate> delegate;
- (instancetype)initWithMessage:(NSString *)message leftMess:(NSString *)left rightMess:(NSString *)right;
@end
