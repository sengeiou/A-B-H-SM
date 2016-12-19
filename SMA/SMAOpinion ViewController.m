//
//  SMAOpinion ViewController.m
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMAOpinion ViewController.h"

@interface SMAOpinion_ViewController ()

@end

@implementation SMAOpinion_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    self.title = SMALocalizedString(@"me_set_feedback");
    _detailsView.delegate = self;
    _contentField.delegate = self;
    [_submitBut setTitle:SMALocalizedString(@"me_set_feeback_submit") forState:UIControlStateNormal];
    _problemLab.text = SMALocalizedString(@"me_set_feedback_problem");
    _contentLab.text = SMALocalizedString(@"me_set_feedback_relation");
}

- (IBAction)selector:(id)sender{
    if ([_detailsView.text isEqualToString:@""]) {
        [MBProgressHUD showError:SMALocalizedString(@"me_set_feeback_contact")];
        return;
    }
    if ([_contentField.text isEqualToString:@""]) {
        [MBProgressHUD showError:SMALocalizedString(@"me_set_feedback_content")];
        return;
    }
    [MBProgressHUD showSuccess:SMALocalizedString(@"me_set_feeback_subing")];
    SmaAnalysisWebServiceTool *webservice = [[SmaAnalysisWebServiceTool alloc] init];
    [webservice acloudFeedbackContact:_contentField.text content:_detailsView.text callBack:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            [MBProgressHUD showSuccess:SMALocalizedString(@"me_set_feeback_subSucc")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            [MBProgressHUD showError:[NSString stringWithFormat:@"%ld %@",(long)error.code,SMALocalizedString(@"me_set_feeback_subFail")]];
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSLog(@"FWGGH==%@",aString);
    if (aString.length > 400) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
       [textView resignFirstResponder];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
   if (aString.length > 100) {
        return NO;
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [textField resignFirstResponder];
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
