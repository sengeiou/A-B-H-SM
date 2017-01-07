//
//  SMAWatchView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/7.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAWatchView.h"

@implementation SMAWatchView
{
    tapBlock butBlock;
    UIView *backView;
    UIView *bottomView;
    UIView *watchDetailView;
    NSInteger switchIndex;
    NSInteger newSwitchIndex;
    SmaSliderButton *_sliderBut;
    NSTimer *_timer;
    BOOL uploadSwitch;
    NSMutableArray *switchArr;
    NSDictionary *filDic;
    UIImage *selectimage;
}
- (instancetype)initWithWatchInfos:(NSDictionary *)dicInof watchImage:(UIImage *)image{
    self = [[SMAWatchView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    SmaBleMgr.BLdelegate = self;
    [self createUIwtihInfos:dicInof watchImage:image];
    return self;
}

- (void)setOlSwitchArr:(NSMutableArray *)olSwitchArr{
    _olSwitchArr = olSwitchArr;
    if (olSwitchArr.count == 0) {
        [SmaBleSend getSwitchNumber];
    }
}

- (void)createUIwtihInfos:(NSDictionary *)dicInof watchImage:(UIImage *)image{
    //求得所选表盘序号，以便于判断手表中是否已经存在该表盘
    NSArray *ARR = [[dicInof objectForKey:@"filename"] componentsSeparatedByString:@"."];
    NSArray *arr = [[ARR firstObject] componentsSeparatedByString:@"_"];
    newSwitchIndex = [[arr lastObject] integerValue];
    filDic = dicInof;
    selectimage = image;
    backView = [[UIView alloc] initWithFrame:CGRectMake(28.5, MainScreen.size.height/2 - 110, MainScreen.size.width - 57, 240)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 6;
    [self addSubview:backView];
    
    watchDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 240 - 59)];
//    watchDetailView.backgroundColor = [UIColor redColor];
    [backView addSubview:watchDetailView];
    
    UIImageView *watchCase = [[UIImageView alloc] initWithFrame:CGRectMake(8, 10, 116, 160)];
    watchCase.image = [UIImage imageNamed:@"pic_biaopan"];
//    watchCase.backgroundColor = [UIColor greenColor];
    [watchDetailView addSubview:watchCase];
    
    UIImageView *watchIma = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    watchIma.image = image;
    watchIma.center = CGPointMake(CGRectGetWidth(watchCase.frame)/2, CGRectGetHeight(watchCase.frame)/2);
//    watchIma.backgroundColor = [UIColor blueColor];
    [watchCase addSubview:watchIma];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(watchCase.frame) + 5, 10, CGRectGetWidth(backView.frame) - CGRectGetMaxX(watchCase.frame), 45)];
    titleLab.numberOfLines = 2;
    titleLab.font = FontGothamLight(16);
    titleLab.text = SMALocalizedString(@"setting_watchface_info");
    [watchDetailView addSubview:titleLab];
    
    UILabel *namelab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(titleLab.frame) + 3, CGRectGetWidth(backView.frame) - CGRectGetMaxX(watchCase.frame), 20)];
    namelab.font = FontGothamLight(14);
    namelab.numberOfLines = 2;
    namelab.text = SMALocalizedString(@"setting_watchface_name");
    namelab.textColor = [SmaColor colorWithHexString:@"#999999" alpha:1];
    [watchDetailView addSubview:namelab];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(namelab.frame) + 3, CGRectGetWidth(backView.frame) - CGRectGetMaxX(watchCase.frame), 31)];
    nameLab.font = FontGothamLight(15);
    nameLab.numberOfLines = 2;
    nameLab.text = dicInof[@"extendAttrs"][@"objectData"][@"name"];
    [watchDetailView addSubview:nameLab];
    
    UILabel *authorlab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(nameLab.frame) + 8, CGRectGetWidth(backView.frame) - CGRectGetMaxX(watchCase.frame), 20)];
    authorlab.font = FontGothamLight(14);
    authorlab.text = SMALocalizedString(@"setting_watchface_author");
    authorlab.numberOfLines = 2;
    authorlab.textColor = [SmaColor colorWithHexString:@"#999999" alpha:1];
    [watchDetailView addSubview:authorlab];
    
    UILabel *authorLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLab.frame), CGRectGetMaxY(authorlab.frame) + 3, CGRectGetWidth(backView.frame) - CGRectGetMaxX(watchCase.frame), 31)];
    authorLab.font = FontGothamLight(15);
    authorLab.numberOfLines = 2;
    authorLab.text = dicInof[@"extendAttrs"][@"objectData"][@"author"];
    [watchDetailView addSubview:authorLab];
    
    NSArray *buttons = @[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"setting_watchfact_sync")];
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(watchCase.frame) + 8, CGRectGetWidth(backView.frame), 59)];
//    bottomView.backgroundColor = [UIColor redColor];
    [backView addSubview:bottomView];
    for (int i = 0; i < 2; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(14.5 + ((CGRectGetWidth(backView.frame) - 54)/2 + 25) * i, 10, (CGRectGetWidth(backView.frame) - 54)/2, 40);
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 4;
        but.backgroundColor = [SmaColor colorWithHexString:@"#5791f9" alpha:1];
        but.titleLabel.font = FontGothamLight(17);
        but.titleLabel.numberOfLines = -1;
        but.tag = 1001 + i;
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGSize fontSize = [buttons[0] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        CGSize fontSize1 = [buttons[1] sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(17)}];
        if (fontSize.width >= (CGRectGetWidth(backView.frame) - 54)/2 - 3 || fontSize1.width >= (CGRectGetWidth(backView.frame) - 54)/2 - 3) {
            but.titleLabel.font = FontGothamLight(15);
        }
        if (i == 0) {
            but.backgroundColor = [SmaColor colorWithHexString:@"#999999" alpha:1];
        }
        but.tag = 1001 +i;
        [but setTitle:buttons[i] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(tapButCount:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:but];
    }
    
}

- (void)didButSelect:(tapBlock)callBack{
    butBlock = callBack;
}

- (void)tapButCount:(UIButton *)sender{
    if (sender.tag == 1001) {
        [self removeFromSuperview];
    }
    else{
        if (sender.selected) {
            [self setSwitchBinData];
            if ([SmaBleMgr checkBLConnectState]) {
                [SmaBleSend enterXmodem];
            }
            else{
                return;
            }
            for (UIButton *but in backView.subviews) {
                if (but.tag > 1100) {
                    but.enabled = NO;
                }
            }

            _sliderBut = [SmaSliderButton buttonWithType:UIButtonTypeCustom];
            _sliderBut.enabled = NO;
            UIButton *but0 = (UIButton *)[bottomView viewWithTag:1001];
            UIButton *but1 = (UIButton *)[bottomView viewWithTag:1002];
            SmaSliderButton *selBut = (SmaSliderButton *)[backView viewWithTag:1100+switchIndex];
            _sliderBut.frame = CGRectMake(0,0, CGRectGetMaxX(but1.frame)-CGRectGetMinX(but0.frame), but0.frame.size.height);
            _sliderBut.center = CGPointMake(bottomView.frame.size.width/2,bottomView.frame.size.height/2);
            [_sliderBut addTarget:self action:@selector(setSwitchFinish:) forControlEvents:UIControlEventTouchUpInside];
            [_sliderBut setTitle:SMALocalizedString(@"setting_watchface_loading") forState:UIControlStateNormal];
            [_sliderBut reloadView];
            [bottomView addSubview:_sliderBut];
            [selBut reloadArcView];
            [selBut setBackgroundImage:selectimage forState:UIControlStateNormal];
            [selBut setBackgroundImage:selectimage forState:UIControlStateHighlighted];
            [selBut setBackgroundImage:selectimage forState:UIControlStateDisabled];
            but1.hidden = YES;
            but0.hidden = YES;

            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
//            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setSwitchProgress:) userInfo:nil repeats:YES];

        }
        else{
            sender.selected = YES;
            sender.enabled = NO;
            sender.backgroundColor = [UIColor grayColor];
            [self showSelectWitchs];
        }
    }
//    butBlock(sender);
//    [self removeFromSuperview];
}

- (void)showSelectWitchs{
    UILabel *selectLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, backView.frame.size.width - 20, 42)];
    watchDetailView.hidden = YES;
    selectLab.text = SMALocalizedString(@"setting_watchface_select");
    selectLab.textAlignment = NSTextAlignmentCenter;
    selectLab.numberOfLines = 2;
    [backView addSubview:selectLab];
    for (int i = 0; i < 3; i++) {     //手表上已经存在的三个表盘
        SmaSliderButton *witchBut = [SmaSliderButton buttonWithType:UIButtonTypeCustom];
        witchBut.frame = CGRectMake(10+(i*((backView.frame.size.width-50)/3+15)),(backView.frame.size.height - (backView.frame.size.width-60)/3 - 29)/2 + 13, (backView.frame.size.width-50)/3, (backView.frame.size.width-50)/3);
        [witchBut setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateNormal];
        [witchBut setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateHighlighted];
        [witchBut setBackgroundImage:[UIImage imageNamed:@"img_moren"] forState:UIControlStateDisabled];
        if ([_olSwitchArr[i] integerValue] == newSwitchIndex) {
            switchIndex = i + 1;
        }
        if (_olSwitchArr.count > 2) {
            [witchBut setImageWithOffset:[_olSwitchArr[i] intValue]];
        }
        witchBut.backgroundColor = [UIColor greenColor];
        witchBut.tag = 1101 + i;
        [witchBut addTarget:self action:@selector(selectWitch:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:witchBut];
    }
    if (switchIndex>0) {
        [self selectOnlySwitch];
    }
}

- (void)selectOnlySwitch{
    for (UIButton *but in backView.subviews) {
        if (but.tag > 1100) {
            but.layer.borderWidth = 3.0f;
            but.layer.masksToBounds = YES;
            but.layer.borderColor = [UIColor clearColor].CGColor;
            but.enabled = NO;
        }
    }
    UIButton *but1 = (UIButton *)[backView viewWithTag:1100+switchIndex];
//    SmaBleMgr.switchNumber = (int)switchIndex;
    but1.layer.borderWidth = 3.0f;
    but1.layer.masksToBounds = YES;
    but1.layer.borderColor = [UIColor redColor].CGColor;
    UIButton *but = (UIButton *)[bottomView viewWithTag:1002];
    but.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1];
    but.enabled = YES;
}

- (void)selectWitch:(UIButton *)sender{
    for (UIButton *but in backView.subviews) {
        if (but.tag > 1100) {
            but.layer.borderWidth = 3.0f;
            but.layer.masksToBounds = YES;
            but.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    
    switchIndex = sender.tag - 1100;
//  SmaBleMgr.switchNumber = (int)switchIndex;
    sender.layer.borderWidth = 3.0f;
    sender.layer.masksToBounds = YES;
    sender.layer.borderColor = [UIColor blackColor].CGColor;
    UIButton *but = (UIButton *)[bottomView viewWithTag:1002];
    but.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1];
    but.enabled = YES;
}

- (void)setSwitchBinData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filDic[@"filename"]]];
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    if (!data) {
        SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
        web.chaImageName = filDic[@"filename"];
        [web acloudDownFileWithsession:[filDic objectForKey:@"downloadUrl"] callBack:^(float progress, NSError *error) {
            if (error) {
              [self setSwitchFail];
            }
        } CompleteCallback:^(NSString *filePath) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                if (filePath) {
                    [SmaBleSend analySwitchsWithdata:data replace:(int)switchIndex];
                }
                else{
                    [self setSwitchFail];
                }
            });
        }];
    }
    else{
        [SmaBleSend analySwitchsWithdata:data replace:(int)switchIndex];
    }
}

static float i = 0.0;
- (void)setSwitchProgress:(float) progress{
    i = i +0.1;
    SmaSliderButton *but1 = (SmaSliderButton *)[backView viewWithTag:1100+switchIndex];
    [but1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but1 setArcProgress:progress];
    _sliderBut.progress = progress;
        if (progress >= 1) {
            [_sliderBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
            [but1 setTitle:@"" forState:UIControlStateNormal];
            _sliderBut.enabled = YES;
            i = 0;
            [_timer invalidate];
            _timer = nil;
        }
}

- (void)setSwitchFinish:(UIButton *)sender{
    if (uploadSwitch) {
        butBlock(_olSwitchArr);
        [self removeFromSuperview];
    }
    else{
        [_sliderBut removeFromSuperview];
        for (UIButton *but in bottomView.subviews) {
            if (but.tag > 1000 && but.tag < 1100) {
                but.enabled = YES;
                but.hidden = NO;
            }
            int i = 0;
            for (SmaSliderButton *but in backView.subviews) {
                if (but.tag > 1100) {
                    if ([_olSwitchArr[i] integerValue] == newSwitchIndex) {
                        switchIndex = i + 1;
                    }
                    if (_olSwitchArr.count > 2) {
                        [but setImageWithOffset:[_olSwitchArr[i] intValue]];
                    }
                    i++;
                    but.enabled = YES;
                }
            }
            if (switchIndex>0) {
                [self selectOnlySwitch];
            }
        }
    }
}

- (void)setSwitchFail{
    SmaSliderButton *but1 = (SmaSliderButton *)[backView viewWithTag:1100+switchIndex];
    uploadSwitch = NO;
    [but1 setTitle:@"" forState:UIControlStateNormal];
    _sliderBut.enabled = YES;
    [_sliderBut setTitle:SMALocalizedString(@"device_syncFail") forState:UIControlStateNormal];
    [_sliderBut setFilClolr:[UIColor colorWithRed:255/255.0 green:67/255.0 blue:107/255.0 alpha:1]];
}

- (void)bledidDisposeMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)data{
    if (mode == WATCHFACE) {
        _olSwitchArr = data;
    }
}

- (void)bleDisconnected:(NSString *)error{
        [self setSwitchFail];
    SmaBleSend.isUPDateSwitch = NO;
//    [MBProgressHUD showError:SMALocalizedString(@"device_syncFail")];
}

#pragma mark ***********SmaCoreBlueToolDelegate
- (void)bleUpdateProgress:(float)pregress{
    [self setSwitchProgress:pregress];

}

- (void)bleUpdateProgressEnd:(BOOL)success{
    if (success) {
        [_olSwitchArr replaceObjectAtIndex:switchIndex-1 withObject:[NSString stringWithFormat:@"%ld",(long)newSwitchIndex]];
        SmaSliderButton *but1 = (SmaSliderButton *)[backView viewWithTag:1100+switchIndex];
        _sliderBut.enabled = YES;
        [_sliderBut setTitle:SMALocalizedString(@"setting_sedentary_achieve") forState:UIControlStateNormal];
        uploadSwitch = YES;
        [but1 setTitle:@"" forState:UIControlStateNormal];
//        [self setSwitchFail];
    }
    else{
         [self setSwitchFail];
    }
}
@end
