//
//  UIBarButtonItem+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CKQ)
/**
 *  快速创建一个显示图片的item
 *
 *  @param action   监听方法
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon frame:(CGRect)frame target:(id)target action:(SEL)action transfrom:(int)rotation;
+ (UIBarButtonItem *)backItemWithTarget:(id)target Hidden:(BOOL)hidden action:(SEL)action;
@end
