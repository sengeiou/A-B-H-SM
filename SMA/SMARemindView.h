//
//  SMARemindView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/5.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMARemindView : UIView
@property (nonatomic, strong) UIImageView *backIma;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
@end
