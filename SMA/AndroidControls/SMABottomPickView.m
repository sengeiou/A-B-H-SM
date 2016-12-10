//
//  SMABottomPickView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/1.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMABottomPickView.h"

@implementation SMABottomPickView
{
    NSArray *pickContent;
    confiButton confirm;
    pickerSelectRow selectBlock;
    UILabel *beReminLab;
    UILabel *endReminLab;
    NSArray *describeArr;
    UIView *backView;
}
@synthesize pickView;

- (instancetype)initWithTitles:(NSArray *)titles describes:(NSArray *)describe buttonTitles:(NSArray *)buttons pickerMessage:(NSArray *)mesArr{
    self = [[SMABottomPickView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    [self createUIWithTitles:titles describes:describe buttonTitles:buttons pickerMessage:mesArr];
    return self;
}

- (void)createUIWithTitles:(NSArray *)titles describes:(NSArray *)describe buttonTitles:(NSArray *)buttons pickerMessage:(NSArray *)mesArr{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//        [self addGestureRecognizer:tapGR];
    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreen.size.height, MainScreen.size.width, 280)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UIView *titView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 60)];
    [backView addSubview:titView];
    
    UILabel *beginLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width/describe.count, describe ? 30:60)];
    beginLab.textAlignment = NSTextAlignmentCenter;
    beginLab.font = FontGothamLight(16);
    beginLab.text = titles[0];
    [titView addSubview:beginLab];
    
    UILabel *endLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width/describe.count, 0, MainScreen.size.width/describe.count, describe ? 30:60)];
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.font = FontGothamLight(16);
    endLab.text = titles[0];
    [titView addSubview:endLab];
    describeArr = describe;
    if (describe) {
        beReminLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(beginLab.frame), MainScreen.size.width/describe.count, 30)];
        beReminLab.textAlignment = NSTextAlignmentCenter;
        beReminLab.font = FontGothamLight(14);
        beReminLab.text = describe[0];
        [titView addSubview:beReminLab];
        
        endReminLab = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen.size.width/describe.count, CGRectGetMaxY(beginLab.frame), MainScreen.size.width/describe.count, 30)];
        endReminLab.textAlignment = NSTextAlignmentCenter;
        endReminLab.font = FontGothamLight(14);
        endReminLab.text = describe[0];
        [titView addSubview:endReminLab];
    }
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titView.frame), MainScreen.size.width, 180)];
    pickContent = mesArr;
    pickView.delegate = self;
    pickView.dataSource = self;
    [backView addSubview:pickView];
    
    for (int i = 0; i < 2; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0 + MainScreen.size.width/2 * i, CGRectGetMaxY(pickView.frame), MainScreen.size.width/2, 40);
        but.tag = 101 + i;
        [but setTitle:buttons[i] forState:UIControlStateNormal];
        but.backgroundColor = [SmaColor colorWithHexString:@"#5891f9" alpha:1];
        but.titleLabel.font = FontGothamLight(16);
        if (i == 0) {
            but.backgroundColor = [SmaColor colorWithHexString:@"#999999" alpha:1];
        }
        [but addTarget:self action:@selector(butSelector:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:but];
    }
    [UIView animateWithDuration:0.3 animations:^{
        backView.transform = CGAffineTransformMakeTranslation(0, -280);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapAction{
    [UIView animateWithDuration:0.3 animations:^{
        backView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
   
}

- (void)selectConfirm:(confiButton)confirmBlock{
    confirm  = confirmBlock;
}

- (void)pickSelectCallBack:(pickerSelectRow)callBack{
    selectBlock = callBack;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return pickContent.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickContent[component] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = nil;
    if (view != nil) {
        label = (UILabel *)view;
    }else{
        label = [[UILabel alloc] init];
    }
    label.font = FontGothamLight(20);
    NSString *dataTime = [pickContent[component] objectAtIndex:row];
    
    label.text = dataTime;
    label.textAlignment=NSTextAlignmentCenter;
    label.bounds = CGRectMake(0, 0,MainScreen.size.width/pickContent.count, 60);
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 1) {
        if (row % 24 <= 8) {
            endReminLab.text = describeArr[1];
        }
        else{
            endReminLab.text = describeArr[0];
        }
    }
    selectBlock(row,component);
}

- (void)butSelector:(UIButton *)but{
        confirm(but);
     [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
