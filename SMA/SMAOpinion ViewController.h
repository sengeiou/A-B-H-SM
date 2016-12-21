//
//  SMAOpinion ViewController.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/12.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAOpinion_ViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel *problemLab, *contentLab ,*wordsNum;
@property (nonatomic, weak) IBOutlet UITextView *detailsView;
@property (nonatomic, weak) IBOutlet UITextField *contentField;
@property (nonatomic, weak) IBOutlet UIButton *submitBut;
@end
