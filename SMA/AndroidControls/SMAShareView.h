//
//  SMAShareView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/28.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAthirdPartyLoginTool.h"
@interface SMAShareView : UIView
typedef void (^shareBlck)(UIButton *button);
@property (nonatomic, strong) UIViewController *shareVC;
- (instancetype)initWithButtonTitles:(NSArray *)buttons butImage:(NSArray *)uiimages shareImage:(UIImage *)image;
@end
