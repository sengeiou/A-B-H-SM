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
//    [self removeFromSuperview];
}

- (void)createUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    UIImageView *deviceIma = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreen.size.width - 110, 65, 95, 95)];
//    deviceIma.backgroundColor = [UIColor greenColor];
//    [self addSubview:deviceIma];
//    
//    UIImageView *linesIma = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(deviceIma.frame)-60, CGRectGetMaxY(deviceIma.frame), 46, 80)];
//    linesIma.backgroundColor = [UIColor redColor];
//    [self addSubview:linesIma];
//    
//    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(linesIma.frame)+8, MainScreen.size.width - 40, 25)];
//    remindLab.font = FontGothamLight(25);
//    remindLab.textAlignment = NSTextAlignmentCenter;
//    remindLab.backgroundColor = [UIColor orangeColor];
//    remindLab.text = SMALocalizedString(@"setting_band_remind");
//    [self addSubview:remindLab];
    
//    UIImageView *deviceIma = [[UIImageView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(28.5, MainScreen.size.height - 190, MainScreen.size.width - 57, 180)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 20;
    [self addSubview:backView];
    
    UIImageView *deviceIma = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9, 88, 126)];
    NSString *imageStr;
    if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"]) {
        imageStr = @"img_queren";
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
        imageStr = @"img_queren_shouhuan";
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A1"]){
        imageStr = @"img_queren_a1";
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A2"]){
        imageStr = @"img_queren_A2";
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"]){
        imageStr = @"img_queren_B2";
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]){
        imageStr = @"img_queren_shouhuan_B3";
    }
    else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"]){
        imageStr = @"img_queren_r1";
    }
    deviceIma.image = [UIImage imageNamed:imageStr];

    deviceIma.center = CGPointMake(CGRectGetWidth(backView.frame)/2, deviceIma.center.y);
    [backView addSubview:deviceIma];
    
    UILabel *remindLab = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(deviceIma.frame), CGRectGetWidth(backView.frame) - 36, 45)];
    remindLab.text = [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"] ? SMALocalizedString(@"setting_band_remind"):[[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"] ? SMALocalizedString(@"setting_band_remindWatch"):SMALocalizedString(@"setting_band_remindBand");
    remindLab.numberOfLines = 3;
    remindLab.font = FontGothamLight(14);
    remindLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:remindLab];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
