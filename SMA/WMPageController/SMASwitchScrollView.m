//
//  SMASwitchScrollView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/9.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASwitchScrollView.h"

@implementation SMASwitchScrollView
{
    NSArray *titleArr;
    NSArray *imageArr;
    endDeceBlock drceleraBlock;
}
- (instancetype)initWithSwitchs:(NSArray *)switchs{
    self = [[SMASwitchScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 192)];
    self.backgroundColor = [SmaColor colorWithHexString:@"#ECECEC" alpha:1];
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    [self createUIWithSwitchs:switchs];
    return self;
}

- (void)createUIWithSwitchs:(NSArray *)switchs{
    int remainder = (int)[[switchs firstObject] count]%4;
    int divisor = (int)[[switchs firstObject] count]/4;
   titleArr = @[SMALocalizedString(@"setting_antiLost"),SMALocalizedString(@"setting_noDistrub"),SMALocalizedString(@"setting_callNot"),SMALocalizedString(@"setting_smsNot"),SMALocalizedString(@"setting_screen")];
    imageArr = switchs;
    NSArray *stateArr = @[[NSNumber numberWithInt:[SMADefaultinfos getIntValueforKey:ANTILOSTSET]],[NSNumber numberWithInt:[SMADefaultinfos getIntValueforKey:NODISTRUBSET]],[NSNumber numberWithInt:[SMADefaultinfos getIntValueforKey:CALLSET]],[NSNumber numberWithInt:[SMADefaultinfos getIntValueforKey:SMSSET]],[NSNumber numberWithInt:![SMADefaultinfos getIntValueforKey:SCREENSET]]];
    for (int i = 0; i < [[switchs firstObject] count]; i ++) {
        UIView *butView = [[UIView alloc] init];
        butView.backgroundColor = [UIColor whiteColor];
        butView.tag = 101 + i;
        int odd = i%2;
        int odd1 = i/4;
        int odd2 = (i/2)%2; //计算所在第一列还是第二列
        CGFloat originX = 0 + ((MainScreen.size.width - 1)/2 + 1) * odd + MainScreen.size.width * odd1;
        CGFloat originY = 0 + ((self.frame.size.height - 1)/2 + 1) * odd2;
        butView.frame = CGRectMake(originX, originY, (MainScreen.size.width - 1)/2, (self.frame.size.height - 1)/2);
        [self addSubButSubview:butView switchs:[stateArr[i] intValue] ? [switchs firstObject][i]:[switchs lastObject][i] title:titleArr[i]state:[stateArr[i] intValue]];
        [self addSubview:butView];
    }
    int page = remainder ? (divisor + 1):divisor;
    self.contentSize = CGSizeMake(MainScreen.size.width * page, self.frame.size.height);
}

- (void)addSubButSubview:(UIView *)view switchs:(NSString *)name title:(NSString *)title state:(int)state{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = view.bounds;
    but.tag = view.tag * 10;
    but.selected = state;
    [but addTarget:self action:@selector(butSelector:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 40, 40)];
    backImage.image = [UIImage imageNamed:name];
    backImage.center = CGPointMake(view.frame.size.width/2, backImage.center.y);
    [view addSubview:backImage];
    
    UILabel *titlab = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(backImage.frame) + 8, view.frame.size.width - 16, view.frame.size.height - 64)];
    titlab.textAlignment = NSTextAlignmentCenter;
    titlab.font = FontGothamLight(12);
    titlab.text = title;
    titlab.numberOfLines = 2;
    [view addSubview:titlab];
}

- (void)createView:(NSInteger)tag selected:(BOOL)select{
        UIView *view = [self viewWithTag:tag/10];
    for (UIImageView *subView in view.subviews) {
        NSInteger selIndex = tag/10 - 101;
        if ([[subView class] isSubclassOfClass:[UIImageView class]]) {
            subView.image = [UIImage imageNamed:select ? [imageArr firstObject][selIndex]:[imageArr lastObject][selIndex]];
        }
    }
}

- (void)butSelector:(UIButton *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        sender.selected = !sender.selected;
        switch (sender.tag) {
            case 1010:
                [SMADefaultinfos putInt:ANTILOSTSET andValue:sender.selected];
                [SmaBleSend setDefendLose:[SMADefaultinfos getIntValueforKey:ANTILOSTSET]];
                break;
            case 1020:
            {
                [SMADefaultinfos putInt:NODISTRUBSET andValue:sender.selected];
                SmaNoDisInfo *disInfo = [[SmaNoDisInfo alloc] init];
                disInfo.isOpen = [NSString stringWithFormat:@"%d",[[SMADefaultinfos getValueforKey:NODISTRUBSET] intValue]];
                disInfo.beginTime1 = @"0";
                disInfo.endTime1 = @"1439";
                disInfo.isOpen1 = @"1";
                [SmaBleSend setNoDisInfo:disInfo];
            }
                break;
            case 1030:
                [SMADefaultinfos putInt:CALLSET andValue:sender.selected];
                [SmaBleSend setphonespark:[SMADefaultinfos getIntValueforKey:CALLSET]];
                break;
            case 1040:
                [SMADefaultinfos putInt:SMSSET andValue:sender.selected];
                [SmaBleSend setSmspark:[SMADefaultinfos getIntValueforKey:SMSSET]];
                break;
            case 1050:
                [SMADefaultinfos putInt:SCREENSET andValue:!sender.selected];
                [SmaBleSend setVertical:[SMADefaultinfos getIntValueforKey:SCREENSET]];
                break;
                
            default:
                break;
        }
            [self createView:sender.tag selected:sender.selected];
    }

}

- (void)didEndDecelerating:(endDeceBlock)callBack{
    drceleraBlock = callBack;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    drceleraBlock(scrollView.contentOffset);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
