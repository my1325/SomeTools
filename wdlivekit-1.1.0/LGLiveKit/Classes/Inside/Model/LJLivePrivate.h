//
//  LJLivePrivate.h
//  Woohoo
//
//  Created by M2-mini on 2021/9/10.
//

#import "LJLiveBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJLivePrivate : LJLiveBaseObject

@property (nonatomic, assign) LJLiveRoleType roleType;

@property (nonatomic, assign) NSInteger roomId;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger anchorId;

@property (nonatomic, assign) NSInteger leftDiamond;

@property (nonatomic, strong) NSString *userNickName;

@property (nonatomic, strong) NSString *anchorNickName;

@property (nonatomic, assign) NSInteger callTime;

@property (nonatomic, assign) NSInteger initialPrice;

@property (nonatomic, assign) BOOL isTruthOrDareOn;

@property (nonatomic, strong) NSString *anchorAvatar;

@property (nonatomic, assign) BOOL isFollowed;

@property (nonatomic, assign) NSInteger anchorAge;

@property (nonatomic, strong) NSString *anchorGender;

@end

//{
//    "roleType": 0,
//    "roomId": 0,
//    "userId": 0,
//    "anchorId": 0,
//    "leftDiamond": 0,
//    "userNickName": "string",
//    "anchorNickName": "string",
//    "callTime": 0,
//    "initialPrice": 0,
//    "isTruthOrDareOn": true,
//    "anchorAvatar": "string",
//    "isFollowed": true,
//    "anchorAge": 0,
//    "anchorGender": "string"
//}

NS_ASSUME_NONNULL_END
