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
    [self createUI];
}

- (void)createUI{
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
    UIAlertController *photoAler = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photographAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"me_photograph") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
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
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"me_photoAlbum") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

    }];
    UIAlertAction *cancelhAction = [UIAlertAction actionWithTitle:SMALocalizedString(@"setting_sedentary_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [photoAler addAction:photographAction];
    [photoAler addAction:albumAction];
    [photoAler addAction:cancelhAction];
    [self presentViewController:photoAler animated:YES completion:^{
        
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     SmaAnalysisWebServiceTool *webservice=[[SmaAnalysisWebServiceTool alloc]init];
//    [webservice acloudDownLHeadUrlWithAccount:[SMAAccountTool userInfo].userID Success:^(id success) {
//        
//    } failure:^(NSError * error) {
//        
//    }];
//     [self openBLset];
    if (indexPath.section == 3) {
        [webservice logOutSuccess:^(bool result) {
            
        }];
        SMAUserInfo *user = [SMAAccountTool userInfo];
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
         image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SMAAccountTool userInfo].userID]];
        BOOL result = [[self scaleToSize:image] writeToFile: filePath  atomically:YES];
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

static float i = 0.1; float A = 0;
- (NSData *)scaleToSize:(UIImage *)imge{
    NSData *data;
    data= UIImageJPEGRepresentation(imge, 1);
    
    if (data.length > 70000) {
        [self zoomImaData:imge];
        data = UIImageJPEGRepresentation(imge,1-A);
        A = 0;
    }
    return data;
}

- (void)zoomImaData:(UIImage *)image{
    A = A + i;
    NSData *data = UIImageJPEGRepresentation(image,1-A);
    if (data.length > 70000) {
        [self zoomImaData:image];
    }
}
@end
