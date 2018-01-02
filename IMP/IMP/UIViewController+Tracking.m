//
//  UIViewController+Tracking.m
//  IMP
//
//  Created by 赵海亭 on 2018/1/2.
//  Copyright © 2018年 赵海亭. All rights reserved.
//

// 尝试先调用class_addMethod方法,以保证即便originalSelector只在父类中实现,也能达到Method Swizzling的目的.

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>

@implementation UIViewController (Tracking)

+ (void)initialize {
    
    Class class = [self class];
    
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(zht_viewWillAppear:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)zht_viewWillAppear:(BOOL)animated {
    [self zht_viewWillAppear:animated];
    
    // to do ……
}

@end
