//
//  BGHangMonitor.m
//  banggood
//
//  Created by jin fu on 2022/9/20.
//  Copyright © 2022 banggood. All rights reserved.
//

#import "BGHangMonitor.h"
#import "BGHangContext.h"

@interface BGHangMonitor ()
{
    int timeoutCount;
    CFRunLoopObserverRef mainRunLoopObserver;
    @public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity mainRunLoopActivity;
}
@property (nonatomic, assign, readwrite) BOOL isMonitoring;

@end

@implementation BGHangMonitor

+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.hangT = 80; // 80ms
        self.deadT = 5; // 5s
    }
    return self;
}

#pragma mark - notification
// 监听进入前台
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self beginMonitor];
}

// 监听进入后台
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self endMonitor];
}

#pragma mark - public
- (void)beginMonitor
{
    self.isMonitoring = YES;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 添加前后台切换通知
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    });
    
    if (mainRunLoopObserver) {
        return;
    }
    semaphore = dispatch_semaphore_create(0); //Dispatch Semaphore保证同步
    
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    mainRunLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &mainRunLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), mainRunLoopObserver, kCFRunLoopCommonModes); // 观察main runloop
    
    dispatch_queue_t queue = dispatch_queue_create("BGHangMonitor", DISPATCH_QUEUE_CONCURRENT);
    //开启一个子线程持续进行监控mainRunLoop的状态
    __weak __typeof(self)weakSelf = self;
    dispatch_async(queue, ^{
        while (YES) {
            __strong __typeof(self)strongSelf = weakSelf;
            long semaphoreWait = dispatch_semaphore_wait(strongSelf->semaphore, dispatch_time(DISPATCH_TIME_NOW, strongSelf.hangT * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!strongSelf->mainRunLoopObserver) {
                    strongSelf->timeoutCount = 0;
                    strongSelf->semaphore = 0;
                    strongSelf->mainRunLoopActivity = 0;
                    return;
                }
                //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (strongSelf->mainRunLoopActivity == kCFRunLoopBeforeSources || strongSelf->mainRunLoopActivity == kCFRunLoopAfterWaiting) {
                    //连续三次都超过阈值视为卡顿
                    if (++strongSelf->timeoutCount < 3) {
                        continue;
                    }
                    [strongSelf findHang];
                }
            }
            strongSelf->timeoutCount = 0;
        }
    });
}

- (void)endMonitor
{
    self.isMonitoring = NO;
    if (!mainRunLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), mainRunLoopObserver, kCFRunLoopCommonModes);
    CFRelease(mainRunLoopObserver);
    mainRunLoopObserver = NULL;
}

#pragma mark - privicy
- (void)findHang
{
    static BOOL pingMainThread = YES;
    // 监测到卡顿
    if (pingMainThread) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            pingMainThread = NO; // 发现卡顿，说明ping不通主线程
            __block CFTimeInterval blockT = self.hangT*3/1000.f;
            CFTimeInterval start = CACurrentMediaTime();
            dispatch_async(dispatch_get_main_queue(), ^{
                pingMainThread = YES; // ping通主线程
                CFTimeInterval end = CACurrentMediaTime();
                blockT = blockT + (end-start);
                if (self.hangBlock && blockT<self.deadT) {
                    self.hangBlock(hangCurrentVC(), blockT);
                }
            });
            
            [NSThread sleepForTimeInterval:self.deadT];
            // deadT还没恢复，视为卡死
            if (!pingMainThread) {
                if (self.deadBlock) {
                    self.deadBlock(hangCurrentVC());
                }
            }
        });
    }
}

#pragma mark - Observer
static void mainRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    BGHangMonitor *hangMonitor = (__bridge BGHangMonitor*)info;
    hangMonitor->mainRunLoopActivity = activity;
    dispatch_semaphore_t semaphore = hangMonitor->semaphore;
    dispatch_semaphore_signal(semaphore);
}

@end
