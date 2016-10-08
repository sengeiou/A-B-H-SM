//
//  SMATimePickView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol timePickDelegate <NSObject>
- (void)didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)didremoveFromSuperview;
@end

@interface SMATimePickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, weak) id<timePickDelegate> pickDelegate;
- (instancetype)initWithFrame:(CGRect)frame startTime:(NSString *)sTime endTime:(NSString *)eTime;
@end
