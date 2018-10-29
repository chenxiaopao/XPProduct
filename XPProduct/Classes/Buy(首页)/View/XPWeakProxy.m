//
//  XPWeakProxy.m
//  XPProduct
//
//  Created by 陈思斌 on 2018/9/10.
//  Copyright © 2018年 陈思斌. All rights reserved.
//

#import "XPWeakProxy.h"

@implementation XPWeakProxy
- (instancetype)initWithTarget:(id)target {
    _target = target; return self;
    
}
+ (instancetype)proxyWithTarget:(id)target {
    return [[self alloc] initWithTarget:target];
    
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
    
} - (void)forwardInvocation:(NSInvocation *)invocation {
    if ([_target respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:_target];
        
    }
    
}
- (NSUInteger)hash {
    return [_target hash];
    
}
- (Class)superclass {
    return [_target superclass];
    
}
- (Class)class {
    return [_target class];
    
}
- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
    
}
- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
    
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
    
}
- (BOOL)isProxy {
    return YES;
    
}
- (NSString *)description {
    return [_target description];
    
}
- (NSString *)debugDescription {
    return [_target debugDescription];
    
}
@end
