
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
@property (nonatomic, strong) NSArray *userResHr;
@property (nonatomic, strong) NSString *scnaName;
/*当前绑定的手表UID*/
@property (nonatomic, strong) NSUUID *watchUUID;
/*单位*/
@property (nonatomic, strong) NSString *unit;
@end
