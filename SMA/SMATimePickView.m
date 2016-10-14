//
//  SMATimePickView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMATimePickView.h"

@implementation SMATimePickView
{
    NSMutableArray *starTarr;
    NSMutableArray *endTarr;
    UIView *pickview;
}

- (instancetype)initWithFrame:(CGRect)frame startTime:(NSString *)sTime endTime:(NSString *)eTime{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeMethod];
        [self createUIWithTime:sTime endTime:eTime];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        pickview.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (_pickDelegate && [_pickDelegate respondsToSelector:@selector(didremoveFromSuperview)]) {
            [_pickDelegate didremoveFromSuperview];
        }
        [self removeFromSuperview];
    }];
   
}

- (void)initializeMethod{
    starTarr = [NSMutableArray array];
    endTarr = [NSMutableArray array];
    for (int i = 0; i < 17; i++) {
        [starTarr addObject:[NSString stringWithFormat:@"%d:00",i + 8]];
        if (i < 16) {
            [endTarr addObject:[NSString stringWithFormat:@"%d:59",i + 8]];
        }
    }
}

- (void)createUIWithTime:(NSString *)sTime endTime:(NSString *)eTime{
    pickview = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , MainScreen.size.width, 240)];
    pickview.backgroundColor = [SmaColor colorWithHexString:@"#F1F6FF" alpha:1];
    [self addSubview:pickview];
    
    UILabel *startLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , MainScreen.size.width/2, 40)];
    startLab.font = FontGothamLight(17);
    startLab.text = SMALocalizedString(@"setting_sedentary_star");
    startLab.textAlignment = NSTextAlignmentCenter;
    [pickview addSubview:startLab];
    
    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startLab.frame), 0, MainScreen.size.width/2, 40)];
    endLab.font = FontGothamLight(17);
    endLab.text = SMALocalizedString(@"setting_sedentary_end");
    endLab.textAlignment = NSTextAlignmentCenter;
    [pickview addSubview:endLab];

    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(endLab.frame), MainScreen.size.width, 1)];
    lineLab.backgroundColor = [UIColor grayColor];
    [pickview addSubview:lineLab];
    
    UIPickerView *timePickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLab.frame) + 1, MainScreen.size.width, 200)];
    timePickView.delegate = self;
    timePickView.dataSource = self;
    [timePickView selectRow:[[sTime componentsSeparatedByString:@":"][0] integerValue] - 8 inComponent:0 animated:NO];
    [timePickView selectRow:[[eTime componentsSeparatedByString:@":"][0] integerValue] - 8 inComponent:1 animated:NO];
    [pickview addSubview:timePickView];
        
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        pickview.transform = CGAffineTransformMakeTranslation(0, -240);
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  2;
}

- (NSInteger )pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return starTarr.count;
    }
        return endTarr.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *timeLab;
    if (component == 0) {
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width/2, 40)];
        timeLab.font = FontGothamLight(17);
        timeLab.text = starTarr[row];
    }
    else{
        timeLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width/2, 0, MainScreen.size.width/2, 40)];
        timeLab.font = FontGothamLight(17);
        timeLab.text = endTarr[row];
    }
    timeLab.textAlignment = NSTextAlignmentCenter;
    return timeLab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_pickDelegate && [_pickDelegate respondsToSelector:@selector(didSelectRow:inComponent:)]) {
        [_pickDelegate didSelectRow:row inComponent:component];
    }
}

@end
