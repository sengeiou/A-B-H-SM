//
//  SMAChangeCell.h
//  SMA
//
//  Created by 有限公司 深圳市 on 2016/12/6.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^textFieldBlock)(UITextField *textField);
@interface SMAChangeCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* passW;
@property (nonatomic, weak) IBOutlet UILabel *passTitLab;
@property (nonatomic, weak) IBOutlet UITextField *passField;
//- (void)
@end
