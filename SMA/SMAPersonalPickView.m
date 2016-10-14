//
//  SMAPersonalPickView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/13.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAPersonalPickView.h"

@implementation SMAPersonalPickView
{
    UIView *pickview;
    NSMutableArray *cotentArr;
}

- (instancetype)initWithFrame:(CGRect)frame viewContentWithRow:(NSMutableArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        cotentArr = array;
        [self createUI];
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

- (void)createUI{
    pickview = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , MainScreen.size.width, 200)];
    pickview.backgroundColor = [SmaColor colorWithHexString:@"#F1F6FF" alpha:1];
    [self addSubview:pickview];
   _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 200)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    [pickview addSubview:_pickView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        pickview.transform = CGAffineTransformMakeTranslation(0, -200);
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return  cotentArr.count;
}

- (NSInteger )pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
        return [cotentArr[component] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lab;
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width/cotentArr.count, 40)];
        lab.font = FontGothamLight(17);
        lab.text = [cotentArr[component] objectAtIndex:row];
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_pickDelegate && [_pickDelegate respondsToSelector:@selector(pickView:didSelectRow:inComponent:)]) {
        [_pickDelegate pickView:self didSelectRow:row inComponent:component];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
