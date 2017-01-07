//
//  SMAShareView.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/28.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAShareView.h"

@implementation SMAShareView
{
    UIView *backView;
    UIImage *shareIma;
}

- (instancetype)initWithButtonTitles:(NSArray *)buttons butImage:(NSArray *)uiimages shareImage:(UIImage *)image{
    self = [[SMAShareView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height)];
    shareIma = image;
    [self createUIWithButtonTitles:buttons images:uiimages];
    return self;
}

- (void)createUIWithButtonTitles:(NSArray *)buttons images:(NSArray *)image{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tapGR];
    self.backgroundColor = [SmaColor colorWithHexString:@"#000000" alpha:0.5];
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreen.size.height, MainScreen.size.width, 60 + MainScreen.size.width/buttons.count)];
    backView.backgroundColor = [SmaColor colorWithHexString:@"#ffffff" alpha:1];
    UIButton *canBut = [UIButton buttonWithType:UIButtonTypeCustom];
    canBut.frame = CGRectMake(MainScreen.size.width - 80, 8, 60, 36);
    [canBut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [canBut addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    canBut.titleLabel.font = FontGothamLight(17);
    canBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [canBut setTitle:SMALocalizedString(@"setting_sedentary_cancel") forState:UIControlStateNormal];
    [backView addSubview:canBut];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, MainScreen.size.width - 160, 36)];
    titLab.text = SMALocalizedString(@"device_share_shareTo");
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = FontGothamLight(17);
    titLab.textColor = [UIColor darkGrayColor];
    titLab.numberOfLines = 2;
    [backView addSubview:titLab];
    [self addSubview:backView];
    
    for (int j = 0; j < buttons.count; j ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.titleLabel.font = FontGothamLight(12);
        but.tag = 101 +j;
        but.titleLabel.numberOfLines = 2;
        [but setImage:image[j] forState:UIControlStateNormal];
        but.frame = CGRectMake(0 + MainScreen.size.width/buttons.count * j,44, MainScreen.size.width/buttons.count , MainScreen.size.width/buttons.count);
        but.layer.masksToBounds = YES;
        but.layer.cornerRadius = 6;
        [but addTarget:self action:@selector(tapButCount:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:but];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0 + MainScreen.size.width/buttons.count * j, CGRectGetMaxY(but.frame) - 6, MainScreen.size.width/buttons.count, CGRectGetHeight(backView.frame) - CGRectGetMaxY(but.frame))];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = FontGothamLight(12);
        lab.text = buttons[j];
        [backView addSubview:lab];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        backView.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(backView.frame));
    } completion:^(BOOL finished) {
        
    }];

}

- (void)tapButCount:(UIButton *)sender{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    BOOL domestic = NO;
    if ([preferredLang isEqualToString:@"zh"]) {
        domestic = YES;
    }
    switch (sender.tag) {
        case 101:
            if (domestic) {
                if ([[SMAthirdPartyLoginTool getinstance] isWXAppInstalled]) {
                    [[SMAthirdPartyLoginTool getinstance] shareToWeChatScene:0 shareImage:shareIma];
                }
                else{
                    [MBProgressHUD showError:SMALocalizedString(@"device_share_WXNOInsta")];
                }
            }
        {
            [[SMAthirdPartyLoginTool getinstance] shareToTwitterWithShareImage:shareIma controller:_shareVC];
        }
            break;
        case 102:
            if (domestic) {
                if ([[SMAthirdPartyLoginTool getinstance] isWXAppInstalled]) {
                    [[SMAthirdPartyLoginTool getinstance] shareToWeChatScene:1 shareImage:shareIma];
                }
                else{
                    [MBProgressHUD showError:SMALocalizedString(@"device_share_WXNOInsta")];
                }
            }
            else{
                [[SMAthirdPartyLoginTool getinstance] shareToInstagramWithShareImage:shareIma controller:_shareVC];
            }
            break;
        case 103:
            if (domestic) {
                if ([[SMAthirdPartyLoginTool getinstance] iphoneQQInstalled]) {
                    [[SMAthirdPartyLoginTool getinstance] shareToQQShareImage:shareIma];
                }
                else{
                    [MBProgressHUD showError:SMALocalizedString(@"device_share_QQNOInsta")];
                }
            }
            else{
                [[SMAthirdPartyLoginTool getinstance] shareToFacebookWithShareImage:shareIma controller:_shareVC];
            }
          
            break;
        case 104:
            if (domestic) {
                if ([[SMAthirdPartyLoginTool getinstance] iphoneQQInstalled]) {
                    [[SMAthirdPartyLoginTool getinstance] shareToQZoneShareImage:shareIma];
                }
                else{
                    [MBProgressHUD showError:SMALocalizedString(@"device_share_QQNOInsta")];
                }
            }
           
            break;
        case 105:
            if ([[SMAthirdPartyLoginTool getinstance] isWBAppInstalled]) {
                [[SMAthirdPartyLoginTool getinstance] shareToWBWithShareImage:shareIma];
            }
            else{
                [MBProgressHUD showError:SMALocalizedString(@"device_share_WBNOInsta")];
            }
            break;
        default:
            break;
    }
    [self tapAction];
}

- (void)tapAction{
    [UIView animateWithDuration:0.3 animations:^{
        backView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
