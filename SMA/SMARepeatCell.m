//
//  SMARepeatCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/9.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMARepeatCell.h"

@implementation SMARepeatCell
{
    NSString *weekString;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self createUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createUI{
    [self weekStrConvert:@"124"];
    _repeatLab.text = SMALocalizedString(@"setting_sedentary_repeat");
}

- (IBAction)weekSelector:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self weekStringWithIndex:sender.tag - 101 object:sender.selected?@"1":@"0"];
}

- (void)weekStringWithIndex:(NSInteger)index object:(NSString *)obj{
    NSMutableArray *weekAppSplit = [[weekString componentsSeparatedByString:@","] mutableCopy];
    [weekAppSplit replaceObjectAtIndex:index withObject:obj];
    weekString = [weekAppSplit componentsJoinedByString:@","];
    NSString *str = [SMACalculate toDecimalSystemWithBinarySystem:[weekAppSplit componentsJoinedByString:@""]];
    _repeatBlock(str);
}

- (void)weekStrConvert:(NSString *)weekStr{
    weekString = [SMACalculate toBinarySystemWithDecimalSystem:weekStr];
    NSArray *week = [weekString componentsSeparatedByString: @","];
    NSArray *weekButArr = @[_monBut,_tueBut,_wedBut,_thuBut,_firBut,_satBut,_sunBut];
    int counts = 0;
    for (int i = 0; i < week.count; i++) {
        UIButton *weekBut = (UIButton *)[weekButArr objectAtIndex:i];
        [weekBut setTitle:[self stringWith:i] forState:UIControlStateNormal];
        weekBut.selected = NO;
        if([week[i] intValue]==1)
        {
            counts ++;
            weekBut.selected = YES;
        }
    }
}

-(NSString *)stringWith:(int)weekInt
{
    NSString *weekStr=@"";
    switch (weekInt) {
        case 0:
            weekStr= SMALocalizedString(@"setting_sedentary_mon");
            break;
        case 1:
            weekStr= SMALocalizedString(@"setting_sedentary_tue");
            break;
        case 2:
            weekStr= SMALocalizedString(@"setting_sedentary_wed");
            break;
        case 3:
            weekStr= SMALocalizedString(@"setting_sedentary_thu");
            break;
        case 4:
            weekStr= SMALocalizedString(@"setting_sedentary_fri");
            break;
        case 5:
            weekStr= SMALocalizedString(@"setting_sedentary_sat");
            break;
        default:
            weekStr= SMALocalizedString(@"setting_sedentary_sun");
    }
    return weekStr;
}

@end
