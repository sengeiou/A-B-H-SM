//
//  SMABottomSelView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMABottomSelView.h"

@implementation SMABottomSelView
{
    NSString *title;
    NSArray *messArr;
    UIView *backView;
    BOOL hidden;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)tit message:(NSArray *)message{
    self = [super initWithFrame:frame];
    if (self) {
        title = tit;
        messArr = message;
        self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
        [self createUI];

    }
    return self;
}

//- (id)viewWithTitle:(NSString *)tile message:(NSArray *)message{
//    SMABottomSelView *selectView = [[SMABottomSelView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
//    title = tile;
//    messArr = message;
//    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
//    [self createUI];
//    return selectView;
//}

- (void)createUI{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGR];
    
    CGFloat sumHeight = 44.0 + 45.0 * messArr.count;
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), sumHeight)];
    [self addSubview:backView];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 44)];
    titLab.text = title;
    titLab.font = FontGothamLight(17);
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.backgroundColor = [UIColor whiteColor];
    [backView addSubview:titLab];
    
    for (int i = 0; i < messArr.count; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, (CGRectGetMaxY(titLab.frame) + 1) * (i + 1), CGRectGetWidth(self.frame), 44);
        but.tag = 101 + i;
        but.titleLabel.font = FontGothamLight(17);
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        but.backgroundColor = [UIColor whiteColor];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitle:messArr[i] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(tapCell:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:but];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        backView.transform = CGAffineTransformMakeTranslation(0, - sumHeight);
        NSLog(@"+++%@",NSStringFromCGRect(self.frame));
    }];
}

- (void)tapAction{
   [self removeFromSuperview];
}

- (void)tapCell:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCell:)]) {
        [self.delegate didSelectCell:sender];
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
