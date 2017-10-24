//
//  SMADieviceDataCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/5.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADieviceDataCell.h"

@implementation SMADieviceDataCell
{
    imaBlock tapBlock;
}
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
    /*******防止卡顿 二 ****/
    _backgrouView.layer.shouldRasterize = YES;
    _backgrouView.layer.rasterizationScale =  [UIScreen mainScreen].scale;
//    _backgrouView.layer.contentsScale = 2.0;
    _backgrouView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _backgrouView.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用 
    _backgrouView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    _backgrouView.layer.shadowRadius = 3;//阴影半径，默认3
    _dialLab.adjustsFontSizeToFitWidth = YES;
//    [self reoundAddRecognizer];
    /*******防止卡顿 二
    _backgrouView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backgrouView.layer.shadowOpacity = 0.8; //此参数默认为0，即阴影不显示
    _backgrouView.layer.shadowRadius = 2.0; //给阴影加上圆角，对性能无明显影响
    _backgrouView.layer.shadowOffset = CGSizeMake(0,3);
    //设定路径：与视图的边界相同
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, MainScreen.size.width - 16, 180 - 16)];
    _backgrouView.layer.shadowPath = path.CGPath;//路径默认为 nil  防止卡顿
********/
    
    
//    _roundLab1.layer.masksToBounds = YES;
//    _roundLab1.layer.cornerRadius = 3.5;
//    _roundLab2.layer.masksToBounds = YES;
//    _roundLab2.layer.cornerRadius = 3.5;
//    _roundLab3.layer.masksToBounds = YES;
//    _roundLab3.layer.cornerRadius = 3.5;

}

- (void)reoundAddRecognizer{
   UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_roundView1 addGestureRecognizer:tapGR];
    UITapGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_roundView2 addGestureRecognizer:tapGR1];
    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_roundView3 addGestureRecognizer:tapGR2];
}

- (void)tapRoundView:(imaBlock)callBlock{
    tapBlock = callBlock;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
//    tapBlock((UIImageView *)tap.view);
}

- (IBAction)tapSelector:(UIButton *)sender{
    tapBlock(sender,_goalView);
}
@end
