//
//  BGHangContext.m
//  banggood
//
//  Created by jin fu on 2022/9/21.
//  Copyright © 2022 banggood. All rights reserved.
//

#import "BGHangContext.h"
#import <objc/runtime.h>

BOOL hangSwizzleMethod(Class class, SEL origSel_, SEL altSel_) {
    Method origMethod = class_getInstanceMethod(class, origSel_);
    if (!origMethod) {
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(class, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(class,
                    origSel_,
                    class_getMethodImplementation(class, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(class,
                    altSel_,
                    class_getMethodImplementation(class, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(class, origSel_), class_getInstanceMethod(class, altSel_));
    return YES;
}

NSString *hang_vcClass = @"";

void hangSetCurrentVC(NSString *vcClass)
{
    hang_vcClass = vcClass;
}

NSString* hangCurrentVC(void)
{
    return hang_vcClass;
}

@implementation UIViewController(HangContext)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hangSwizzleMethod(self, @selector(viewDidAppear:), @selector(hang_viewDidDisappear:));
    });
}

- (void)hang_viewDidDisappear:(BOOL)animated
{
    [self hang_viewDidDisappear:animated];
    hangSetCurrentVC(NSStringFromClass(self.class));
}

@end
