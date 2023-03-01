//
//  GYLiveRoom.m
//  Woohoo
//
//  Created by M2-mini on 2021/9/4.
//

#import "GYLiveRoom.h"

@implementation GYLiveRoom

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

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"videoChatRoomMembers": [GYLiveRoomMember class],
        @"members": [GYLiveRoomMember class],
        @"gifts": [GYLiveGiftConfig class],
        @"latestBarrages": [GYLiveBarrage class]
    };
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

- (void)setIsHostFollowed:(BOOL)isHostFollowed
{
    _isHostFollowed = isHostFollowed;
    if (self.isUgc) _isHostFollowed = YES;
}

@end

@implementation GYLiveRoomMember

@end

@implementation GYLiveRoomAnchor

@end

@implementation GYLiveRoomUser

@end

@implementation GYLiveRoomDiamond

@end

@implementation GYLivePerfectMatchMsg

@end

@implementation GYLivePrivateChatFlagMsg

@end

@implementation GYLiveDestroyMsg

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"roomNew": @"newRoom"
    };
}

@end

@implementation GYLivePkData

@end

@implementation GYLivePkPlayer

@end

@implementation GYLivePkPlayerPoint

@end

@implementation GYLivePkWinner

@end

@implementation GYLivePkPointUpdatedMsg

@end

@implementation GYLivePkTopFan

@end

@implementation GYLiveGiftConfig

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"gifts": [GYLiveGift class]
    };
}

@end
