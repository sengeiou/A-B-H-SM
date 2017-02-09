
#import <Foundation/Foundation.h>

@interface SMAUserInfo : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userPass;
@property (nonatomic, strong) NSString *userWeigh;
@property (nonatomic, strong) NSString *userHeight;
@property (nonatomic, strong) NSString *userAge;
@property (nonatomic, strong) NSString *userSex;
@property (nonatomic, strong) NSString *userGoal;
@property (nonatomic, strong) NSString *userHeadUrl;
@property (nonatomic, strong) NSString *scnaName;
@property (nonatomic, strong) NSArray *scnaNameArr;
/*当前绑定的手表UID*/
@property (nonatomic, strong) NSString *watchUUID;
@property (nonatomic, strong) NSString *watchVersion;
/*单位*/
@property (nonatomic, strong) NSString *unit;
@end
