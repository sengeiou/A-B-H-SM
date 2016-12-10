//
//  SMAChangeCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/6.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAChangeCell.h"

@implementation SMAChangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _passField.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_passField resignFirstResponder];
    return YES;
}
@end
