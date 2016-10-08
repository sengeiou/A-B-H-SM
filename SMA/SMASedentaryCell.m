//
//  SMASedentaryCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/26.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASedentaryCell.h"

@implementation SMASedentaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchSelector:(UISwitch *)sender{
    _block(sender);
}
@end
