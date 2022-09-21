# HangMonitor
iOS轻量级主线程卡顿、卡死监控

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
