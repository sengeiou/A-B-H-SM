//
//  SMAMeViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/10/11.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAMeViewController.h"

@interface SMAMeViewController ()
{
    UIImagePickerController *picker;
}
@end

@implementation SMAMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    SmaAnalysisWebServiceTool *webTool = [[SmaAnalysisWebServiceTool alloc] init];
//    [webTool acloudSetScore:20013];
    [self createUI];
}

- (void)createUI{
    SmaBleMgr.BLdelegate = self;
    self.title = SMALocalizedString(@"me_title");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SMAAccountTool userInfo].userID]];
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    UIImage *img = [[UIImage alloc] initWithData:data];
    if (img) {
        [_photoBut setBackgroundImage:img forState:UIControlStateNormal];
    }
    _personalLab.text = SMALocalizedString(@"me_perso_title");
    _goalLab.text = SMALocalizedString(@"me_sport_goal");
    _moreLab.text = SMALocalizedString(@"me_more_set");
    _helpLab.text = SMALocalizedString(@"me_userHelp");
    _signOutLab.text = SMALocalizedString(@"me_signOut");
}

- (IBAction)photoSelector:(id)sender{
    __block UIImagePickerControllerSourceType sourceType ;
//    UIAlertController *photoAler = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *photographAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"me_photograph") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        sourceType = UIImagePickerControllerSourceTypeCamera;
//        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
//             [SmaBleSend setBLcomera:YES];
//            if (!picker) {
//                picker = [[UIImagePickerController alloc] init];//初始化
//                picker.delegate = self;
//                picker.allowsEditing = YES;//设置可编辑
//            }
//            picker.sourceType = sourceType;
//            [self presentViewController:picker animated:YES completion:^{
//                
//            }];
//        }
//        else{
//            [MBProgressHUD showError:SMALocalizedString(@"me_no_photograph")];
//        }
//    }];
//    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"me_photoAlbum") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
//           
//            if (!picker) {
//                picker = [[UIImagePickerController alloc] init];//初始化
//                picker.delegate = self;
//                picker.allowsEditing = YES;//设置可编辑
//            }
//            picker.sourceType = sourceType;
//            [self presentViewController:picker animated:YES completion:^{
//                
//            }];
//        }
//        else{
//            [MBProgressHUD showError:SMALocalizedString(@"me_no_photoAlbum")];
//        }
//        
//    }];
//    UIAlertAction *cancelhAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//    [photoAler addAction:photographAction];
//    [photoAler addAction:albumAction];
//    [photoAler addAction:cancelhAction];
//    [self presentViewController:photoAler animated:YES completion:^{
//        
//    }];
    
    
    SMAPhotoSelectView *photoView = [[SMAPhotoSelectView alloc] initWithButtonTitles:@[SMALocalizedString(@"me_photograph"),SMALocalizedString(@"me_photoAlbum")]];
    [photoView didPhotoSelect:^(UIButton *button) {
        if (button.tag == 101) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                [SmaBleSend setBLcomera:YES];
                if (!picker) {
                    picker = [[UIImagePickerController alloc] init];//初始化
                    picker.delegate = self;
                    picker.allowsEditing = YES;//设置可编辑
                }
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }
            else{
                [MBProgressHUD showError:SMALocalizedString(@"me_no_photograph")];
            }
        }
        else{
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                if (!picker) {
                    picker = [[UIImagePickerController alloc] init];//初始化
                    picker.delegate = self;
                    picker.allowsEditing = YES;//设置可编辑
                }
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
            }
            else{
                [MBProgressHUD showError:SMALocalizedString(@"me_no_photoAlbum")];
            }
        }
    }];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:photoView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0 || section == 1 ){
        return 10;
    }
    else if (section == 2){
        return 30;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UILabel *lab;
    if (section == 3) {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, 10)];
        lab.text = SMALocalizedString(@"©2016 SMA.All Rights Reserved");
        lab.font = FontGothamLight(9);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [SmaColor colorWithHexString:@"#5790F9" alpha:1];
    }
    return lab;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
//        UIAlertController *aler = [UIAlertController alertControllerWithTitle:nil message:SMALocalizedString(@"me_signOut_remind") preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
//            SMAUserInfo *user = [SMAAccountTool userInfo];
//            if (indexPath.section == 3) {
//                [webservice acloudSyncAllDataWithAccount:user.userID callBack:^(id finish) {
//                    
//                }];
//                [webservice logOutSuccess:^(bool result) {
//                    
//                }];
//                user.userID = @"";
//                user.watchUUID = nil;
//                [SMAAccountTool saveUser:user];
//                UINavigationController *loginNav = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
//                [UIApplication sharedApplication].keyWindow.rootViewController=loginNav;
//            }
//            
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.selected = NO;
//        }];
//        [aler addAction:cancelAction];
//        [aler addAction:confimAction];
//        [self presentViewController:aler animated:YES completion:^{
//            
//        }];
        
        SMACenterAlerView *cenAler = [[SMACenterAlerView alloc] initWithMessage: SMALocalizedString(@"me_signOut_remind") buttons:@[SMALocalizedString(@"setting_sedentary_cancel"),SMALocalizedString(@"me_signOut_confirm")]];
        cenAler.delegate = self;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:cenAler];

    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.smawatch.com/page263"]];
    }
}

#pragma mark ***********cenAlerButDelegate
- (void)centerAlerView:(SMACenterAlerView *)alerView didAlerBut:(UIButton *)button{
    if (button.tag == 102) {
        SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
        SMAUserInfo *user = [SMAAccountTool userInfo];
        [webservice acloudSyncAllDataWithAccount:user.userID callBack:^(id finish) {
            
        }];
        [webservice logOutSuccess:^(bool result) {
            
        }];
        user.userID = @"";
        user.watchUUID = nil;
        [SMAAccountTool saveUser:user];
        UINavigationController *loginNav = [MainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
        [UIApplication sharedApplication].keyWindow.rootViewController=loginNav;
    }
}

#pragma mark ******
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"pickimaag = %@ %@",image,editingInfo);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __block UIImage* image;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        NSLog(@"fwgwgg-----%@",NSStringFromCGSize(image.size));
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SMAAccountTool userInfo].userID]];
        image = [UIImage image:image fortargetSize:CGSizeMake(200, 200)];
        NSLog(@"rgerh==%d",UIImageJPEGRepresentation(image, 1).length);
        BOOL result = [UIImageJPEGRepresentation(image, 1) writeToFile: filePath  atomically:YES];
        if(result)
        {
            SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
            [webservice acloudHeadUrlSuccess:^(id result) {
                NSLog(@"上传成功");
            } failure:^(NSError *error) {
                
            }];
        }else{
            NSLog(@"保存失败");
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [SmaBleSend setBLcomera:NO];
        [_photoBut setBackgroundImage:image forState:UIControlStateNormal];
    }];
}

- (void)openBLset{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [SmaBleSend setBLcomera:NO];
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
    NSLog(@"fw2fgwrgrg===");
}

#pragma mark ******bledidDispose
- (void)bledidDisposeMode:(SMA_INFO_MODE)mode dataArr:(NSMutableArray *)data{
    switch (mode) {
        case BOTTONSTYPE:
        {
            if ([[data firstObject] intValue] == 1) {
                [picker takePicture];
            }
            else if([[data firstObject] intValue] == 2){
                 [SmaBleSend setBLcomera:NO];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }

        }
            
            break;
            
        default:
            break;
    }
}
@end
