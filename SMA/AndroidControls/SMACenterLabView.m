//
//  SMACenterLabView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/2.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMACenterLabView.h"

@implementation SMACenterLabView
{
    MyBlock didBlock;
    pickBlock pickDidBlock;
    NSArray *pickContent;
//    NSInteger selectComponent;
}
@synthesize pickView;
- (instancetype)initWithTitle:(NSString *)title buttonTitles:(NSArray *)buttons{
    self = [[SMACenterLabView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    [self createUIWithTitle:title buttonTitles:buttons];
    return self;
}

- (instancetype)initWithPickTitle:(NSString *)title buttonTitles:(NSArray *)buttons pickerMessage:(NSArray *)mesArr{
    self = [[SMACenterLabView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    [self createUIWithTitle:title buttonTitles:buttons pickerMessage:mesArr];
    return self;
}

- (void)createUIWithTitle:(NSString *)title buttonTitles:(NSArray *)buttons{
    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(36, MainScreen.size.height/2 - 50 *3, MainScreen.size.width - 72, 165)];
    backView.backgroundColor = [UIColor grayColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6;
    [self addSubview:backView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 50)];
    titleLab.font = FontGothamLight(16);
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    [backView addSubview:titleLab];
    
    UIView *fieldView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame) + 1, CGRectGetWidth(backView.frame), 55)];
    fieldView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:fieldView];
    _tableField = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, CGRectGetWidth(backView.frame) - 16, 58)];
    _tableField.font = FontGothamLight(17);
    _tableField.tintColor = [UIColor blackColor];
    _tableField.delegate = self;
    [fieldView addSubview:_tableField];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(fieldView.frame) + 1, CGRectGetWidth(backView.frame), 59)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:bottomView];
    for (int i = 0; i < 2; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(14.5 + ((CGRectGetWidth(backView.frame) - 54)/2 + 25) * i, 10, (CGRectGetWidth(backView.frame) - 54)/2, 40);
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 4;
        but.backgroundColor = [SmaColor colorWithHexString:@"#5791f9" alpha:1];
        but.titleLabel.font = FontGothamLight(17);
        but.titleLabel.numberOfLines = -1;
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGSize fontSize = [buttons[0] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        CGSize fontSize1 = [buttons[1] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        if (fontSize.width >= (CGRectGetWidth(backView.frame) - 54)/2 - 3 || fontSize1.width >= (CGRectGetWidth(backView.frame) - 54)/2 - 3) {
            but.titleLabel.font = FontGothamLight(15);
        }
        if (i == 0) {
            but.backgroundColor = [SmaColor colorWithHexString:@"#999999" alpha:1];
        }
        but.tag = 101 +i;
        [but setTitle:buttons[i] forState:UIControlStateNormal];
        
        [but addTarget:self action:@selector(tapButCount:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:but];
    }
    [_tableField becomeFirstResponder];
}

- (void)createUIWithTitle:(NSString *)title buttonTitles:(NSArray *)buttons pickerMessage:(NSArray *)mesArr{
    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(36, MainScreen.size.height/2 - 50 *3, MainScreen.size.width - 72, 210)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6;
    [self addSubview:backView];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 50)];
    titleLab.font = FontGothamLight(15);
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    [backView addSubview:titleLab];
    
    pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame), CGRectGetWidth(backView.frame), 100)];
//    selectComponent = 33;
    pickContent = mesArr;
    pickView.delegate = self;
    pickView.dataSource = self;
    [backView addSubview:pickView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pickView.frame), CGRectGetWidth(backView.frame), 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:bottomView];
    for (int i = 0; i < 2; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(14.5 + ((CGRectGetWidth(backView.frame) - 54)/2 + 25) * i, 10, (CGRectGetWidth(backView.frame) - 54)/2, 40);
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 4;
        but.backgroundColor = [SmaColor colorWithHexString:@"#5791f9" alpha:1];
        but.titleLabel.font = FontGothamLight(17);
        but.titleLabel.numberOfLines = -1;
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGSize fontSize = [buttons[0] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        CGSize fontSize1 = [buttons[1] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        if (fontSize.width >= (CGRectGetWidth(backView.frame) - 54)/2 - 3 || fontSize1.width >= (CGRectGetWidth(backView.frame) - 54)/2 - 3) {
            but.titleLabel.font = FontGothamLight(15);
        }
        if (i == 0) {
            but.backgroundColor = [SmaColor colorWithHexString:@"#999999" alpha:1];
        }
        but.tag = 101 +i;
        [but setTitle:buttons[i] forState:UIControlStateNormal];
        
        [but addTarget:self action:@selector(tapButCount:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:but];
    }
    [_tableField becomeFirstResponder];
}

- (void)lableDidSelectRow:(MyBlock)callBack{
    didBlock = callBack;
}

- (void)tapButCount:(UIButton *)sender{
    didBlock(sender,_tableField.text);

    [_tableField resignFirstResponder];
    [self removeFromSuperview];
}

- (void)pickDidSelectRow:(pickBlock)callBack{
      pickDidBlock = callBack;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    pickDidBlock(row,component);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return pickContent.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [pickContent[component] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = nil;
   if (view != nil) {
        label = (UILabel *)view;
    }else{
        label = [[UILabel alloc] init];
    }
    label.font = FontGothamLight(17);
    NSString *dataTime = [pickContent[component] objectAtIndex:row];
    label.text = dataTime;
    label.textAlignment=NSTextAlignmentCenter;
    label.bounds = CGRectMake(0, 0,MainScreen.size.width, 40);
    return label;
}


//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    NSLog(@"gwgwrgh==%@  %@  %@",aString,string,textField.text);
//    if ([aString dataUsingEncoding:NSUTF8StringEncoding].length > 17) {
//        return NO;
//    }
//    return YES;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
