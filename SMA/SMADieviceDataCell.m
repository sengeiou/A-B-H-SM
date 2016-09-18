//
//  SMADieviceDataCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/5.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADieviceDataCell.h"

@implementation SMADieviceDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self createUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createUI{
//    self.opaque = NO;
    //加阴影--任海丽编辑
    _backgrouView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _backgrouView.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用 
    _backgrouView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    _backgrouView.layer.shadowRadius = 3;//阴影半径，默认3
    
//    _roundLab1.layer.masksToBounds = YES;
//    _roundLab1.layer.cornerRadius = 3.5;
//    _roundLab2.layer.masksToBounds = YES;
//    _roundLab2.layer.cornerRadius = 3.5;
//    _roundLab3.layer.masksToBounds = YES;
//    _roundLab3.layer.cornerRadius = 3.5;

    
}

@end
