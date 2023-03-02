//
//  LJLiveMultiplayerRoom.h
//  Woohoo
//
//  Created by M2-mini on 2021/12/3.
//

#import "LJLiveBaseObject.h"
//#import "LJChatRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLiveMultiplayerRoom : LJLiveBaseObject




/// 1：语聊室，2：直播间
//@property (nonatomic, strong) LJChatRoomModel *voiceChatRoom;
@property (nonatomic, strong) LJLiveRoom *videoChatRoom;
@property (nonatomic, assign) NSInteger roomType;
@end

@interface LJLiveMultiplayerRoomAnchor : LJLiveBaseObject








/// 1：语聊室，2：直播间
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger memberCount;
@property (nonatomic, strong) NSString *anchorName;
@property (nonatomic, strong) NSString *displayAccountId;
@property (nonatomic, assign) NSInteger roomType;
@end

NS_ASSUME_NONNULL_END
