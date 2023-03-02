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







#pragma mark - Agora Network Join Leave






#pragma mark - Agora Network Other Methods



#pragma mark - Public Methods




#pragma mark - SVG





/// UI配置及弹窗
/// 进入该直播间到退出的时长，进入PK到时间到，PK时间到到结束，进入PK到退出PK
/*------------------------------------------------------------------------------
 统计
 */
/// 单例
/*------------------------------------------------------------------------------
 最小化
 */
/// @param success 成功
/// @param success 完成
/*------------------------------------------------------------------------------
 状态管理
 */
/// @param rooms 房间数组
/// 数据模块
//@property (nonatomic, assign) BOOL remindAgain;
//@property (nonatomic, assign) BOOL privateChatByLive;
/// 礼物svga
/// @param giftId 礼物id
/// @param player 播放器
/// 最小化视图
/// 根据giftid索引本地svga文件
/// 结束PK进程时触发的统计
/// 是否被禁止发言
/// @param index 下标
/// 最小化打开
/// 首页刷新标记
/// 60s自动关注弹窗
/// 直播中
/// @param config 礼物
/// @param player player
/// @param failure 失败
///// Live带走私聊
/// 切换房间
/// 加入房间
/// @param loadingBlock 推控制器
/// 滑动切换房间退出当前
/// @param parser parser
/*------------------------------------------------------------------------------
 管理模块
 */
/// 播放本地svga文件
/// @param svga 文件
/// @param roomId agoraId
/// -1：停止
///// 是否弹窗
///
/// @param index 下标
/// @param parser parser
/// @param index 下标
/// 其他功能需要关闭直播的处理
/// @param gift 礼物
/// 缓存直播间，执行最小化
/// 最小化
/// @param success 成功
/// 礼物combo
/// 获取房间内封禁信息
/// @param failure 失败
/// 全屏
/// @param failure 失败
- (void)lj_getMutedMembersAndChannelAttributesWithAgoraRoomId:(NSString *)roomId;
- (void)lj_switchLeaveFromIndex:(NSInteger)index;
- (NSString * __nullable )lj_svgsPathWithGiftId:(NSInteger)giftId;
- (void)lj_openLiveWith:(NSArray<LJLiveRoom *> *)rooms
                 atIndex:(NSInteger)index
                 success:(LJLiveObjectBlock)success
                 failure:(LJLiveVoidBlock)failure;
- (void)lj_downloadSvgs;
- (void)lj_switchToIndex:(NSInteger)index
                  success:(LJLiveObjectBlock)success
                  failure:(LJLiveVoidBlock)failure;
- (void)lj_svgaPlayer:(SVGAPlayer *)player
               parser:(SVGAParser *)parser
   playWithBundleSvga:(NSString *)svga
              success:(LJLiveVoidBlock)success
              failure:(LJLiveVoidBlock)failure;
- (void)lj_close;
- (void)lj_pkEventsGifts1To5MinIfBeforeEnding:(BOOL)beforeEnd;
- (void)lj_svgaPlayer:(SVGAPlayer *)player
               parser:(SVGAParser *)parser
     playSvgaWithGift:(LJLiveGift *)gift
              success:(LJLiveVoidBlock)success
              failure:(LJLiveVoidBlock)failure;
- (void)lj_sendGift:(LJLiveGift *)config isFast:(BOOL)isFast;
- (void)lj_openLiveByHostId:(NSInteger)hostAccountId
                     success:(LJLiveObjectBlock)success
                     failure:(LJLiveVoidBlock)failure;
- (void)lj_fullScreenAndLoading:(LJLiveVoidBlock)loadingBlock;
+ (LJLiveHelper *)helper;
- (void)lj_pkEventsEndingProcess;
@property (nonatomic, copy) LJLiveVoidBlock followAutoTipBlock;
@property (nonatomic, assign) BOOL fullScreenByMinimize;
@property (nonatomic, strong) LJLiveDataManager * __nullable data;
@property (nonatomic, assign) BOOL inARoom;
@property (nonatomic, assign) BOOL isMinimize;
@property (nonatomic, assign) NSInteger comboing;
@property (nonatomic, strong) LJLiveRemoteView * __nullable minimizeRemoteView;
@property (nonatomic, assign) NSInteger pkInSendCoins, last15SendCoins;
@property (nonatomic, assign) NSInteger liveInOut, pkInTimeUp, pkTimeUpEnd, pkInEnd;
@property (nonatomic, strong) LJLiveViewController * __nullable liveVc;
@property (nonatomic, strong) LJLiveUIHelper *ui;
@property (nonatomic, assign) BOOL homeReloadTag;
@property (nonatomic, assign) BOOL barrageMute;
@end

NS_ASSUME_NONNULL_END
