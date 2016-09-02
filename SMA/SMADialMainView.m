//
//  SMADialMainView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/1.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADialMainView.h"

@implementation SMADialMainView


- (void)setDialText:(NSMutableArray *)dialText{
    _dialText = dialText;
    [self addDialView];
}

- (void)addDialView{
    _dialView = [[SMADialView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*5, self.frame.size.width*5)];
    _dialView.backgroundColor = [UIColor orangeColor];
    _dialView.center = CGPointMake(self.frame.size.width/2, _dialView.center.y);
    _dialView.dialArr = _dialText;
    int i  =  [[_dialText lastObject] intValue] - _patientiaDial - 1;
    
    _dialView.transform = CGAffineTransformMakeRotation([_dialView.dialPoinArr[i] floatValue]);
    oldAngle = [_dialView.dialPoinArr[i] floatValue];
    [self addSubview:_dialView];
    UIImageView *pointerIma = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-2, 30, 4, self.frame.size.height/2 - 30)];
    pointerIma.image = [UIImage imageNamed:@"img_Pointer"];
    [self addSubview:pointerIma];
    
}

static CGFloat oldAngle , newAngle;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint movePoint=[touch locationInView:self];
    CGFloat angleInRadians = atan2f(movePoint.y - self.frame.size.height/2, movePoint.x - self.frame.size.width/2);
    newAngle = angleInRadians;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint translation=[touch locationInView:self];
        CGFloat angleInRadians = atan2f(translation.y - self.frame.size.height/2, translation.x - self.frame.size.width/2);
    CGFloat ang = oldAngle + angleInRadians - newAngle;
    _dialView.transform = CGAffineTransformMakeRotation(ang);
    oldAngle = ang;
    newAngle = angleInRadians;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    newAngle = 0;
    CGFloat ang;
   __block NSInteger argument = [[NSString stringWithFormat:@"%0.f",oldAngle/((M_PI/180)*(360.0 /(_dialText.count)))] integerValue];

   
    ang = (M_PI/180)*(360.0 /(_dialText.count)) * (argument);
     NSLog(@" 旋转===%ld ",(long)argument);
    [UIView animateWithDuration:0.2 animations:^{
        _dialView.transform = CGAffineTransformMakeRotation(ang);
    } completion:^(BOOL finished) {
        if (argument > 0) {
            argument = _dialText.count - argument % _dialText.count;
        }
        else{
            argument = argument * -1 ;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(moveViewFinish:)]) {

            [self.delegate moveViewFinish:[NSString stringWithFormat:@"%@",[_dialText objectAtIndex:argument%_dialText.count == 0?(_dialText.count-1):(argument%_dialText.count - 1)]]];
        }
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
