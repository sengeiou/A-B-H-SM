//
//  SmaDialSwitchView.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 16/7/20.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmaSliderButton.h"

@interface SmaDialSwitchView : UIView<SmaCoreBlueToolDelegate>
@property (nonatomic, strong) UIButton *backgroundBut, *cancelBut, *confitBut;
@property (nonatomic, strong) SmaSliderButton *sliderBut;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *witchView, *backView;
@property (nonatomic, strong) NSMutableArray *witchsArr;
- (id)initWithFrame:(CGRect)frame backgrondImageName:(NSString *)image oldSwitch:(NSMutableArray *)images;
@end
