//
//  SMABottomAlerView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/1.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMABottomAlerView.h"

@implementation SMABottomAlerView
{
//    UIButton *leftBut, *rightBut;
//    UILabel *messageLab;
}
//- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message leftMess:(NSString *)left rightMess:(NSString *)right{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//    }
//}

- (instancetype)initWithMessage:(NSString *)message leftMess:(NSString *)left rightMess:(NSString *)right{
    self = [[SMABottomAlerView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
//    [self addSubview:alerView];
    [self createUIWithMessage:message leftMess:left rightMess:right];
    return self;
}

- (void)createUIWithMessage:(NSString *)message leftMess:(NSString *)left rightMess:(NSString *)right{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self addGestureRecognizer:tapGR];
   self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    CGFloat messageHeigh = [SMACalculate heightForLableWithText:message Font:FontGothamLight(17) AndlableWidth:MainScreen.size.width - 20] + 20;
    if (messageHeigh <= 90) {
        messageHeigh = 90;
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - messageHeigh - 60, MainScreen.size.width, messageHeigh + 60)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(10, backView.frame.size.height - messageHeigh - 60, MainScreen.size.width - 20, messageHeigh)];
    messageLab.font = FontGothamLight(16);
    messageLab.numberOfLines = -1;
    messageLab.text = message;
    messageLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:messageLab];
    
    NSArray *textArr = @[left,right];
    for (int i = 0; i < 2; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(10 + ((MainScreen.size.width - 36)/2 + 16) * i, CGRectGetHeight(backView.frame) - 52, (MainScreen.size.width - 32)/2, 40);
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 20;
        but.layer.borderColor = [UIColor grayColor].CGColor;
        but.layer.borderWidth = 1.0f;
        but.tag = 101 +i;
        [but setTitle:textArr[i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.titleLabel.font = FontGothamLight(16);
        [but addTarget:self action:@selector(tapButCount:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:but];
    }
}

- (void)tapAction{
    [self removeFromSuperview];
}

- (void)tapButCount:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomAlerView:didAlerBut:)]) {
        [self.delegate bottomAlerView:self didAlerBut:sender];
    }
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
