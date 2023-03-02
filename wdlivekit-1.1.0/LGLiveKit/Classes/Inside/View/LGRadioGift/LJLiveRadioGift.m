//
//  LJRadioGIftView.m
//  wdLive
//
//  Created by Mimio on 2022/6/21.
//  Copyright © 2022 Mimio. All rights reserved.
//

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define StatusH (IPHONE_X ? 44.f : 20.f)
#define KSW     [UIScreen mainScreen].bounds.size.width

#import "LJLiveRadioGift.h"
#import "LJLiveRadioGiftCell.h"

#import <MJExtension/MJExtension.h>
@interface LJLiveRadioGift()
@property (nonatomic, strong) NSMutableArray<LJLiveRadioGiftCell *> *waitArr;
@property (nonatomic, strong) NSMutableArray<LJLiveRadioGiftCell *> *enterArr;//进场队列
@property (nonatomic, strong) NSMutableArray<LJLiveRadioGiftCell *> *showArr;//展示队列
@property (nonatomic, assign) BOOL isWait;
@property (nonatomic, assign) BOOL canClick;
@property (nonatomic, strong) LJLiveRadioGiftModel *model;

@end

@implementation LJLiveRadioGift

+ (LJLiveRadioGift *)shared
{
    static LJLiveRadioGift *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[LJLiveRadioGift alloc] init];
    });
    return obj;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"radioFirst"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"radioFirst"];//是否是第一次启动
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"radioGiftEnable"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        _supportRoomType =  LJRadioGiftSupportRoomTypeLive|LJRadioGiftSupportRoomTypeChatRoom;
        _radioGiftView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusH + 54, KSW, 48.5)];
        _radioGiftView.userInteractionEnabled = NO;
        _radioGiftView.hidden = ![[NSUserDefaults standardUserDefaults] boolForKey:@"radioGiftEnable"];
        _waitArr = [NSMutableArray new];
        _enterArr = [NSMutableArray new];
        _showArr = [NSMutableArray new];
        _isWait = NO;
        _canClick = YES;
        [self addObserver:self forKeyPath:@"enterArr" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:@"isWait" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)lj_initRadioGiftViewInView:(UIView *)view boldFontName:(NSString *)boldFontName{
    _boldFontName = boldFontName;
    
    [_radioGiftView removeFromSuperview];
    [view addSubview:_radioGiftView];
}

- (void)lj_recieveRadioGift:(NSDictionary *)gift{
    
    if (!_radioGiftView) {
        return;
    }
    
    //统计
    if ([self.delegate respondsToSelector:@selector(lj_thinkingEventName:)]) {
        [self.delegate lj_thinkingEventName:@"number_gift_broadcast"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        LJLiveRadioGiftCell *cell = [[LJLiveRadioGiftCell alloc] initWithFrame:CGRectMake(KSW, 0, KSW, 48.5)];
        _model = [LJLiveRadioGiftModel mj_objectWithKeyValues:gift];
        
        cell.model = _model;
        [_radioGiftView addSubview:cell];
        [_waitArr addObject:cell];
        if (!_isWait) {//没有进场的
            [_waitArr removeObjectAtIndex:0];
            
            //统计
            if (self.enable) {
                if ([self.delegate respondsToSelector:@selector(lj_thinkingEventName:)]) {
                    [self.delegate lj_thinkingEventName:@"success_gift_broadcast"];
                }
            }
            
            [[self mutableArrayValueForKey:@"enterArr"] addObject:cell];
            _enterArr.firstObject.state = LJLiveRadioGiftCellStateEnter;
            _radioGiftView.userInteractionEnabled = YES;
            
            //0.8秒后将 从进场队列移动到展示队列
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_showArr addObject:_enterArr.firstObject];
                [[self mutableArrayValueForKey:@"enterArr"] removeObjectAtIndex:0];
            });
            //1.8秒后将 冷却完毕
            self.isWait = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isWait = NO;
            });
        }else{
            if ([self.delegate respondsToSelector:@selector(lj_thinkingEventName:)]) {
                [self.delegate lj_thinkingEventName:@"queue_gift_broadcast"];
            }
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lj_clickCell)];
        [cell addGestureRecognizer:tap];
    });

}

-(void)lj_clickCell{
    
    if (_canClick) {
        if ([self.delegate respondsToSelector:@selector(lj_clickRadioGiftWithRoomType:andRoomId:andAgoraRoomId:andHostAccountId:)]) {
            [self.delegate lj_clickRadioGiftWithRoomType:_model.roomType andRoomId:_model.roomId andAgoraRoomId:_model.agoraRoomId andHostAccountId:_model.recieverUserId];
            if ([self.delegate respondsToSelector:@selector(lj_thinkingEventName:)]) {
                [self.delegate lj_thinkingEventName:@"click_gift_broadcast"];
            }
        }
        _canClick = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _canClick = YES;
        });
    }


}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"enterArr"]){
        if (_enterArr.count != 0) {//进场队列有值
            if (_showArr.count != 0) {//如果进场时有展示的
                _showArr.firstObject.state = LJLiveRadioGiftCellStateExit;
                [_showArr removeObjectAtIndex:0];
                _radioGiftView.userInteractionEnabled = NO;
            }
        }
    }
    
    if([keyPath isEqualToString:@"isWait"]){
        NSLog(@"wait状态%d",_isWait);
        if (!_isWait) {//如果冷却好了
            if (_waitArr.count != 0) {//等待队列有值
                //将等待队列加入进场队列
                [[self mutableArrayValueForKey:@"enterArr"] addObject:_waitArr.firstObject];
                [_waitArr removeObjectAtIndex:0];
                
                //统计
                if (self.enable) {
                    if ([self.delegate respondsToSelector:@selector(lj_thinkingEventName:)]) {
                        [self.delegate lj_thinkingEventName:@"success_gift_broadcast"];
                    }
                }
            
                _enterArr.firstObject.state = LJLiveRadioGiftCellStateEnter;
                _radioGiftView.userInteractionEnabled = YES;
                //.8秒后将 从进场队列移动到展示队列
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_showArr addObject:_enterArr.firstObject];
                    [[self mutableArrayValueForKey:@"enterArr"] removeObjectAtIndex:0];
                });
                //1.8秒后将 冷却完毕
                self.isWait = YES;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.isWait = NO;
                });
            }
        }
    }
}

-(void)lj_clearAllRadioGift{
    [_waitArr removeAllObjects];
    [_enterArr removeAllObjects];
    if (_showArr.count > 0) {
        _showArr.firstObject.state = LJLiveRadioGiftCellStateExit;
        [_showArr removeAllObjects];
    }
    _isWait = NO;
}

- (BOOL)enable{
    return !_radioGiftView.hidden;
}

- (void)setEnable:(BOOL)enable{
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"radioGiftEnable"];
    _radioGiftView.hidden = !enable;
}

#pragma mark - Channel代理 广播消息
- (void)lj_receiveRtmRespone:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if ([dic[@"opCode"] integerValue] != 3) {
        return;
    }
    
    if ([dic[@"subCode"] integerValue] == 75) {
        int roomType = [[dic[@"data"] objectForKey:@"roomType"] intValue];
        //支持语聊房
        if ((!(_supportRoomType & LJRadioGiftSupportRoomTypeChatRoom)) && roomType == LJRadioGiftRoomTypeChatRoom) {
            return;
        }
        //支持直播间
        if ((!(_supportRoomType & LJRadioGiftSupportRoomTypeLive)) && roomType == LJRadioGiftRoomTypeLive) {
            return;
        }
        //支持UGC
        if ((!(_supportRoomType & LJRadioGiftSupportRoomTypeUGC)) && roomType == LJRadioGiftRoomTypeUGC) {
            return;
        }
        [self lj_recieveRadioGift:dic[@"data"]];
    }
}



@end
