//
//  MyCar.m
//  IMP
//
//  Created by 赵海亭 on 2018/1/2.
//  Copyright © 2018年 赵海亭. All rights reserved.
//

// 例如已知一个className为Car的类中有一个实例方法- (void)run:(double)speed, 目前需要Hook该方法对速度小于120才执行run的代码, 按照方法交换的流程, 

#import "MyCar.h"
#import <objc/runtime.h>

@implementation MyCar

+ (void)load {
    
    Class originalClass = NSClassFromString(@"Car");
    Class swizzledClass = [self class];
    
    SEL originalSelector = NSSelectorFromString(@"run:");
    SEL swizzledSelector = @selector(zht_run:);
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    // 像car类添加一个 zht_run：方法
    BOOL registerMethod = class_addMethod(originalClass, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (!registerMethod) return;
    
    // 需要更新swizzledMethod变量,获取当前Car类中xxx_run:的Method指针
    swizzledMethod = class_getInstanceMethod(originalClass, swizzledSelector);
    if (!swizzledMethod) return;
    
    // 后续流程与之前的一致
    BOOL didAddMethod = class_addMethod(originalClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(originalClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/// 以上所有的逻辑也可以合并简化为以下
- (void)sample {
    
    Class originalClass = NSClassFromString(@"Car");
    Class swizzledClass = [self class];
    
    SEL originalSelector = NSSelectorFromString(@"run:");
    SEL swizzledSelector = @selector(zht_run:);
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    
    class_replaceMethod(originalClass,swizzledSelector,originalIMP,originalType);
    class_replaceMethod(originalClass,originalSelector,swizzledIMP,swizzledType);
}

- (void)zht_run:(double)speed {
    
    if (speed < 120) {
        NSLog(@"~~~~~~~~");
        [self zht_run:speed];
    }
}

@end
