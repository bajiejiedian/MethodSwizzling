//
//  NSDictionary+Test.m
//  IMP
//
//  Created by 赵海亭 on 2018/1/2.
//  Copyright © 2018年 赵海亭. All rights reserved.
//
//  对于类方法的动态添加,需要将方法添加到MetaClass中,因为实例方法记录在class的method-list中, 类方法是记录在meta-class中的method-list中的.

#import "NSDictionary+Test.h"
#import <objc/runtime.h>

@implementation NSDictionary (Test)

+ (void)load {
    
    Class cls = [self class];
    SEL originalSelector = @selector(dictionary);
    SEL swizzledSelector = @selector(zht_dictionary);
    
    // 使用class_getClassMethod来获取类方法的Method
    Method originalMethod = class_getClassMethod(cls, originalSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzledSelector);
    if (!originalMethod || !swizzledMethod) {
        return;
    }
    
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    
    const char *originalType = method_getTypeEncoding(originalMethod);
    const char *swizzledType = method_getTypeEncoding(swizzledMethod);
    
    // 类方法添加,需要将方法添加到MetaClass中
    Class metaClass = objc_getMetaClass(class_getName(cls));
    class_replaceMethod(metaClass,swizzledSelector,originalIMP,originalType);
    class_replaceMethod(metaClass,originalSelector,swizzledIMP,swizzledType);
}
+ (id)zht_dictionary {
    
    id result = [self zht_dictionary];
    return result;
}


@end
