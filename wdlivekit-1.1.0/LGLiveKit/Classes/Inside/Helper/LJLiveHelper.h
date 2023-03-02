//
//  LJLiveHelper.h
//  Woohoo
//
//  Created by M2-mini on 2021/8/24.
//

#import <Foundation/Foundation.h>
#import "LJLiveReportView.h"
#import "LJLiveDataManager.h"
#import "LJLiveRemoteView.h"

NS_ASSUME_NONNULL_BEGIN

#define kLJLiveHelper [LJLiveHelper helper]

@interface LJLiveHelper : NSObject

/// 60s自动关注弹窗
@property (nonatomic, copy) LJLiveVoidBlock followAutoTipBlock;

/*------------------------------------------------------------------------------
 管理模块
 */
/// UI配置及弹窗
@property (nonatomic, strong) LJLiveUIHelper *ui;
/// 数据模块
@property (nonatomic, strong) LJLiveDataManager * __nullable data;

/*------------------------------------------------------------------------------
 状态管理
 */
/// 直播中
@property (nonatomic, assign) BOOL inARoom;
/// 最小化
@property (nonatomic, assign) BOOL isMinimize;
/// 最小化打开
@property (nonatomic, assign) BOOL fullScreenByMinimize;
/// 是否被禁止发言
@property (nonatomic, assign) BOOL barrageMute;
///// Live带走私聊
//@property (nonatomic, assign) BOOL privateChatByLive;
///// 是否弹窗
//@property (nonatomic, assign) BOOL remindAgain;
/// 首页刷新标记
@property (nonatomic, assign) BOOL homeReloadTag;
/// -1：停止
@property (nonatomic, assign) NSInteger comboing;

/*------------------------------------------------------------------------------
 最小化
 */
/// 缓存直播间，执行最小化
@property (nonatomic, strong) LJLiveViewController * __nullable liveVc;
/// 最小化视图
@property (nonatomic, strong) LJLiveRemoteView * __nullable minimizeRemoteView;

/*------------------------------------------------------------------------------
 统计
 */
/// 进入该直播间到退出的时长，进入PK到时间到，PK时间到到结束，进入PK到退出PK
@property (nonatomic, assign) NSInteger liveInOut, pkInTimeUp, pkTimeUpEnd, pkInEnd;
///
@property (nonatomic, assign) NSInteger pkInSendCoins, last15SendCoins;

/// 单例
+ (LJLiveHelper *)helper;

#pragma mark - Agora Network Join Leave

/// 加入房间
/// @param rooms 房间数组
/// @param index 下标
/// @param success 成功
/// @param failure 失败
- (void)lj_openLiveWith:(NSArray<LJLiveRoom *> *)rooms
                 atIndex:(NSInteger)index
                 success:(LJLiveObjectBlock)success
                 failure:(LJLiveVoidBlock)failure;

- (void)lj_openLiveByHostId:(NSInteger)hostAccountId
                     success:(LJLiveObjectBlock)success
                     failure:(LJLiveVoidBlock)failure;

/// 切换房间
/// @param index 下标
/// @param success 完成
/// @param failure 失败
- (void)lj_switchToIndex:(NSInteger)index
                  success:(LJLiveObjectBlock)success
                  failure:(LJLiveVoidBlock)failure;

/// 其他功能需要关闭直播的处理
- (void)lj_close;

/// 滑动切换房间退出当前
/// @param index 下标
- (void)lj_switchLeaveFromIndex:(NSInteger)index;

#pragma mark - Agora Network Other Methods

/// 礼物combo
/// @param config 礼物
- (void)lj_sendGift:(LJLiveGift *)config isFast:(BOOL)isFast;

/// 获取房间内封禁信息
/// @param roomId agoraId
- (void)lj_getMutedMembersAndChannelAttributesWithAgoraRoomId:(NSString *)roomId;

#pragma mark - Public Methods

/// 全屏
/// @param loadingBlock 推控制器
- (void)lj_fullScreenAndLoading:(LJLiveVoidBlock)loadingBlock;

- (void)lj_pkEventsGifts1To5MinIfBeforeEnding:(BOOL)beforeEnd;

/// 结束PK进程时触发的统计
- (void)lj_pkEventsEndingProcess;

#pragma mark - SVG

- (void)lj_downloadSvgs;

/// 根据giftid索引本地svga文件
/// @param giftId 礼物id
- (NSString * __nullable )lj_svgsPathWithGiftId:(NSInteger)giftId;

/// 礼物svga
/// @param player 播放器
/// @param parser parser
/// @param gift 礼物
/// @param success 成功
/// @param failure 失败
- (void)lj_svgaPlayer:(SVGAPlayer *)player
               parser:(SVGAParser *)parser
     playSvgaWithGift:(LJLiveGift *)gift
              success:(LJLiveVoidBlock)success
              failure:(LJLiveVoidBlock)failure;

/// 播放本地svga文件
/// @param player player
/// @param parser parser
/// @param svga 文件
- (void)lj_svgaPlayer:(SVGAPlayer *)player
               parser:(SVGAParser *)parser
   playWithBundleSvga:(NSString *)svga
              success:(LJLiveVoidBlock)success
              failure:(LJLiveVoidBlock)failure;

@end

NS_ASSUME_NONNULL_END
