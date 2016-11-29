//
//  SMABottomSelView.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol tapSelectCellDelegate <NSObject>

- (void)didSelectCell:(UIButton *)butCell;

@end

@interface SMABottomSelView : UIView
@property (nonatomic, weak) id<tapSelectCellDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)tit message:(NSArray *)message;
//- (id)viewWithTitle:(NSString *)tile message:(NSArray *)message;

@end
