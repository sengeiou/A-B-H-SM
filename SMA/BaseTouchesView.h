
#import <UIKit/UIKit.h>

@protocol BaseTouchesViewDelegate <NSObject>

- (void)theTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)theTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)theTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface BaseTouchesView : UIView
{
    CGFloat HRWhith;
    CGSize TISize;
    CGSize HRSize;
    CGSize UNSize;
    NSArray *textArr;
    UIImageView *backImage;
    UIImageView *mindImage;
}
@property (nonatomic, retain) UILabel *HRLab;
@property (nonatomic, retain) UILabel *HRUnitLab;
@property (nonatomic, retain) UILabel *timeLab;
@property (nonatomic, weak) id <BaseTouchesViewDelegate> delegate;
- (CGFloat)clearUpWhithHR:(NSString *)hr HRUnit:(NSString *)unit HRTime:(NSString *)time;
- (void)createUI;
@end
