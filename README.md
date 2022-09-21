# HangMonitor
iOS轻量级主线程卡顿、卡死监控工具类

## 实现原理
通过监听runloop状态，设置阈值来判定主线程是否出现卡顿或者卡死的情况。

### 阈值划分三个等级：
1、流畅性与丢帧：动画、滑动列表不流畅，一般为十几至几十毫秒的级别

2、卡顿：短时间操作无反应，恢复后能继续使用，从几百毫秒至几秒

3、卡死：长时间无反应，直至被系统杀死，通过线上收集数据，最少为5s

### 卡死/卡顿的原因
iOS开发中，由于UIKit是非线程安全的，因此一切与UI相关的操作都必须放在主线程执行，系统会每16ms（1/60帧）将UI的变化重新绘制，渲染至屏幕上。如果UI刷新的间隔能小于16ms，那么用户是不会感到卡顿的。但是如果在主线程进行了一些耗时的操作，阻碍了UI的刷新，那么就会产生卡顿，甚至是卡死。主线程对于任务的处理是基于Runloop机制，如下图所示。Runloop支持外部注册通知回调，提供了

1、RunloopEntry

2、RunloopBeforeTimers

3、RunloopBeforeSources

4、RunloopBeforeWaiting

5、RunloopAfterWaiting

6、RunloopExit

6个时机的事件回调，其流转关系如下图所示。Runloop在没有任务需要处理的时候就会进入至休眠状态，直至有信号将其唤醒，其又会去处理新的任务。
![runloopEvent](https://raw.githubusercontent.com/nibaJin/HangMonitor/main/readmeImg/runloop.png)
在日常编码中，UIEvent事件、Timer事件、dispatch主线程任务都是在Runloop的循环机制的驱动下完成的。一旦我们在主线程中的任何一个环节进行了一个耗时的操作，或者因为锁的使用不当造成了与其它线程的死锁，主线程就会因为无法执行Core - Animation的回调而造成界面无法刷新。而用户的交互又依赖于UIEvent的传递和响应，该流程也必须在主线程中完成。所以说主线程的阻塞会导致UI和交互的双双阻塞，这也是导致卡死、卡顿的根本原因。

### 卡死/卡顿监控方案
目前大多数APM工具都是采用监听Runloop的方式进行卡顿的捕获，这也是性能、准确性表现最好的一种方案。HangMonitor就是通过监听Runloop的方式。

卡顿：HangMonitor默认连续三次超过80ms&小于5s runloop处于kCFRunLoopBeforeSources或者kCFRunLoopAfterWaiting状态，视为卡顿。
卡死：HangMonitor默认大于等于5s runloop处于kCFRunLoopBeforeSources或者kCFRunLoopAfterWaiting状态，视为卡死。
卡顿和卡死阈值均可以根据自己的业务进行修改。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
```ruby
#import "BGHangMonitor.h"

    // Start Monitor
    BGHangMonitor.shareInstance.hangBlock = ^(NSString * _Nonnull vcClassName, double hangT) {
        NSLog(@"------%@发现卡顿,卡顿时长%fs-----", vcClassName, hangT);
    };
    BGHangMonitor.shareInstance.deadBlock = ^(NSString * _Nonnull vcClassName) {
        NSLog(@"------%@发现卡死,主线程无响应时长>5s-----", vcClassName);
    };
    [BGHangMonitor.shareInstance beginMonitor];
```
```ruby
// log
FJViewController发现卡顿,卡顿时长4.194800s
// log
FJViewController发现卡死,主线程无响应时长>5s
```

## Requirements
```ruby
#import "BGHangMonitor.h"
```

## Installation

HangMonitor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HangMonitor'
```

## Author

jin fu, fujin@644628096.com

## License

HangMonitor is available under the MIT license. See the LICENSE file for more info.

## 参考
[字节跳动 iOS Heimdallr 卡死卡顿监控方案与优化之路 精选 原创](https://blog.51cto.com/u_15204236/4960735)
[深入剖析 iOS 性能优化](https://github.com/ming1016/study/wiki/%E6%B7%B1%E5%85%A5%E5%89%96%E6%9E%90-iOS-%E6%80%A7%E8%83%BD%E4%BC%98%E5%8C%96)
