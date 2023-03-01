

#import "GYLiveThrottle.h"

@interface GYLiveThrottle ()

/// 节流触发的事件
@property (nonatomic, copy) void(^action)(void);

/// 上一次执行的时间
@property (nonatomic, assign) NSTimeInterval fireDate;

/// 线程安全队列
@property (nonatomic, strong) dispatch_queue_t syncQueue;

@end

@implementation GYLiveThrottle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.threshold = 1.0;
        self.queue = dispatch_get_main_queue();
        const char *label = [NSString stringWithFormat:@"GCDThrottle_%p", self].UTF8String;
        self.syncQueue = dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)doAction:(void(^)(void))block {
    dispatch_async(self.syncQueue, ^{
        // 比限制的时间超过多少
        NSTimeInterval span = NSDate.date.timeIntervalSince1970 - self.fireDate - self.threshold;
        if (span >= 0) {
            // 超过，可以直接触发
            self.action = block;
            [self fire];
        } else {
            // 没超过，则需要做延迟
            if (self.action) {
                // 还有待执行的，则直接覆盖，等待执行
                self.action = block;
            } else {
                // 没有待执行的，需要做延迟执行
                self.action = block;
                // 延后{span}s执行
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ABS(span) * NSEC_PER_SEC)), self.syncQueue, ^{
//                    [self fire];
//                });
            }
        }
    });
}

- (void)fire {
    dispatch_async(self.syncQueue, ^{
        if (self.action) {
            // 执行队列，默认为主线程
            void(^action)(void) = self.action;
            // 取出action抛给指定队列执行
            dispatch_async(self.queue, ^{
                action();
            });
            // 触发完成后清空
            self.action = nil;
            // 触发时间
            self.fireDate = NSDate.date.timeIntervalSince1970;
        }
    });
}

@end
