//
//  MTKSleepView.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/5/17.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTKSleepView : UIView
@property (strong, nonatomic) NSArray *xValues;
@property (strong, nonatomic) NSArray *xTexts;
@property (strong, nonatomic) NSArray *yValues;

// 左边间距要根据具体的坐标值去计算
@property (assign, nonatomic) CGFloat leftLineMargin;
+(instancetype)charView;
@end
