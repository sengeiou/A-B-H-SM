//
//  SMARunTableViewCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/22.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARunTableViewCell.h"

@implementation SMARunTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)createUIWithData:(NSMutableDictionary *)dataDic{
    _beginLab.text = SMALocalizedString(@"setting_sedentary_star");
    _endLab.text = SMALocalizedString(@"setting_sedentary_end");
    _disLab.text = SMALocalizedString(@"device_SP_sumDista");
    _perLab.text = SMALocalizedString(@"device_RU_per");
    _beginDeLab.text = dataDic[@"STARTTIME"];
    _endDeLab.text = dataDic[@"ENDTIME"];
    _disDeLab.attributedText = dataDic[@"DISTANCE"];
    _perDeLab.attributedText = dataDic[@"PER"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
