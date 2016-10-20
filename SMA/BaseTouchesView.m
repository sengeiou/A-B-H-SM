

#import "BaseTouchesView.h"

@implementation BaseTouchesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.multipleTouchEnabled = YES;
    }
    return self;
}

#pragma mark *******创建UI*******
- (void)createUI{
    //    [self removeFromSuperview];
    if (!backImage) {
        self.backgroundColor = [UIColor clearColor];
        backImage = [[UIImageView alloc] init];
        backImage.image = [UIImage imageNamed:@"信息框"];
        
        [self addSubview:backImage];
        
        mindImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 10, 9, 8)];
        mindImage.center = CGPointMake(mindImage.center.x, self.frame.size.height/2-2);
        mindImage.image = [UIImage imageNamed:@"详情页面心图标"];
        [self addSubview:mindImage];
    }
    backImage.frame = CGRectMake(0, 0, 15 + HRSize.width + TISize.width, self.frame.size.height);
    if (!self.HRLab) {
        self.HRLab = [[UILabel alloc] init];
        [self addSubview:self.HRLab];
    }
    self.HRLab.frame = CGRectMake(CGRectGetMaxX(mindImage.frame)+1, 3, HRSize.width, HRSize.height);
    self.HRLab.font =FontGothamLight(17);
    self.HRLab.text = textArr[0];
 
    
    if (!self.HRUnitLab) {
        self.HRUnitLab = [[UILabel alloc] init];
        [self addSubview:self.HRUnitLab];
    }
    self.HRUnitLab.frame = CGRectMake(CGRectGetMaxX(self.HRLab.frame)+2, 2, UNSize.width, UNSize.height);
    self.HRUnitLab.font =FontGothamLight(8);
    self.HRUnitLab.text = textArr[1];
    
    
    if (!self.timeLab) {
        self.timeLab = [[UILabel alloc] init];
        [self addSubview:self.timeLab];
    }
    self.timeLab.frame = CGRectMake(CGRectGetMinX(self.HRUnitLab.frame)-1, CGRectGetMaxY(self.HRUnitLab.frame)+2, TISize.width+3, TISize.height);
    self.timeLab.font =FontGothamLight(8);
    self.timeLab.text = textArr[2];

    
}

- (CGFloat)clearUpWhithHR:(NSString *)hr HRUnit:(NSString *)unit HRTime:(NSString *)time{
    CGFloat whith;
    HRSize = [hr sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
    TISize = [time sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(8)}];
    UNSize = [unit sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(8)}];
    whith = 15 + HRSize.width + TISize.width;
    textArr = @[hr,unit,time];
    return whith;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate theTouchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate theTouchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.delegate theTouchesEnded:touches withEvent:event];
}

@end
