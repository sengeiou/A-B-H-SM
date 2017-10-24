//
//  SMANickViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/11/29.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMANickViewController.h"

@interface SMANickViewController ()
{
    UIImagePickerController *picker;
}
@end

@implementation SMANickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    SMAUserInfo *user = [SMAAccountTool userInfo];
    if (_nameFie.text) {
        user.userName = _nameFie.text;
        [SMAAccountTool saveUser:user];
    }
    //    [self.navigationController setNavigationBarHidden:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)createUI{
    self.title = SMALocalizedString(@"user_title");
    _setPhoLab.text = SMALocalizedString(@"me_perso_setPho");
    _nickLab.text = SMALocalizedString(@"me_perso_name");
    [_nameFie setValue:FontGothamLight(17) forKeyPath:@"_placeholderLabel.font"];
    _nameFie.placeholder = SMALocalizedString(@"me_perso_nameRemi");
    [_nextBut setTitle:SMALocalizedString(@"user_nextStep") forState:UIControlStateNormal];
}

- (IBAction)photoSelector:(id)sender{
    SMABottomSelView *selView = [[SMABottomSelView alloc] initWithFrame:CGRectMake(0, 0, MainScreen.size.width, MainScreen.size.height) title:SMALocalizedString(@"me_perso_chanPho") message:@[SMALocalizedString(@"me_photograph"),SMALocalizedString(@"me_photoAlbum")]];
    selView.delegate = self;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:selView];
}

#pragma mark *************tapSelectCellDelegate
- (void)didSelectCell:(UIButton *)butCell{

    UIImagePickerControllerSourceType sourceType;
    if (butCell.tag == 101) {
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
}

#pragma mark ******UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __block UIImage* image;
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[SMAAccountTool userInfo].userID]];
        image = [UIImage imageUserToCompressForSizeImage:image newSize:CGSizeMake(100, 100)];
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
        [_photoBut setBackgroundImage:image forState:UIControlStateNormal];
    }];
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
