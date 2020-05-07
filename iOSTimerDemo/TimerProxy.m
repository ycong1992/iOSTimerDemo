//
//  TimerProxy.m
//  iOSTimerDemo
//
//  Created by 谢跃聪 on 2020/5/7.
//  Copyright © 2020 yc. All rights reserved.
//

#import "TimerProxy.h"

@interface TimerProxy ()

@property (weak, nonatomic) id target;  // 弱引用，解开闭环

@end

@implementation TimerProxy

+ (instancetype)proxyWihtTarger:(id)target {
    // NSProxy只需要alloc，它不需要init，也没有init方法
    TimerProxy *proxy = [TimerProxy alloc];
    proxy.target = target;
    
    return proxy;
}

// NSProxy和NSObject执行方法的不同点在于，NSProxy只会在它类本身找，找不到就直接进行消息重定向(手动生成方法签名并转发)
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
