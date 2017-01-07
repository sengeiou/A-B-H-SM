//
//  SmaSliderButton.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 16/7/20.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "SmaSliderButton.h"

@implementation SmaSliderButton
{
    //内容layer
    CAShapeLayer * _contentLayer;
    CAGradientLayer * _gradLayerR;
    CALayer * _gradLayer;
    CAShapeLayer * _shapeLayer;

    CALayer *maskLayer;
}

-(void)reloadView{

    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = self.frame.size.height/2;
    _contentLayer = [CAShapeLayer layer];
    _contentLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _contentLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:_contentLayer];
    
    _gradLayer = [CALayer layer];
    _gradLayer.bounds = _contentLayer.bounds;
    _gradLayer.position = _contentLayer.position;
    _gradLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineCap  = kCALineCapRound;

    _shapeLayer.strokeColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1].CGColor;
    _shapeLayer.fillColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1].CGColor;
    [_contentLayer addSublayer:_shapeLayer];

}

- (void)setProgress:(float)progress{
    _progress = progress>1?1:progress;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, self.frame.size.width*_progress, self.frame.size.height);
    CGPathAddArc(path, nil, self.frame.size.width*_progress, self.frame.size.height/2, self.frame.size.height/2,M_PI_2,M_PI * 1.5 , YES);
    CGPathAddLineToPoint(path, nil, self.frame.size.width*_progress, 0);
    _shapeLayer.path = path;
}

- (void)setFilClolr:(UIColor *)color{
    _shapeLayer.strokeColor = color.CGColor;
    _shapeLayer.fillColor = color.CGColor;
}

- (void)reloadArcView{
    [_contentLayer removeFromSuperlayer];
    _contentLayer = [CAShapeLayer layer];
    _contentLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _contentLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
 
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    //进行边界描绘 默认线宽为4px
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.height/2 startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    _shapeLayer.path = path.CGPath;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = self.frame.size.height;
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd = 1;
    _shapeLayer.transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);//翻转图层以做成顺时针加载效果
    [_contentLayer setMask:_shapeLayer];
    [self.layer addSublayer:_contentLayer];
}

- (void)setArcProgress:(float)progress{
    _shapeLayer.strokeStart = 0;
    NSLog(@"fwgg==%f",progress);
    _shapeLayer.strokeEnd =1 - (progress>1?1:progress);

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [_shapeLayer removeAllAnimations];
        _shapeLayer.strokeEnd = _progress>1?1:_progress;
    }
}

- (void)setImageWithOffset:(int)offset{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
        [web acloudDownLoadImageWithOffset:offset callBack:^(id finish) {
            [self setImageWithDic:finish];
        }];
    });
}

- (void)setImageWithDic:(NSDictionary *)dic{
    if (dic) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",dic[@"filename"]]];
            NSData *data = [NSData dataWithContentsOfFile:uniquePath];
            UIImage *img = [[UIImage alloc] initWithData:data];
            if (!img) {
                SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
                web.chaImageName = [NSString stringWithFormat:@"%@.png",dic[@"filename"]];
                [web acloudDownFileWithsession:[dic objectForKey:@"downloadUrl"] callBack:^(float progress, NSError *error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateNormal];
                            [self setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateHighlighted];
                            [self setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateDisabled];
                        });
                    }
                } CompleteCallback:^(NSString *filePath) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSData *data = [NSData dataWithContentsOfFile:filePath];
                        if (data) {
                            [self setBackgroundImage:[[UIImage alloc] initWithData:data] forState:UIControlStateNormal];
                            [self setBackgroundImage:[[UIImage alloc] initWithData:data] forState:UIControlStateHighlighted];
                             [self setBackgroundImage:[[UIImage alloc] initWithData:data] forState:UIControlStateDisabled];
                        }
                        else{
                            [self setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateNormal];
                            [self setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateHighlighted];
                             [self setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateDisabled];
                        }
                        
                    });
                }];
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"setimage");
                    [self setBackgroundImage:img forState:UIControlStateNormal];
                    [self setBackgroundImage:img forState:UIControlStateHighlighted];
                    [self setBackgroundImage:img forState:UIControlStateDisabled];
                });
            }
        });
    }

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//
//}


@end
