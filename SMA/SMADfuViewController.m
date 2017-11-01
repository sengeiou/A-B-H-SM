//
//  SMADfuViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMADfuViewController.h"

@interface SMADfuViewController ()
{
    SMAUserInfo *user;
    UIView *coverView;
    BOOL tateStarting;
    NSTimer *updateTimer;
    NSString *newVer;
    int tautology; //重试次数
}
@end

@implementation SMADfuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SmaBleMgr.dfuUpdate = YES;
    SmaDfuManager.dfuDelegate = self;
    [self createUI];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    SmaBleMgr.dfuUpdate = NO;
    SmaBleMgr.repairDfu = NO;
    SmaBleMgr.BLdelegate = nil;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"DFUUPDATEFINISH" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

- (void)createUI{
    [SMADefaultinfos putKey:DFUUPDATE andValue:@"1"];
    SmaBleMgr.BLdelegate = self;
    user = [SMAAccountTool userInfo];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.borderWidth = 0;
    _gradientLayer.frame = CGRectMake(0, 0, MainScreen.size.width, CGRectGetHeight(MainScreen)/2);
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:87/255.0 green:144/255.0 blue:249/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:128/255.0 green:193/255.0 blue:249/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    [_backView.layer insertSublayer:_gradientLayer atIndex:0];
    if (SmaBleMgr.repairDfu) {
        self.title = SMALocalizedString(@"me_dfuMessage");
        _dfuLab.textColor = [UIColor whiteColor];
        _dfuLab.font = FontGothamBold(30);
        _dfuLab.text = @"0%";
        [_remindLab setText:SMALocalizedString(@"me_repairMessage")];
        _nowVerTitLab.text = SMALocalizedString(@"me_dfuFilename");
        _nowVerLab.text = @"";
        _upDfuVerTitLab.text = SMALocalizedString(@"me_dfuFileSize");
        _upDfuVerLab.text = @"";
        _repairTextView.hidden = NO;
        _repairTextView.text = SMALocalizedString(@"me_repairPrompt");
        [self dfuSelector:nil];
    }
    else{
        self.title = SMALocalizedString(@"setting_unband_dfuUpdate");
        _dfuLab.font = FontGothamLight(17);
        _dfuLab.text = SMALocalizedString(@"setting_dfu_newest");
        [_remindLab setText:SMALocalizedString(@"setting_dfu_remind")];
        _nowVerTitLab.text = SMALocalizedString(@"setting_dfu_nowVer");
        _nowVerLab.text = [NSString stringWithFormat:@"V%@",user.watchVersion];
        _upVerView.hidden = YES;
        _dfuBut.enabled = NO;
        if (_dfuInfoDic) {
            _dfuBut.enabled = YES;
            _upVerView.hidden = NO;
            _dfuLab.text = SMALocalizedString(@"setting_dfu_update");
            NSString *filename = [_dfuInfoDic objectForKey:@"filename"];
            NSString *webFirmwareVer = [filename substringWithRange:NSMakeRange(filename.length - 9, 5)] ;
            _upDfuVerTitLab.text = SMALocalizedString(@"setting_dfu_newsetVer");
            _upDfuVerLab.text = [NSString stringWithFormat:@"V%@",webFirmwareVer];
            newVer = webFirmwareVer;
        }
        //        else{
        //             [SMADefaultinfos putInt:DFUUPDATE andValue:1];
        //        }
    }
}

- (void)viewDidLayoutSubviews{
    [_repairTextView setContentOffset:CGPointZero animated:NO];
}

- (IBAction)dfuSelector:(id)sender{
    if (!SmaBleMgr.repairDfu && _dfuInfoDic) {
        [SMADefaultinfos putKey:DFUUPDATE andValue:@"0"];
    }
    [SmaBleMgr reunitonPeripheral:YES];
    NSString *filename = [_dfuInfoDic objectForKey:@"filename"];
    NSString *webFirmwareVer = [[filename substringWithRange:NSMakeRange(filename.length - 9, 5)] stringByReplacingOccurrencesOfString:@"." withString:@""];
    if ([_dfuLab.text isEqualToString:SMALocalizedString(@"setting_dfu_retry")] || tautology <= 3) {
        [updateTimer invalidate];
        updateTimer = nil;
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateTimeOut) userInfo:nil repeats:NO];
        _dfuLab.textColor = [UIColor whiteColor];
        _dfuLab.font = FontGothamBold(30);
        _dfuLab.text = @"0%";
        [self setPregress:0];
        [coverView removeFromSuperview];
        coverView = [[UIView alloc] initWithFrame:MainScreen];
        coverView.backgroundColor = [UIColor clearColor];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:coverView];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_dfuInfoDic[@"filename"]]];
        NSData *data = [NSData dataWithContentsOfFile:uniquePath];
        if (!data) {
            if (SmaBleMgr.repairDfu) {
                [_remindLab setText:SMALocalizedString(@"me_repairMessage")];
                _nowVerLab.text = [[filename componentsSeparatedByString:@"_"] firstObject];
                [self chectFirmwareVewsionWithWeb];
                return;
            }
            SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
            web.chaImageName = _dfuInfoDic[@"filename"];
            [web acloudDownFileWithsession:[_dfuInfoDic objectForKey:@"downloadUrl"] callBack:^(float progress, NSError *error) {
                if (error) {
                    if (error.code == -1001) {
                        [MBProgressHUD showError:SMALocalizedString(@"login_timeout")];
                        NSLog(@"超时");
                    }
                    else if (error.code == -1009) {
                        [MBProgressHUD showError:SMALocalizedString(@"login_lostNet")];
                    }
                    
                    _dfuLab.textColor = [UIColor redColor];
                    _dfuLab.font = FontGothamLight(17);
                    _dfuLab.text = SMALocalizedString(@"setting_dfu_retry");
                    [coverView removeFromSuperview];
                }
            } CompleteCallback:^(NSString *filePath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (filePath) {
                        SmaDfuManager.fileUrl = [[NSURL alloc] initWithString:filePath];
                        if (SmaBleMgr.peripheral.state == CBPeripheralStateConnected) {
                            [SmaBleSend setOTAstate];
                        }
                        else{
                            SmaDfuManager.dfuMode = YES;
                            NSLog(@"fwegwghh===");
                        }
                    }
                    else{
                        _dfuLab.textColor = [UIColor redColor];
                        _dfuLab.font = FontGothamLight(17);
                        _dfuLab.text = SMALocalizedString(@"setting_dfu_retry");
                        [coverView removeFromSuperview];
                    }
                });
            }];
        }
        else{
            
            SmaDfuManager.fileUrl = [[NSURL alloc] initWithString:uniquePath];
            if (SmaBleMgr.repairDfu) {
                [_remindLab setText:SMALocalizedString(@"me_repairMessage")];
                _nowVerLab.text = [[filename componentsSeparatedByString:@"_"] firstObject];
                _upDfuVerLab.text = [NSString stringWithFormat:@"%.0fKB",data.length/1024.0];
                [self repairDeviceDfuWith:self.epairPeripheral];
                return;
            }
            if (SmaBleMgr.peripheral.state == CBPeripheralStateConnected) {
                [SmaBleSend setOTAstate];
            }
            else{
                SmaDfuManager.dfuMode = YES;
                NSLog(@"fwegwghh33333===");
            }
        }
        return;
    }
    if (((SmaBleMgr.repairDfu ? NO : [SmaBleMgr checkBLConnectState]) && _dfuInfoDic && [user.watchVersion stringByReplacingOccurrencesOfString:@"." withString:@""].intValue < webFirmwareVer.intValue) || SmaBleMgr.repairDfu) {
        [SmaBleMgr reunitonPeripheral:YES];
        [updateTimer invalidate];
        [coverView removeFromSuperview];
        updateTimer = nil;
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateTimeOut) userInfo:nil repeats:NO];
        coverView = [[UIView alloc] initWithFrame:MainScreen];
        coverView.backgroundColor = [UIColor clearColor];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:coverView];
        _dfuLab.textColor = [UIColor whiteColor];
        _dfuLab.font = FontGothamBold(30);
        _dfuLab.text = @"0%";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_dfuInfoDic[@"filename"]]];
        NSData *data = [NSData dataWithContentsOfFile:uniquePath];
        if (!data) {
            if (SmaBleMgr.repairDfu) {
                [_remindLab setText:SMALocalizedString(@"me_repairMessage")];
                _nowVerLab.text = [[filename componentsSeparatedByString:@"_"] firstObject];
                [self chectFirmwareVewsionWithWeb];
                return;
            }
            SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
            web.chaImageName = _dfuInfoDic[@"filename"];
            [web acloudDownFileWithsession:[_dfuInfoDic objectForKey:@"downloadUrl"] callBack:^(float progress, NSError *error) {
                if (error) {
                    if (error.code == -1001) {
                        [MBProgressHUD showError:SMALocalizedString(@"login_timeout")];
                        NSLog(@"超时");
                    }
                    else if (error.code == -1009) {
                        [MBProgressHUD showError:SMALocalizedString(@"login_lostNet")];
                    }
                    _dfuLab.textColor = [UIColor redColor];
                    _dfuLab.font = FontGothamLight(17);
                    _dfuLab.text = SMALocalizedString(@"setting_dfu_retry");
                    [coverView removeFromSuperview];
                    [SmaBleMgr reunitonPeripheral:YES];
                }
            } CompleteCallback:^(NSString *filePath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (filePath) {
                        SmaDfuManager.fileUrl = [[NSURL alloc] initWithString:filePath];
                        [SmaBleSend setOTAstate];
                    }
                    else{
                        _dfuLab.textColor = [UIColor redColor];
                        _dfuLab.font = FontGothamLight(17);
                        _dfuLab.text = SMALocalizedString(@"setting_dfu_retry");
                        [coverView removeFromSuperview];
                        [SmaBleMgr reunitonPeripheral:YES];
                    }
                });
            }];
        }
        else{
            SmaDfuManager.fileUrl = [[NSURL alloc] initWithString:uniquePath];
            if (SmaBleMgr.repairDfu) {
                [_remindLab setText:SMALocalizedString(@"me_repairMessage")];
                _nowVerLab.text = [[filename componentsSeparatedByString:@"_"] firstObject];
                _upDfuVerLab.text = [NSString stringWithFormat:@"%.0fKB",data.length/1024.0];
                [self repairDeviceDfuWith:self.epairPeripheral];
                return;
            }
            [SmaBleSend setOTAstate];
        }
    }
}

- (void)updateTimeOut{
    [updateTimer invalidate];
    updateTimer = nil;
    [SmaBleMgr reunitonPeripheral:YES];
    if (tautology >= 3) {
        _dfuLab.textColor = [UIColor redColor];
        _dfuLab.font = FontGothamLight(17);
        if (SmaBleMgr.repairDfu) {
            _dfuLab.text = SMALocalizedString(@"me_repairFail");
        }
        else{
            _dfuLab.text = SMALocalizedString(@"setting_dfu_retry");
        }
        [SmaBleMgr reunitonPeripheral:NO];
    }
    else{
        tautology ++;
        [self dfuSelector:nil];
    }
    [coverView removeFromSuperview];
}

- (void)setPregress:(float)pregress{
    _dfuView.progress = pregress;
}

- (void)repairDeviceDfuWith:(CBPeripheral *)periphral{
    SmaDfuManager.dfuDelegate = self;
    [SmaDfuManager performDFUwithManager:SmaBleMgr.mgr periphral:periphral];
}

- (void)chectFirmwareVewsionWithWeb{
    SmaAnalysisWebServiceTool *webSer = [[SmaAnalysisWebServiceTool alloc] init];
    [webSer acloudDfuFileWithFirmwareType:firmware_smav2 callBack:^(NSArray *finish, NSError *error) {
        BOOL haveFile = false;
        if (error) {
            if (error.code == -1001) {
                [MBProgressHUD showError:SMALocalizedString(@"login_timeout")];
                NSLog(@"超时");
            }
            else if (error.code == -1009) {
                [MBProgressHUD showError:SMALocalizedString(@"login_lostNet")];
            }
        }
        
        for (int i = 0; i < finish.count; i ++) {
            NSString *filename = [[finish objectAtIndex:i] objectForKey:@"filename"];
            //            NSString *filneNameNow = [NSString stringWithFormat:@"%@_%@",self.repairBleCustom,[[filename componentsSeparatedByString:@"_"] lastObject]];
            if ([filename hasPrefix:self.repairBleCustom]) {
                [self downDfuWithFile:(NSMutableDictionary *)[finish objectAtIndex:i]];
                haveFile = YES;
            }
        }
        if (!haveFile) {
            [self updateTimeOut];
        }
        
    }];
}

- (void)downDfuWithFile:(NSMutableDictionary *)fileDic{
    SmaAnalysisWebServiceTool *web = [[SmaAnalysisWebServiceTool alloc] init];
    web.chaImageName = fileDic[@"filename"];
    [web acloudDownFileWithsession:[fileDic objectForKey:@"downloadUrl"] callBack:^(float progress, NSError *error) {
        if (error) {
            [self updateTimeOut];
        }
    } CompleteCallback:^(NSString *filePath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (filePath) {
                _nowVerLab.text = [[fileDic[@"filename"] componentsSeparatedByString:@"_"] firstObject];
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                _upDfuVerLab.text = [NSString stringWithFormat:@"%.0fKB",data.length/1024.0];
                SmaDfuManager.fileUrl = [[NSURL alloc] initWithString:filePath];
                if (tautology > 0) {
                    [SmaBleMgr reunitonPeripheral:YES];
                    SmaDfuManager.dfuMode = YES;
                }
                [self repairDeviceDfuWith:self.epairPeripheral];
            }
            else{
                [self updateTimeOut];
            }
        });
    }];
}

#pragma mark *******BLConnectDelegate*****
- (void)bledidDisposeMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)data{
    NSLog(@"fwgwgg==%d  %@",mode,data);
    switch (mode) {
        case OTA:
            if ([data.firstObject intValue]) {
                SmaDfuManager.dfuDelegate = self;
                SmaDfuManager.dfuMode = YES;
                [updateTimer invalidate];
                updateTimer = nil;
            }
            else{
                [SmaBleMgr reunitonPeripheral:YES];
                if (tautology >= 3) {
                    _dfuLab.textColor = [UIColor redColor];
                    _dfuLab.font = FontGothamLight(17);
                    _dfuLab.text = SMALocalizedString(@"setting_dfu_retry");
                    [SmaBleMgr reunitonPeripheral:NO];
                }
                [coverView removeFromSuperview];
                if (tautology < 3){
                    tautology ++;
                    [self dfuSelector:nil];
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)blediDWriteValueForCharacteristicError:(NSError *)error{
    if (error) {
        _dfuLab.textColor = [UIColor redColor];
        _dfuLab.font = FontGothamLight(17);
        _dfuLab.text = SMALocalizedString(@"setting_dfu_retry");
        [coverView removeFromSuperview];
        [SmaBleMgr reunitonPeripheral:YES];
        [SMADefaultinfos putKey:DFUUPDATE andValue:@"0"];
    }
}

#pragma mark *******DfuUpdateDelegate*******
- (void)dfuUploadStateDidChangeTo:(DFUState)state{
    NSLog(@"dfuUploadStateDidChangeTo %ld",(long)state);
    switch (state) {
        case DFUStateStarting:
            if (SmaBleMgr.repairDfu) {
                [_remindLab setText:SMALocalizedString(@"me_repairDfuMessage")];
            }
            
            [updateTimer invalidate];
            updateTimer = nil;
            break;
        case DFUStateUploading:
            tateStarting = YES;
            [SmaBleMgr reunitonPeripheral:NO];
            NSLog(@"DFUStateUploading");
            break;
        case DFUStateCompleted:
        {
            NSLog(@"DFUStateCompleted");
            _dfuLab.font = FontGothamLight(17);
            _dfuLab.textColor = [UIColor whiteColor];
            _dfuLab.text = SMALocalizedString(@"setting_dfu_finish");
            [coverView removeFromSuperview];
            NSString *filename = [_dfuInfoDic objectForKey:@"filename"];
            NSString *webFirmwareVer = [filename substringWithRange:NSMakeRange(filename.length - 9, 5)] ;
            user.watchVersion = webFirmwareVer;
            [SMAAccountTool saveUser:user];
            _nowVerLab.text = [NSString stringWithFormat:@"V%@",user.watchVersion];
            _upVerView.hidden = YES;
            tateStarting = NO;
            [SmaBleMgr reunitonPeripheral:YES];
            if (SmaBleMgr.repairDfu) {
                [_remindLab setText:SMALocalizedString(@"me_repairFinish")];
                SmaBleMgr.repairDfu = NO;
                if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-Q2"]) {
                    SmaBleMgr.scanNameArr = @[@"NW1135",@"SMA-Q2",@"Noise Ignite"];
                }
                else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SM07"]){
                    SmaBleMgr.scanNameArr = @[@"SM07",@"MOSW007"];
                }
                else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A1"]){
                    SmaBleMgr.scanNameArr = @[@"SMA-A1",@"SMA-A2",@"Technos_SC"];
                }
                else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-A2"]){
                    SmaBleMgr.scanNameArr = @[@"SMA-A2"];
                }
                else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B2"]){
                    SmaBleMgr.scanNameArr = @[@"SMA-B2",@"B2"];
                }
                else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-B3"]){
                    SmaBleMgr.scanNameArr = @[@"SMA-B3",@"B3"];
                }
                else if ([[SMADefaultinfos getValueforKey:BANDDEVELIVE] isEqualToString:@"SMA-R1"]){
                    SmaBleMgr.scanNameArr = @[@"M1",@"Technos_SR",@"MOSRAA",@"SM09"];
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [coverView removeFromSuperview];
                [SMADefaultinfos putKey:DFUUPDATE andValue:@"1"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
            break;
        case DFUStateAborted:
            NSLog(@"DFUStateAborted");
            break;
        default:
            break;
    }
}

- (void)dfuUploadProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    [self setPregress:(float)progress/100.0];
    _dfuLab.text = [NSString stringWithFormat:@"%ld%%",(long)progress];
    NSLog(@"dfuUploadProgressDidChangeFor %ld",(long)progress);
}

- (void)dfuUploadError:(DFUError)error didOccurWithMessage:(NSString *)message{
    NSLog(@"dfuUploadError  %ld  %@",(long)error,message);
    [SmaBleMgr reunitonPeripheral:YES];
    [coverView removeFromSuperview];
    _dfuLab.textColor = [UIColor redColor];
    _dfuLab.font = FontGothamLight(17);
    _remindLab.textColor = [UIColor whiteColor];
    if (tautology >= 3){
        if (SmaBleMgr.repairDfu) {
            _dfuLab.text = SMALocalizedString(@"me_repairFail");
        }
        else{
            _dfuLab.text = SMALocalizedString(@"setting_dfu_retry");
        }
        [SmaBleMgr reunitonPeripheral:NO];
    }
    [_remindLab setText:SMALocalizedString(@"setting_dfu_remind")];
    if (tautology < 3){
        tautology ++;
        [self dfuSelector:nil];
    }
}

- (void)dealloc{
// [super dealloc];
    NSLog(@"DFU dealloc");
//   [[NSNotificationCenter defaultCenter] postNotificationName:@"DFUUPDATEFINISH" object:nil];
}

@end
