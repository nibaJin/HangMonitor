//
//  BGHangMonitor.h
//  banggood
//
//  Created by jin fu on 2022/9/20.
//  Copyright © 2022 banggood. All rights reserved.
//
//  轻量级卡顿、卡死监测
/*
 1、流畅性与丢帧：动画、滑动列表不流畅，一般为十几至几十毫秒的级别
 
 2、卡顿：短时间操作无反应，恢复后能继续使用，从几百毫秒至几秒

 3、卡死：长时间无反应，直至被系统杀死，通过线上收集数据，最少为5s
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGHangMonitor : NSObject

+ (instancetype)shareInstance;

// 连续三次超过卡顿阈值 视为卡顿
/// 一次卡顿阈值T 单位ms - 默认80ms
@property (nonatomic, assign) NSUInteger hangT;

// 卡死时间， 默认5s
@property (nonatomic, assign) NSUInteger deadT;

/// 发生卡顿时触发回调
/// vcClassName: 当前页面类名
/// hangT: 卡顿时长
@property (nonatomic, copy) void(^hangBlock)(NSString *vcClassName, double hangT);

/// 发生卡死时触发回调
@property (nonatomic, copy) void(^deadBlock)(NSString *vcClassName);

/// 是否开启监测
@property (nonatomic, assign, readonly) BOOL isMonitoring;

// 开启卡顿监控
- (void)beginMonitor;

// 结束卡顿监控
- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
