//
//  SMAPickerView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/8/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAPickerView.h"

@implementation SMAPickerView
{
    NSArray *pickContent;
    
    NSInteger selectComponent;
}
@synthesize pickView;

- (id)initWithFrame:(CGRect)frame ButtonTitles:(NSArray *)titles ickerMessage:(NSArray *)mesArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [SmaColor colorWithHexString:@"#F1F6FF" alpha:1];
        [self createUImesage:mesArr ButtonTitles:titles];
    }
    return self;
}

- (void)createUImesage:(NSArray *)mes ButtonTitles:(NSArray *)titles{
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, self.frame.size.height)];
    selectComponent = 33;
    pickContent = mes;
    pickView.delegate = self;
    pickView.dataSource = self;
    [self addSubview:pickView];
    
//    for (int i = 0; i < 2; i++) {
//        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//        but.frame = CGRectMake(0+(MainScreen.size.width/2 * i), CGRectGetMaxY(pickView.frame), MainScreen.size.width/2, 40);
//        but.backgroundColor = [SmaColor colorWithHexString:@"#5891F9" alpha:1];
//        [but setTitle:titles[i] forState:UIControlStateNormal];
//        if (i == 0) {
//            but.backgroundColor = [SmaColor colorWithHexString:@"#999999" alpha:1];
//        }
//        but.tag = 101 + i;
//        but.titleLabel.font = FontGothamLight(17);
//        [but addTarget:self action:@selector(butSelector:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:but];
//    }
//        [pickView selectRow:selectComponent inComponent:0 animated:NO];
}

- (void)butSelector:(UIButton *)but{
    if (but.tag == 101) {
        _cancel(but);
    }
    else{
        _confirm([pickContent[selectComponent] integerValue]);
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return pickContent.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

   return [pickContent[component] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = nil;
    
    if (view != nil) {
        label = (UILabel *)view;
        //设置bound
    }else{
        label = [[UILabel alloc] init];
    }
    label.font = FontGothamLight(17);
//    if (component == 0) {
    
        NSString *dataTime = [pickContent[component] objectAtIndex:row];
        
        label.text = dataTime;
        label.textAlignment=NSTextAlignmentCenter;
        label.bounds = CGRectMake(0, 0,MainScreen.size.width, 30);
//    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectComponent = row;
    _row(row,component);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
