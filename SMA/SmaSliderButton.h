//
//  SmaSliderButton.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 16/7/20.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmaSliderButton : UIButton
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) float progress;
-(void)reloadView;
- (void)reloadArcView;
- (void)setArcProgress:(float)progress;
- (void)setFilClolr:(UIColor *)color;
- (void)setImageWithOffset:(int)offset;
- (void)setImageWithDic:(NSDictionary *)dic;
@end
