//
//  SmaQuietView.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/12/7.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import "SmaQuietView.h"

@implementation SmaQuietView

- (void)createUI{
    self.backgroundColor = [UIColor colorWithRed:87/255.0 green:87/255.1 blue:87/255.0 alpha:0.7];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/1.5, 100)];
    view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2-54);
    view.backgroundColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
    view.layer.masksToBounds = YES;
    //    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 18;
    [self addSubview:view];
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, view.frame.size.width/2, 30)];
    self.titleLab.backgroundColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
    self.titleLab.text = SMALocalizedString(@"device_HR_quiet");
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.font = FontGothamLight(15);
    [view addSubview:self.titleLab];
    self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLab.frame)-1, 0, view.frame.size.width/2-10, 30)];
    
    self.dateLab.textAlignment = NSTextAlignmentRight;
    self.dateLab.backgroundColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1];
    //    self.dateLab.text = @"2015/12/12";
    self.dateLab.textColor = [UIColor whiteColor];
    self.dateLab.font = FontGothamLight(15);
    [view addSubview:self.dateLab];
    self.quietField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), view.frame.size.width, 35)];
    self.quietField.delegate = self;
    self.quietField.font = FontGothamLight(15);
    self.unitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    self.unitLab.font = FontGothamLight(15);
    self.unitLab.text = @"bpm";
    self.quietField.rightViewMode = UITextFieldViewModeAlways;
    self.quietField.rightView = self.unitLab;
    self.quietField.backgroundColor = [UIColor whiteColor];
    self.quietField.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:self.quietField];
    self.cancleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleBut.frame = CGRectMake(-1, CGRectGetMaxY(self.quietField.frame), view.frame.size.width/2+2, 35);
    self.cancleBut.backgroundColor = [UIColor whiteColor];
    [self.cancleBut setTitle:SMALocalizedString(@"setting_sedentary_cancel") forState:UIControlStateNormal];
    [self.cancleBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancleBut.titleLabel.font = FontGothamLight(14);
    self.cancleBut.layer.borderColor = [UIColor colorWithRed:87/255.0 green:87/255.1 blue:87/255.0 alpha:0.7].CGColor;
    self.cancleBut.layer.borderWidth = 1.0;
    self.cancleBut.layer.masksToBounds = YES;
    [self.cancleBut addTarget:self action:@selector(cancleBut:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.cancleBut];
    
    self.confirmBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBut.frame = CGRectMake(CGRectGetMaxX(self.cancleBut.frame)-2, CGRectGetMaxY(self.quietField.frame), view.frame.size.width/2+2, 35);
    self.confirmBut.backgroundColor = [UIColor whiteColor];
    [self.confirmBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
    [self.confirmBut setTitle:SMALocalizedString(@"hearReat_dele") forState:UIControlStateSelected];
    [self.confirmBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.confirmBut.titleLabel.font = FontGothamLight(14);
    self.confirmBut.layer.borderColor = [UIColor colorWithRed:87/255.0 green:87/255.1 blue:87/255.0 alpha:0.7].CGColor;
    [self.confirmBut addTarget:self action:@selector(confirmBut:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBut.layer.borderWidth = 1.0;
    self.confirmBut.layer.masksToBounds = YES;
    [view addSubview:self.confirmBut];
    // 3.监听键盘的通知
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createUIWithAndiord{
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.1 blue:0/255.0 alpha:0.5];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/1.2, 146)];
    view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2-54);
    view.backgroundColor = [UIColor colorWithRed:87/255.0 green:87/255.1 blue:87/255.0 alpha:1];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 8;
    [self addSubview:view];
    UIView *titView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 44)];
    titView.backgroundColor = [UIColor whiteColor];
    [view addSubview:titView];
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width/2, 44)];
    self.titleLab.text = SMALocalizedString(@"device_HR_quiet");
    self.titleLab.font = FontGothamLight(16);
    [titView addSubview:self.titleLab];
    self.dateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLab.frame)-1, 0, view.frame.size.width/2-20, 44)];
    
    self.dateLab.textAlignment = NSTextAlignmentRight;
    self.dateLab.font = FontGothamLight(16);
    [titView addSubview:self.dateLab];
    self.quietField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titView.frame) + 1, view.frame.size.width, 50)];
    self.quietField.delegate = self;
    self.quietField.font = FontGothamLight(16);
    self.unitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 35)];
    self.unitLab.font = FontGothamLight(15);
    self.unitLab.text = @"bpm";
    self.quietField.rightViewMode = UITextFieldViewModeAlways;
    self.quietField.rightView = self.unitLab;

    self.quietField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    self.quietField.placeholder = SMALocalizedString(@"device_HR_importQuiet");
    self.quietField.leftViewMode = UITextFieldViewModeAlways;
    self.quietField.backgroundColor = [UIColor whiteColor];
    self.quietField.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:self.quietField];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.quietField.frame) + 1, view.frame.size.width, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [view addSubview:bottomView];
    
    self.cancleBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancleBut.frame = CGRectMake(10, 5,(CGRectGetWidth(bottomView.frame) - 40)/2, 40);
    self.cancleBut.backgroundColor = [UIColor grayColor];
    [self.cancleBut setTitle:SMALocalizedString(@"setting_sedentary_cancel") forState:UIControlStateNormal];
    self.cancleBut.titleLabel.font = FontGothamLight(17);
    self.cancleBut.layer.cornerRadius = 6;
    self.cancleBut.layer.masksToBounds = YES;
    [self.cancleBut addTarget:self action:@selector(cancleBut:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.cancleBut];
    
    self.confirmBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBut.frame = CGRectMake((CGRectGetWidth(bottomView.frame) - 40)/2 + 30, 5, (CGRectGetWidth(bottomView.frame) - 40)/2, 40);
    self.confirmBut.backgroundColor = [SmaColor colorWithHexString:@"#EA1F75" alpha:1];
    [self.confirmBut setTitle:SMALocalizedString(@"setting_sedentary_confirm") forState:UIControlStateNormal];
    [self.confirmBut setTitle:SMALocalizedString(@"hearReat_dele") forState:UIControlStateSelected];
    self.confirmBut.titleLabel.font = FontGothamLight(17);
    self.confirmBut.layer.borderColor = [UIColor colorWithRed:87/255.0 green:87/255.1 blue:87/255.0 alpha:0.7].CGColor;
    self.confirmBut.layer.cornerRadius = 6;
    self.confirmBut.layer.masksToBounds = YES;
    [self.confirmBut addTarget:self action:@selector(confirmBut:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.confirmBut];
    // 3.监听键盘的通知
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [SmaNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (aString.length > 3) {
        textField.text = [aString substringToIndex:3];
        return NO;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)note
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardWillShow)]) {
        [self.delegate keyboardWillShow];
    }
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height+160);
        // self.btnImgView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
    }];
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformIdentity;
        //self.btnImgView.transform = CGAffineTransformIdentity;
    }];
}

- (void)cancleBut:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelWithBut:)]) {
        [self.delegate cancelWithBut:sender];
    }
}

- (void)confirmBut:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmWithBut:)]) {
        [self.delegate confirmWithBut:sender];
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
