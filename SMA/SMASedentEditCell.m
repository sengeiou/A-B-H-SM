//
//  SMASedentEditCell.m
//  SMA
//
//  Created by 有限公司 深圳市 on 16/9/27.
//  Copyright © 2016年 SMA. All rights reserved.
//

#import "SMASedentEditCell.h"

@implementation SMASedentEditCell
{
    NSTimer *editTimer;
    BOOL editing;
    BOOL undrag;
    BOOL restore;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEdit:(BOOL)edit{
    _edit = edit;
    [self updateUI];
}

- (void)createUI{
     CGSize fontsize = [_deleBut.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(20)}];
    _scrollView.frame = CGRectMake(0, 0, MainScreen.size.width, 100);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _editBut.frame = CGRectMake(0, 0, 30, 100);
    _backView.frame = CGRectMake(CGRectGetMaxX(_editBut.frame), 0, MainScreen.size.width, 100);
    _pushBut.frame = CGRectMake(CGRectGetMaxX(_editBut.frame), 0, MainScreen.size.width, 100);
    _deleBut.frame = CGRectMake(CGRectGetMaxX(_backView.frame), 0, fontsize.width + 30, 100);
    _scrollView.contentSize = CGSizeMake(_editBut.frame.size.width + _backView.frame.size.width + _deleBut.frame.size.width, 100);
    _scrollView.contentOffset = CGPointMake(30, 0);
    _alarmSwitch.frame = CGRectMake(CGRectGetWidth(_backView.frame) - 59, 31, 51, 31);
    _accessoryIma.frame = CGRectMake(CGRectGetWidth(_backView.frame) - 59, 39, 8, 15);
    _timeLab.frame = CGRectMake(20, 0, _backView.frame.size.width - 80, 70);
     CGSize titlesize = [_titleLab.text sizeWithAttributes:@{NSFontAttributeName:FontGothamLight(16)}];
    _titleLab.frame = CGRectMake(20, CGRectGetMaxY(_timeLab.frame), titlesize.width , 21);
    _weakLab.frame = CGRectMake(CGRectGetMaxX(_titleLab.frame), CGRectGetMaxY(_timeLab.frame), _backView.frame.size.width-titlesize.width - 80, 21);
    _accessoryIma.alpha = 0;
    _accessoryIma.hidden = NO;
//    _alarmSwitch.hidden = NO;
}

-(void)setAlarmInfo:(SmaAlarmInfo *)alarmInfo{
    _alarmInfo = alarmInfo;
    _timeLab.text = [NSString stringWithFormat:@"%@:%@",alarmInfo.hour,alarmInfo.minute];
    _titleLab.text = [NSString stringWithFormat:@"%@,",alarmInfo.tagname];
    _weakLab.text=[self weekStrConvert:alarmInfo.dayFlags];
    _alarmSwitch.on = [alarmInfo.isOpen intValue];
    [self createUI];
}

- (void)updateUI{
    if (!_edit) {
        editing = _edit;
//        restore = YES;
    }
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(_edit?0:30, 0);
            _alarmSwitch.alpha = !_edit;
            _accessoryIma.alpha = _edit;
        } completion:^(BOOL finished) {
            editing = _edit;
        }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scrollViewWillBeginDecelerating == %f  %d",scrollView.contentOffset.x,restore);
//    if (restore) {
//        return;
//    }
    if (!_edit) {
            if (scrollView.contentOffset.x <= CGRectGetWidth(_editBut.frame)) {
                scrollView.contentOffset = CGPointMake(CGRectGetWidth(_editBut.frame), 0);
                return;
            }
    }
    else if (editing && !undrag){
        _scrollView.contentOffset = CGPointMake(0, 0);
            return;
    }
    else if(undrag){
            undrag = NO;
            editing = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _scrollView.contentOffset = CGPointMake(0, 0);
            } completion:^(BOOL finished) {
                undrag = NO;
                
            }];
    }
    return;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%f scrollViewDidEndDragging == %f",scrollView.contentOffset.x,_deleBut.frame.size.width/2);
    if (scrollView.contentOffset.x - CGRectGetWidth(_editBut.frame) > _deleBut.frame.size.width/2) {
        if (editTimer) {
            [editTimer invalidate];
            editTimer = nil;
        }
        editTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(methodWithOneParam:) userInfo:@"edit" repeats:NO];
    }
    else{
        if (editTimer) {
            [editTimer invalidate];
            editTimer = nil;
        }
        editTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(methodWithOneParam:) userInfo:@"unedit" repeats:NO];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating == %f",scrollView.contentOffset.x);
    if (editTimer) {
        [editTimer invalidate];
        editTimer = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndDecelerating === %f",scrollView.contentOffset.x);
    if (scrollView.contentOffset.x == 0 && _edit) {
         editing = YES;
        _pushBut.enabled = YES;
    }
    else if (scrollView.contentOffset.x == 100 && !_edit){
        undrag = YES;
    }
    
    if (scrollView.contentOffset.x - CGRectGetWidth(_editBut.frame) > _deleBut.frame.size.width/2) {
        if (editTimer) {
            [editTimer invalidate];
            editTimer = nil;
        }
        editTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(methodWithOneParam:) userInfo:@"edit" repeats:NO];
    }
    else{
        if (editTimer) {
            [editTimer invalidate];
            editTimer = nil;
        }
        editTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(methodWithOneParam:) userInfo:@"unedit" repeats:NO];
    }

}

- (void)methodWithOneParam:(NSTimer *)paramFirst{
    NSLog(@"methodWithOneParam: %@", paramFirst.userInfo);
    if ([paramFirst.userInfo isEqualToString:@"edit"]) {
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(_deleBut.frame.size.width + CGRectGetWidth(_editBut.frame), 0);
        }completion:^(BOOL finished) {
            undrag = YES;
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(_edit?0:30, 0);
            _alarmSwitch.alpha = !_edit;
            _accessoryIma.alpha = _edit;
        } completion:^(BOOL finished) {
            if (_edit) {
                 editing = YES;
            }
        }];
    }
    if (editTimer) {
        [editTimer invalidate];
        editTimer = nil;
    }
}

- (IBAction)editSelector:(id)sender{
    NSLog(@"点减号");
    editing = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(_deleBut.frame.size.width + CGRectGetWidth(_editBut.frame), 0);
    } completion:^(BOOL finished) {
        undrag = YES;
         NSLog(@"点减号_ %d",undrag);
    }];
}


- (IBAction)pushSelector:(id)sender{
    NSLog(@"点距2  %@",_alarmInfo);
    _pushBlock(_alarmInfo);
}

- (IBAction)pushBeginSelector:(id)sender{
    NSLog(@"点距3 %d",undrag);
    if (undrag) {
        undrag = NO;
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            undrag = NO;
        }];
    }
}

- (IBAction)deleteSelector:(id)sender{
    _deleteBlock(_alarmInfo,self);
}

- (void)switchSelector:(UISwitch *)sender{
    if ([SmaBleMgr checkBLConnectState]) {
        _alarmInfo.isOpen = [NSString stringWithFormat:@"%d",sender.on];
        _switchBlock(sender,_alarmInfo);
    }
    else{
       _alarmSwitch.on = _alarmInfo.isOpen.intValue;
    }
}

- (void)tapSwitchBlock:(openButton) block{
     _switchBlock = block;
     [_alarmSwitch addTarget:self action:@selector(switchSelector:) forControlEvents:UIControlEventTouchUpInside];
}

-(NSString *)weekStrConvert:(NSString *)weekStr
{
    NSArray *week=[[SMACalculate toBinarySystemWithDecimalSystem:weekStr] componentsSeparatedByString: @","];
    NSString *str=@"";
    int counts=0;
    int workCounts=0;
    int weekendConts = 0;
    for (int i=0; i<week.count; i++) {
        if([week[i] intValue]==1)
        {
            counts++;
            str=[NSString stringWithFormat:@"%@  %@",str,[self stringWith:i]];
            if (i < 5) {
                workCounts ++;
            }
            if (i > 4) {
                weekendConts ++;
            }
        }
    }
    if (workCounts == 0 && weekendConts == 2) {
        str=SMALocalizedString(@"setting_sedentary_weekend");
    }
    else if(workCounts == 5 && weekendConts == 0) {
        str=SMALocalizedString(@"setting_sedentary_workday");
    }
    if(counts==7){
        str=SMALocalizedString(@"setting_sedentary_every");
    }
    return str;
    
}

-(NSString *)stringWith:(int)weekInt
{
    NSString *weekStr=@"";
    switch (weekInt) {
        case 0:
            weekStr= SMALocalizedString(@"setting_sedentary_mon");
            break;
        case 1:
            weekStr= SMALocalizedString(@"setting_sedentary_tue");
            break;
        case 2:
            weekStr= SMALocalizedString(@"setting_sedentary_wed");
            break;
        case 3:
            weekStr= SMALocalizedString(@"setting_sedentary_thu");
            break;
        case 4:
            weekStr= SMALocalizedString(@"setting_sedentary_fri");
            break;
        case 5:
            weekStr= SMALocalizedString(@"setting_sedentary_sat");
            break;
        default:
            weekStr= SMALocalizedString(@"setting_sedentary_sun");
    }
    return weekStr;
}

@end
