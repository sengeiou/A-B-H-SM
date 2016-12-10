//
//  SMACenterAlerView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/1.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMACenterAlerView.h"

@implementation SMACenterAlerView

- (instancetype)initWithMessage:(NSString *)message buttons:(NSArray *)butArr {
    self = [[SMACenterAlerView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    //    [self addSubview:alerView];
    [self createUIwithMessage:message buttons:butArr];
    return self;

}

- (void)createUIwithMessage:(NSString *)message buttons:(NSArray *)butAr{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self addGestureRecognizer:tapGR];
    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width - 72, 170)];
    backView.center = CGPointMake(MainScreen.size.width/2, MainScreen.size.height/2);
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6;
    [self addSubview:backView];
    
    UILabel *messageLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 105)];
    messageLab.font = FontGothamLight(17);
    messageLab.numberOfLines = -1;
    messageLab.text = message;
    messageLab.backgroundColor = [UIColor whiteColor];
    messageLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:messageLab];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(messageLab.frame) + 1, CGRectGetWidth(backView.frame), 69)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:bottomView];
    for (int i = 0; i < 2; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(14.5 + ((CGRectGetWidth(backView.frame) - 54)/2 + 25) * i, 12, (CGRectGetWidth(backView.frame) - 54)/2, 40);
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 4;
        but.backgroundColor = [SmaColor colorWithHexString:@"#5791f9" alpha:1];
        but.titleLabel.font = FontGothamLight(17);
        but.titleLabel.numberOfLines = -1;
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGSize fontSize = [butAr[0] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        CGSize fontSize1 = [butAr[1] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        if (fontSize.width >= (CGRectGetWidth(backView.frame) - 54)/2 - 3 || fontSize1.width >= (CGRectGetWidth(backView.frame) - 54)/2 - 3) {
            but.titleLabel.font = FontGothamLight(15);
        }
        if (i == 0) {
            but.backgroundColor = [SmaColor colorWithHexString:@"#999999" alpha:1];
        }
        but.tag = 101 +i;
        [but setTitle:butAr[i] forState:UIControlStateNormal];
       
        [but addTarget:self action:@selector(tapButCount:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:but];
    }
}

- (void)tapAction{
    [self removeFromSuperview];
}

- (void)tapButCount:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(centerAlerView:didAlerBut:)]) {
        [self.delegate centerAlerView:self didAlerBut:sender];
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
