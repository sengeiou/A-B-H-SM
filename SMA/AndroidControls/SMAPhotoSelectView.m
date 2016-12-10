//
//  SMAPhotoSelectView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/9.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAPhotoSelectView.h"

@implementation SMAPhotoSelectView
{
    photoBlck block;
}

- (instancetype)initWithButtonTitles:(NSArray *)buttons{
    self = [[SMAPhotoSelectView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    [self createUIWithButtonTitles:buttons];
    return self;
}

- (void)createUIWithButtonTitles:(NSArray *)buttons{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGR];
    
    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(36, MainScreen.size.height/2 - 30 *3, MainScreen.size.width - 72, 169)];
    backView.backgroundColor = [SmaColor colorWithHexString:@"#ffffff" alpha:0.5];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6;
    [self addSubview:backView];
    
    UIView *titView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), CGRectGetHeight(backView.frame) - 41)];
    titView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:titView];
    
    float width = CGRectGetWidth(backView.frame) - 60;
       for (int j = 0; j < buttons.count; j ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
           but.titleLabel.font = FontGothamLight(17);
           but.tag = 101 +j;
           but.titleLabel.numberOfLines = 2;
           [but setTitle:buttons[j] forState:UIControlStateNormal];
           but.layer.masksToBounds = YES;
           but.layer.cornerRadius = 6;
           but.backgroundColor = [SmaColor colorWithHexString:@"#5791f9" alpha:1];
           but.frame = CGRectMake((CGRectGetWidth(backView.frame) - width)/2, 16 + 56 * j, width , 40);
           [but addTarget:self action:@selector(tapButCount:) forControlEvents:UIControlEventTouchUpInside];
           [titView addSubview:but];
    }
    
    UIButton *canBut = [UIButton buttonWithType:UIButtonTypeCustom];
    canBut.frame = CGRectMake(0, CGRectGetMaxY(titView.frame) + 1, CGRectGetWidth(titView.frame), 40);
    canBut.titleLabel.font = FontGothamLight(17);
    canBut.backgroundColor = [UIColor whiteColor];
    [canBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canBut setTitle:SMALocalizedString(@"setting_sedentary_cancel") forState:UIControlStateNormal];
    [canBut addTarget:self action:@selector(tapCanCount:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:canBut];
}

- (void)tapAction{
    [self removeFromSuperview];
}

- (void)didPhotoSelect:(photoBlck)callBack{
    block = callBack;
}

- (void)tapButCount:(UIButton *)sender{
    block(sender);
    [self removeFromSuperview];
}

- (void)tapCanCount:(UIButton *)sender{
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
