//
//  SMADetailCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/10/17.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADetailCell.h"

@implementation SMADetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createUI{
    _topLine = [CALayer layer];
    _topLine.frame = CGRectMake(25+7, 0, 1, (44.0 - 15)/2);
    _topLine.backgroundColor =  [UIColor colorWithRed:137/255.0 green: 228/255.0 blue:247/255.0 alpha:1].CGColor;
    [self.contentView.layer addSublayer:_topLine];
    
    _oval = [CAShapeLayer layer];
    _oval.frame       = CGRectMake(25, CGRectGetMaxY(_topLine.frame), 15, 15);
    _oval.fillColor   = [UIColor whiteColor].CGColor;
    _oval.strokeColor = [UIColor colorWithRed:137/255.0 green: 228/255.0 blue:247/255.0 alpha:1].CGColor;
    _oval.lineWidth   = 2;
    _oval.path        = [self ovalPath].CGPath;
    [self.contentView.layer addSublayer:_oval];
    
    
    _botLine = [CALayer layer];
    _botLine.frame = CGRectMake(25+7, CGRectGetMaxY(_oval.frame) + 0.5, 1, (44.0 - 15)/2 );
    _botLine.backgroundColor =  [UIColor colorWithRed:137/255.0 green: 228/255.0 blue:247/255.0 alpha:1].CGColor;
    
    [self.contentView.layer addSublayer:_botLine];
    self.contentView.layer.shouldRasterize = YES;
    self.contentView.layer.rasterizationScale =  [UIScreen mainScreen].scale;
}

- (UIBezierPath*)ovalPath{
    UIBezierPath*  ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 15, 15)];
    return ovalPath;
}
@end
