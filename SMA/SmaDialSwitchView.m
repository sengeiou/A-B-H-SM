//
//  SmaDialSwitchView.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 16/7/20.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "SmaDialSwitchView.h"

@implementation SmaDialSwitchView
{
    NSInteger switchIndex;
    NSTimer * _timer;
    NSString *switchIma;
    NSMutableArray *olSwitchArr;
    BOOL uploadSwitch;
}
- (id)initWithFrame:(CGRect)frame backgrondImageName:(NSString *)image oldSwitch:(NSMutableArray *)images{
    self = [super initWithFrame:frame];{
        SmaBleSend.delegate = self;
//        SmaBleSend.isUPDateSwitch = NO;
        self.backgroundColor = [UIColor clearColor];
        switchIma = image;
        if (images.count == 0) {
            [SmaBleSend getSwitchNumber];
        }
        else{
            olSwitchArr = images;
        }
        [self createUIWithimage:image];
    }
    return self;
}


- (void)createUIWithimage:(NSString *)image{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _witchView = [[UIView alloc] initWithFrame:CGRectMake(30,(self.frame.size.height - 104)/5,self.frame.size.width-60, 180)];
    _witchView.backgroundColor = [UIColor whiteColor];
    _witchView.layer.masksToBounds = YES;
    _witchView.layer.cornerRadius = 5.0f;
    [self addSubview:_witchView];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _witchView.frame.size.width, _witchView.frame.size.height/4*3)];
    _backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1];
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8,_witchView.frame.size.width/2.5,_witchView.frame.size.width/2.5)];
    _backgroundView.center = CGPointMake(_witchView.frame.size.width/2, _backView.frame.size.height/2);
    _backgroundView.image = [UIImage imageNamed:image];
    _backgroundView.backgroundColor = [UIColor redColor];
    [_witchView addSubview:_backView];
    [_backView addSubview:_backgroundView];
    for (int i = 0; i < 2 ; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(_witchView.frame.size.width/6,0,_witchView.frame.size.width/2.5,(_witchView.frame.size.height - _backView.frame.size.height)/3*1.5);
        but.center = CGPointMake(_witchView.frame.size.width/4+(i*_witchView.frame.size.width/2), (_witchView.frame.size.height - _backView.frame.size.height)/2+_backView.frame.size.height);
        but.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1];
        [but setTitle:@[SMALocalizedString(@"clokadd_can"),SMALocalizedString(@"setting_Switch")][i] forState:UIControlStateNormal];
        but.tag = 1001 + i;
        but.layer.borderWidth = 2.0f;
        but.layer.masksToBounds = YES;
        but.layer.borderColor = [UIColor clearColor].CGColor;
        but.layer.cornerRadius = but.frame.size.height/2;
        [but addTarget:self action:@selector(witchBut:) forControlEvents:UIControlEventTouchUpInside];
        [_witchView addSubview:but];
    }
}

- (void)witchBut:(UIButton *)sender{
    if (sender.tag == 1001) {
        UIButton *but = (UIButton *)[_witchView viewWithTag:1002];
        but.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1];
        but.selected = NO;
        but.enabled = YES;
        [but setTitle:SMALocalizedString(@"setting_Switch") forState:UIControlStateNormal];
        self.hidden = YES;
    }
    else{
        if (sender.selected) {
            [self setSwitchBinData];
            for (UIButton *but in _backView.subviews) {
                if (but.tag > 1100) {
                    but.enabled = NO;
                }
            }
            
            _sliderBut = [SmaSliderButton buttonWithType:UIButtonTypeCustom];
            _sliderBut.enabled = NO;
            UIButton *but0 = (UIButton *)[_witchView viewWithTag:1001];
            UIButton *but1 = (UIButton *)[_witchView viewWithTag:1002];
            SmaSliderButton *selBut = (SmaSliderButton *)[_witchView viewWithTag:1100+switchIndex];
            _sliderBut.frame = CGRectMake(0,0, CGRectGetMaxX(but1.frame)-CGRectGetMinX(but0.frame), but0.frame.size.height);
            _sliderBut.center = CGPointMake(_witchView.frame.size.width/2, (_witchView.frame.size.height - _backView.frame.size.height)/2+_backView.frame.size.height);
            [_sliderBut addTarget:self action:@selector(setSwitchFinish:) forControlEvents:UIControlEventTouchUpInside];
            [_sliderBut setTitle:SMALocalizedString(@"setting_switching") forState:UIControlStateNormal];
            [_sliderBut reloadView];
            [_witchView addSubview:_sliderBut];
            [selBut reloadArcView];
            //            [selBut setBackgroundImage:switchIma forState:UIControlStateNormal];
            [selBut setBackgroundImage:[UIImage imageNamed:switchIma] forState:UIControlStateDisabled];
            but1.hidden = YES;
            but0.hidden = YES;
            
//            [SmaBleSend getXmodem];
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            //             _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setSwitchProgress) userInfo:nil repeats:YES];
        }
        
        if (!sender.selected) {
            sender.selected = YES;
            sender.enabled = NO;
            [sender setTitle:SMALocalizedString(@"setting_accept") forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor grayColor];
            [self selectWitchsShow];
        }
    }
}

static float i = 0.0;
- (void)setSwitchProgress:(float) progress{
    i = i+0.1;
    SmaSliderButton *but1 = (SmaSliderButton *)[_witchView viewWithTag:1100+switchIndex];
    [but1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [but1 setBackgroundImage:nil forState:UIControlStateDisabled];
    //    [but1 setBackgroundImage:nil forState:UIControlStateNormal];
    //    [but1 setTitle:[NSString stringWithFormat:@"%.0f%%",i*100] forState:UIControlStateNormal];
    [but1 setArcProgress:progress];
    _sliderBut.progress = progress;
    //    if (progress >= 1) {
    //        [_sliderBut setTitle:SmaLocalizedString(@"setting_complete") forState:UIControlStateNormal];
    //        uploadSwitch = YES;
    ////        [self setSwitchFail];
    //        [but1 setTitle:@"" forState:UIControlStateNormal];
    //        _sliderBut.enabled = YES;
    ////        i = 0;
    //        [_timer invalidate];
    //        _timer = nil;
    //    }
}

- (void)selectWitchsShow{
    UILabel *selectLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, _witchView.frame.size.width, 21)];
    _backgroundView.hidden = YES;
    selectLab.text = SMALocalizedString(@"setting_selectSwitch");
    selectLab.textColor = [UIColor whiteColor];
    selectLab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:selectLab];
    for (int i = 0; i < 3; i++) {     //手表上已经存在的三个表盘
        SmaSliderButton *witchBut = [SmaSliderButton buttonWithType:UIButtonTypeCustom];
        witchBut.frame = CGRectMake(10+(i*((_backView.frame.size.width-60)/3+20)),(_backView.frame.size.height - (_backView.frame.size.width-60)/3 - 29)/2+29, (_backView.frame.size.width-60)/3, (_backView.frame.size.width-60)/3);
        //        witchBut.backgroundColor = [UIColor yellowColor];
        [witchBut setBackgroundImage:[UIImage imageNamed:olSwitchArr[i]] forState:UIControlStateNormal];
        [witchBut setBackgroundImage:[UIImage imageNamed:olSwitchArr[i]] forState:UIControlStateDisabled];
        if ([olSwitchArr[i] isEqualToString:switchIma]) {
            switchIndex = i + 1;
        }
        witchBut.tag = 1101 + i;
        [witchBut addTarget:self action:@selector(selectWitch:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:witchBut];
    }
    if (switchIndex>0) {
        [self selectOnlySwitch];
    }
}

- (void)selectOnlySwitch{
    for (UIButton *but in _backView.subviews) {
        if (but.tag > 1100) {
            but.layer.borderWidth = 3.0f;
            but.layer.masksToBounds = YES;
            but.layer.borderColor = [UIColor clearColor].CGColor;
            but.enabled = NO;
        }
    }
    UIButton *but1 = (UIButton *)[_backView viewWithTag:1100+switchIndex];
//    SmaBleMgr.switchNumber = (int)switchIndex;
    but1.layer.borderWidth = 3.0f;
    but1.layer.masksToBounds = YES;
    but1.layer.borderColor = [UIColor redColor].CGColor;
    UIButton *but = (UIButton *)[_witchView viewWithTag:1002];
    but.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1];
    but.enabled = YES;
}

- (void)selectWitch:(UIButton *)sender{
    for (UIButton *but in _backView.subviews) {
        if (but.tag > 1100) {
            but.layer.borderWidth = 3.0f;
            but.layer.masksToBounds = YES;
            but.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    
    switchIndex = sender.tag - 1100;
//    SmaBleMgr.switchNumber = (int)switchIndex;
    sender.layer.borderWidth = 3.0f;
    sender.layer.masksToBounds = YES;
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
    UIButton *but = (UIButton *)[_witchView viewWithTag:1002];
    but.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1];
    but.enabled = YES;
}

- (void)setSwitchFinish:(UIButton *)sender{
    if (uploadSwitch) {
        [self removeFromSuperview];
    }
    else{
        [_sliderBut removeFromSuperview];
        for (UIButton *but in _witchView.subviews) {
            if (but.tag > 1000 && but.tag < 1100) {
                but.enabled = YES;
                but.hidden = NO;
            }
            int i = 0;
            for (UIButton *but in _backView.subviews) {
                if (but.tag > 1100) {
                    //                    [but setBackgroundImage:[but imageForState:UIControlStateNormal] forState:UIControlStateNormal];
                    //                    [but setBackgroundImage:[but imageForState:UIControlStateNormal] forState:UIControlStateDisabled];
                    [but setBackgroundImage:[UIImage imageNamed:olSwitchArr[i]] forState:UIControlStateNormal];
                    [but setBackgroundImage:[UIImage imageNamed:olSwitchArr[i]] forState:UIControlStateDisabled];
                    i++;
                    but.enabled = YES;
                }
            }
        }
    }
}

- (void)setSwitchFail{
    [_sliderBut setTitle:SMALocalizedString(@"aler_syncerror") forState:UIControlStateNormal];
    [_sliderBut setFilClolr:[UIColor colorWithRed:255/255.0 green:67/255.0 blue:107/255.0 alpha:1]];
}

- (void)setSwitchBinData{
    NSData *reader=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[switchIma stringByAppendingString:@".tea"] ofType:@"bin"]];
//    [SmaBleMgr setSwitchs:reader];
}


-(void)NotificationSwitchs:(NSDictionary *)switchDic{
    [olSwitchArr removeAllObjects];
    olSwitchArr = nil;
    olSwitchArr = [NSMutableArray array];
    for (int i = 0; i < [switchDic allValues].count; i++) {
        int switchNum = [[[switchDic allValues] objectAtIndex:i] intValue];
        if (switchNum<10) {
            [olSwitchArr addObject:[NSString stringWithFormat:@"watch_%@",[NSString stringWithFormat:@"00000%d",switchNum]]];
        }
        else if (switchNum >=10 && i < 100){
            [olSwitchArr addObject:[NSString stringWithFormat:@"watch_%@",[NSString stringWithFormat:@"0000%d",switchNum]]];
        }
        else if (switchNum >= 100 && i < 1000){
            [olSwitchArr addObject:[NSString stringWithFormat:@"watch_%@",[NSString stringWithFormat:@"000%d",switchNum]]];
        }
    }
}

- (void)updateProgressWithNow:(NSString *)now AllData:(NSString *)all{
    [self setSwitchProgress:(now.floatValue +1)/all.floatValue];
}

- (void)updateProgressEnd:(BOOL)success{
    [olSwitchArr replaceObjectAtIndex:switchIndex-1 withObject:switchIma];
    SmaSliderButton *but1 = (SmaSliderButton *)[_witchView viewWithTag:1100+switchIndex];
    _sliderBut.enabled = YES;
    [_sliderBut setTitle:SMALocalizedString(@"setting_complete") forState:UIControlStateNormal];
    uploadSwitch = YES;
    [but1 setTitle:@"" forState:UIControlStateNormal];
    [_timer invalidate];
    _timer = nil;
    
}

- (void)connectWatchFailure{
    SmaSliderButton *but1 = (SmaSliderButton *)[_witchView viewWithTag:1100+switchIndex];
    uploadSwitch = YES;
    [self setSwitchFail];
    [but1 setTitle:@"" forState:UIControlStateNormal];
    _sliderBut.enabled = YES;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
