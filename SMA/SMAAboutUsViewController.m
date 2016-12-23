//
//  SMAAboutUsViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAAboutUsViewController.h"

@interface SMAAboutUsViewController ()
{
    UIScrollView *textScroll;
    NSString *smawatchUrl;
}
@end

@implementation SMAAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self createUI];
}

- (void)viewDidAppear:(BOOL)animated{
//     [_aboutUsView setContentOffset:CGPointMake(0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.title = SMALocalizedString(@"me_set_about");
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    smawatchUrl = @"http://weibo.com/u/5424997974/home?wvr=5&lf=reg";
    if (![preferredLang isEqualToString:@"zh"]){
        smawatchUrl = @"https://www.facebook.com/smawatch520";
    }

    
    NSMutableAttributedString *allAttrStr = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    NSDictionary *dictAttr = @{NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#2C1FFF" alpha:1],NSFontAttributeName:FontGothamLight(11)};
    
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content1") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *attrStr1 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content2") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *attrStr2 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content3") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *attrStr3 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content4") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *attrStr4 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content5") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSAttributedString *attrStr5 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content6") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSDictionary *dictAttr5_1 = @{NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#007aff" alpha:1],NSLinkAttributeName:[NSURL URLWithString:@"http://www.smawatch.com"],NSFontAttributeName:FontGothamLight(11)};
    NSAttributedString *attrStr5_1 = [[NSAttributedString alloc]initWithString:@"http://www.smawatch.com" attributes:dictAttr5_1];
    
    NSAttributedString *attrStr6 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content7") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSDictionary *dictAttr6_1 = @{NSForegroundColorAttributeName:[SmaColor colorWithHexString:@"#007aff" alpha:1],NSLinkAttributeName:[NSURL URLWithString:@"http://weibo.com/u/5424997974/home?wvr=5&lf=reg"],NSFontAttributeName:FontGothamLight(11)};
    NSAttributedString *attrStr6_1 = [[NSAttributedString alloc]initWithString:@"http://weibo.com/u/5424997974/home?wvr=5&lf=reg" attributes:dictAttr6_1];
    NSAttributedString *attrStr7 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content8") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *attrStr7_1 = [[NSAttributedString alloc]initWithString:@"sales@smawatch.com" attributes:dictAttr];
    
    NSAttributedString *attrStr7_2 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content8") attributes:@{NSForegroundColorAttributeName:[UIColor clearColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *attrStr7_3 = [[NSAttributedString alloc]initWithString:@"helen@smawatch.com" attributes:dictAttr];
    
    NSAttributedString *attrStr8 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content9") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *attrStr8_1 = [[NSAttributedString alloc]initWithString:@"0755-27915058" attributes:dictAttr];
    
    NSAttributedString *attrStr9 = [[NSAttributedString alloc]initWithString:SMALocalizedString(@"me_set_about_content10") attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    NSAttributedString *attrStr9_1 = [[NSAttributedString alloc]initWithString:@"1678017731" attributes:dictAttr];
    
    [allAttrStr appendAttributedString:attrStr];
    [allAttrStr appendAttributedString:attrStr1];
    [allAttrStr appendAttributedString:attrStr2];
    [allAttrStr appendAttributedString:attrStr3];
    [allAttrStr appendAttributedString:attrStr4];
    [allAttrStr appendAttributedString:attrStr5];
    [allAttrStr appendAttributedString:attrStr5_1];
    [allAttrStr appendAttributedString:attrStr6];
    [allAttrStr appendAttributedString:attrStr6_1];
    [allAttrStr appendAttributedString:attrStr7];
    [allAttrStr appendAttributedString:attrStr7_1];
    [allAttrStr appendAttributedString:attrStr7_2];
    [allAttrStr appendAttributedString:attrStr7_3];
    [allAttrStr appendAttributedString:attrStr8];
    [allAttrStr appendAttributedString:attrStr8_1];
    [allAttrStr appendAttributedString:attrStr9];
    [allAttrStr appendAttributedString:attrStr9_1];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = [UIImage imageNamed:@"img_dingyuehao"]; //要添加的图片
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
 /**************************
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    UIImage *image = [UIImage imageNamed:@"img_guanyu"];
    if (![preferredLang isEqualToString:@"zh"]){
        image = [UIImage imageNamed:@"img_guanyu"];
    }
    UIImageView *aboutView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, image.size.height)];
    aboutView.image = image;
    
    textScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64)];
    textScroll.showsVerticalScrollIndicator = NO;
    [textScroll addSubview:aboutView];
    [self.view addSubview:textScroll];
    
    textScroll.contentSize = CGSizeMake( MainScreen.size.width,image.size.height);
  **************************/
    
    textScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height - 64)];
    textScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:textScroll];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 40)];
    titleLab.backgroundColor = [SmaColor colorWithHexString:@"#F7F7F7" alpha:1];
    titleLab.textColor = [SmaColor colorWithHexString:@"#007aff" alpha:1];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"SMAWATCH";
    [textScroll addSubview:titleLab];
    
    CGRect rect1 = [self getSize:attrStr.string strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect2 = [self getSize:attrStr1.string strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect3 = [self getSize:attrStr2.string strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect4 = [self getSize:attrStr3.string strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect5 = [self getSize:attrStr4.string strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect6 = [self getSize:[NSString stringWithFormat:@"%@%@",attrStr5.string,@"http://www.smawatch.com"] strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect7 = [self getSize:[NSString stringWithFormat:@"%@%@",attrStr6.string,smawatchUrl] strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect8 = [self getSize:[NSString stringWithFormat:@"%@%@",attrStr7.string,@"sales@smawatch.com"] strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect9 = [self getSize:[NSString stringWithFormat:@"%@%@",attrStr7.string,@"helen@smawatch.com"] strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect10 = [self getSize:[NSString stringWithFormat:@"%@%@",attrStr8.string,@"0755-27915058"] strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect11 = [self getSize:[NSString stringWithFormat:@"%@%@",attrStr9.string,@"1678017731"] strDic:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:FontGothamLight(13),NSParagraphStyleAttributeName:paragraphStyle}];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLab.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect1))];
    lab1.attributedText = attrStr;
    lab1.numberOfLines = 0;

    [textScroll addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab1.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect2))];
    lab2.attributedText = attrStr1;
    lab2.numberOfLines = 0;
    [textScroll addSubview:lab2];
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab2.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect3))];
    lab3.attributedText = attrStr2;
    lab3.numberOfLines = 0;
    [textScroll addSubview:lab3];
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab3.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect4))];
    lab4.attributedText = attrStr3;
    lab4.numberOfLines = 0;
    [textScroll addSubview:lab4];
    
    UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab4.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect5))];
    lab5.attributedText = attrStr4;
    lab5.numberOfLines = 0;
    [textScroll addSubview:lab5];
    
    UILabel *lab6 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab5.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect6))];
    NSMutableAttributedString *att = [attrStr5 mutableCopy];
    [att appendAttributedString:attrStr5_1];
    lab6.attributedText = att;
    lab6.tag = 101;
    lab6.numberOfLines = 0;
    lab6.userInteractionEnabled = YES;
    [textScroll addSubview:lab6];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tpaLink:)];
    [lab6 addGestureRecognizer:tap];
    
    UILabel *lab7 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab6.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect7))];
    NSMutableAttributedString *att1 = [attrStr6 mutableCopy];
    [att1 appendAttributedString:attrStr6_1];
    lab7.attributedText = att1;
    lab7.tag = 102;
    lab7.numberOfLines = 0;
    lab7.userInteractionEnabled = YES;
    [textScroll addSubview:lab7];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tpaLink:)];
    [lab7 addGestureRecognizer:tap1];

    UILabel *lab8 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab7.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect8))];
    att1 = [attrStr7 mutableCopy];
    [att1 appendAttributedString:attrStr7_1];
    lab8.attributedText = att1;
    lab8.numberOfLines = 0;
    [textScroll addSubview:lab8];
    
    UILabel *lab9 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab8.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect9))];
    att1 = [attrStr7_2 mutableCopy];
    [att1 appendAttributedString:attrStr7_3];
    lab9.attributedText = att1;
    lab9.numberOfLines = 0;
    [textScroll addSubview:lab9];
    
    UILabel *lab10 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab9.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect10))];
    att1 = [attrStr8 mutableCopy];
    [att1 appendAttributedString:attrStr8_1];
    lab10.attributedText = att1;
    lab10.numberOfLines = 0;
    [textScroll addSubview:lab10];
    
    UILabel *lab11 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lab10.frame) + 6, MainScreen.size.width - 20, CGRectGetHeight(rect11))];
    att1 = [attrStr9 mutableCopy];
    [att1 appendAttributedString:attrStr9_1];
    lab11.attributedText = att1;
    lab11.numberOfLines = 0;
    [textScroll addSubview:lab11];

    UIView *publicView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lab11.frame) + 8, 131, 165)];
    UILabel *publicLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 131, 34)];
    publicLab.textAlignment = NSTextAlignmentCenter;
    publicLab.font = FontGothamLight(16);
    publicLab.numberOfLines = 2;
    publicLab.textColor = [UIColor grayColor];
    publicLab.text = SMALocalizedString(@"me_set_about_public");
    [publicView addSubview:publicLab];
    UIImageView *publicIma = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(publicLab.frame), 130, 131)];
    publicIma.image = [UIImage imageNamed:@"img_dingyuehao"];
    [publicView addSubview:publicIma];
    [textScroll addSubview:publicView];
    
    UIView *serviceView = [[UIView alloc] initWithFrame:CGRectMake(MainScreen.size.width - 146, CGRectGetMaxY(lab11.frame) + 8, 131, 155)];
    UILabel *serviceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 131, 34)];
    serviceLab.textAlignment = NSTextAlignmentCenter;
    serviceLab.numberOfLines = 2;
    serviceLab.font = FontGothamLight(16);
    serviceLab.textColor = [UIColor grayColor];
    serviceLab.text = SMALocalizedString(@"me_set_about_service");
    [serviceView addSubview:serviceLab];
    UIImageView *serviceIma = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(publicLab.frame), 130, 131)];
    serviceIma.image = [UIImage imageNamed:@"img_fuwuhao"];
    [serviceView addSubview:serviceIma];
    [textScroll addSubview:serviceView];
    textScroll.contentSize = CGSizeMake( MainScreen.size.width,CGRectGetMaxY(serviceView.frame) + 5);
}

- (CGRect)getSize:(NSString *)str strDic:(NSDictionary *)dic{
    CGRect labelSize = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return labelSize;
}

- (void)tpaLink:(UITapGestureRecognizer *)tap{
    NSString *url;
    switch (tap.view.tag) {
        case 101:
            url = @"http://www.smawatch.com";
            break;
        default:
            url = smawatchUrl;
            break;
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    //在这里是可以做一些判定什么的，用来确定对应的操作。
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
