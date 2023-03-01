//
//  GYLiveRadioGiftModel.h
//  wdLive
//
//  Created by Mimio on 2022/6/22.
//  Copyright © 2022 Mimio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYLiveRadioGift.h"
NS_ASSUME_NONNULL_BEGIN

@interface GYLiveRadioGiftModel : NSObject
@property (nonatomic, copy  ) NSString *senderAvatar;
@property (nonatomic, copy  ) NSString *senderName;
@property (nonatomic, assign) NSInteger senderUserId;

@property (nonatomic, copy  ) NSString *recieverAvatar;
@property (nonatomic, copy  ) NSString *recieverName;
@property (nonatomic, assign) NSInteger recieverUserId;

@property (nonatomic, copy  ) NSString *giftName;
@property (nonatomic, copy  ) NSString *giftIconUrl;

@property (nonatomic, assign) GYRadioGiftRoomType roomType;
@property (nonatomic, copy  ) NSString *agoraRoomId;
@property (nonatomic, assign) NSInteger roomId;

@end

NS_ASSUME_NONNULL_END
