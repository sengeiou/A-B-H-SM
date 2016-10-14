//
//  SMAPersonalPickView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/13.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMAPersonalPickView;
@protocol PersonalPickDelegate <NSObject>
- (void)pickView:(SMAPersonalPickView *)pickview didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)didremoveFromSuperview;
@end

@interface SMAPersonalPickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, weak) id<PersonalPickDelegate> pickDelegate;
- (instancetype)initWithFrame:(CGRect)frame viewContentWithRow:(NSMutableArray *)array;
@end
