
#import "SMAUserInfo.h"

@implementation SMAUserInfo
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        _userName = [decoder decodeObjectForKey:@"_userName"];
        _userID = [decoder decodeObjectForKey:@"_userID"];
        _userPass = [decoder decodeObjectForKey:@"_userPass"];
        _userWeigh = [decoder decodeObjectForKey:@"_userWeigh"];
        _userHeight = [decoder decodeObjectForKey:@"_userHeight"];
        _userAge = [decoder decodeObjectForKey:@"_userAge"];
        _userSex = [decoder decodeObjectForKey:@"_userSex"];
        _userGoal = [decoder decodeObjectForKey:@"_userGoal"];
        _userHeadUrl = [decoder decodeObjectForKey:@"_userHeadUrl"];
        _scnaName = [decoder decodeObjectForKey:@"_scnaName"];
        _scnaNameArr = [decoder decodeObjectForKey:@"_scnaNameArr"];
        _watchUUID = [decoder decodeObjectForKey:@"_watchUUID"];
        _watchVersion = [decoder decodeObjectForKey:@"_watchVersion"];
        _unit = [decoder decodeObjectForKey:@"_unit"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_userName forKey:@"_userName"];
    [encoder encodeObject:_userID forKey:@"_userID"];
    [encoder encodeObject:_userPass forKey:@"_userPass"];
    [encoder encodeObject:_userWeigh forKey:@"_userWeigh"];
    [encoder encodeObject:_userHeight forKey:@"_userHeight"];
    [encoder encodeObject:_userAge forKey:@"_userAge"];
    [encoder encodeObject:_userSex forKey:@"_userSex"];
    [encoder encodeObject:_userGoal forKey:@"_userGoal"];
    [encoder encodeObject:_userHeadUrl forKey:@"_userHeadUrl"];
    [encoder encodeObject:_scnaName forKey:@"_scnaName"];
    [encoder encodeObject:_scnaNameArr forKey:@"_scnaNameArr"];
    [encoder encodeObject:_watchUUID forKey:@"_watchUUID"];
    [encoder encodeObject:_watchVersion forKey:@"_watchVersion"];
    [encoder encodeObject:_unit forKey:@"_unit"];
}
@end
