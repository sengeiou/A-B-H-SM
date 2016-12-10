//
//  SMARemindView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/5.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARemindView.h"

@implementation SMARemindView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self  = [super initWithFrame:frame];
    if (self) {
        [self createUIWithTitle:title];
    }
    return self;
}

- (void)createUIWithTitle:(NSString *)tile{
   _backIma = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_backIma];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, self.frame.size.width - 6, self.frame.size.height - 6)];
    titleLab.text = tile;
    titleLab.font = FontGothamLight(12);
    titleLab.textColor = [UIColor whiteColor];
    [self addSubview:titleLab];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
