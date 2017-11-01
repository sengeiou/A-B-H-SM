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
    _perLab.text = ([[SMADefaultinfos getValueforKey:BANDDEVELIVE]  isEqualToString:@"SMA-B2"] || [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]) ? SMALocalizedString(@"device_SP_heat"):SMALocalizedString(@"device_RU_per");
    _beginDeLab.text = dataDic[@"STARTTIME"];
    _endDeLab.text = dataDic[@"ENDTIME"];
    _disDeLab.attributedText = dataDic[@"DISTANCE"];
    _perDeLab.attributedText = ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"] || [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]) ? dataDic[@"CAL"]:dataDic[@"PER"];
    _perImageView.image =  ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"] || [[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]) ?  [UIImage imageNamed:@"icon_call"]:[UIImage imageNamed:@"icon_pace"];
    _disImageView.image = [UIImage imageNamed:@"icon_distance"];
}

- (void)createUIWithCylingData:(NSMutableDictionary *)dataDic{
    _beginLab.text = SMALocalizedString(@"setting_sedentary_star");
    _endLab.text = SMALocalizedString(@"setting_sedentary_end");
    _disLab.text = SMALocalizedString(@"device_SP_heat");
    _perLab.text = SMALocalizedString(@"device_HR_rect");
    _beginDeLab.text = [self putTimeWithMinute:[[dataDic objectForKey:@"PRECISESTART"] doubleValue]];
    _endDeLab.text = [self putTimeWithMinute:[[dataDic objectForKey:@"PRECISEEND"] doubleValue]];
    _disDeLab.attributedText = [self putHrWithReat:dataDic[@"CAL"] unit:SMALocalizedString(@"device_SP_cal")];
    _perDeLab.attributedText = [self putHrWithReat:dataDic[@"HEART"] unit:@"bpm"];
    _perImageView.image = [UIImage imageNamed:@"icon_hr"];
    _disImageView.image = [UIImage imageNamed:@"icon_call"];
}

- (NSString *)putTimeWithMinute:(double)millisecond{
    //    NSString *hour = [NSString stringWithFormat:@"%@%.0f",minute/3600 < 10 ? @"0":@"",minute/3600];
    //    NSString *min = [NSString stringWithFormat:@"%@%d",minute%60 < 10 ? @"0":@"",minute%60];
    NSString *date = [SMADateDaultionfos stringFormmsecIntervalSince1970:millisecond withFormatStr:@"HH:mm:ss" timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return date;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSMutableAttributedString *)putHrWithReat:(NSString *)hr unit:(NSString *)unit{
    NSDictionary *disDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(19)};
    NSDictionary *unitDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(14)};
    NSMutableAttributedString *perAttStr = [[NSMutableAttributedString alloc] initWithString:hr ? hr:@"0" attributes:disDic];
    NSAttributedString *unitAtt = [[NSAttributedString alloc] initWithString:unit attributes:unitDic];
    [perAttStr appendAttributedString:unitAtt];
    return perAttStr;
}
@end

