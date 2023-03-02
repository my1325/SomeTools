//
//  LJLiveRoom.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/4.
//

#import "LJLiveRoom.h"

@implementation LJLiveRoom


+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"videoChatRoomMembers": [LJLiveRoomMember class],
        @"members": [LJLiveRoomMember class],
        @"gifts": [LJLiveGiftConfig class],
        @"latestBarrages": [LJLiveBarrage class]
    };
}




- (void)setIsHostFollowed:(BOOL)isHostFollowed
{
    _isHostFollowed = isHostFollowed;
    if (self.isUgc) _isHostFollowed = YES;
}
- (BOOL)pking
{
    if (self.pkData != nil) {
        if (self.pkData.homePlayer != nil &&
            (self.pkData.homePlayer.roomStatus == 6 ||
            self.pkData.homePlayer.roomStatus == 7 ||
            self.pkData.homePlayer.roomStatus == 8)) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)beActive
{
    switch (self.roomStatus) {
        case 1:
        case 3:
        case 4:
            return NO;
            
        default:
            return YES;
    }
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    // ugc
    if (self.isUgc) {
        self.videoChatRoomMembers = self.members;
        self.isHostFollowed = YES;
    }
    return self;
}
@end

@implementation LJLiveRoomMember

@end

@implementation LJLiveRoomAnchor

@end

@implementation LJLiveRoomUser

@end

@implementation LJLiveRoomDiamond

@end

@implementation LJLivePerfectMatchMsg

@end

@implementation LJLivePrivateChatFlagMsg

@end

@implementation LJLiveDestroyMsg

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"roomNew": @"newRoom"
    };
}

@end

@implementation LJLivePkData

@end

@implementation LJLivePkPlayer

@end

@implementation LJLivePkPlayerPoint

@end

@implementation LJLivePkWinner

@end

@implementation LJLivePkPointUpdatedMsg

@end

@implementation LJLivePkTopFan

@end

@implementation LJLiveGiftConfig

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"gifts": [LJLiveGift class]
    };
}

@end
