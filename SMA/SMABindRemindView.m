//
//  SMABindRemindView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/23.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMABindRemindView.h"

@implementation SMABindRemindView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

- (void)createUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIImageView *deviceIma = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreen.size.width - 110, 65, 95, 95)];
    deviceIma.backgroundColor = [UIColor greenColor];
    [self addSubview:deviceIma];
    
    UIImageView *linesIma = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(deviceIma.frame)-60, CGRectGetMaxY(deviceIma.frame), 46, 80)];
    linesIma.backgroundColor = [UIColor redColor];
    [self addSubview:linesIma];
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(linesIma.frame)+8, MainScreen.size.width - 40, 25)];
    remindLab.font = FontGothamLight(25);
    remindLab.textAlignment = NSTextAlignmentCenter;
    remindLab.backgroundColor = [UIColor orangeColor];
    remindLab.text = SMALocalizedString(@"setting_band_remind");
    [self addSubview:remindLab];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
