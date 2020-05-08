//
//  GCDTimer.m
//  iOSTimerDemo
//
//  Created by 谢跃聪 on 2020/5/7.
//  Copyright © 2020 yc. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer ()

@end

@implementation GCDTimer

static NSMutableDictionary *timers_;
dispatch_semaphore_t semaphore_;    // 对字典操作加锁，防止多线程操作时出错

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)execTask:(void(^)(void))task
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    
    if (!task || start < 0 || (interval <= 0 && repeats)) return nil;
        
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, start * NSEC_PER_SEC, interval * NSEC_PER_SEC);
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    NSString *name = [NSString stringWithFormat:@"%zd", timers_.count];
    timers_[name] = timer;
    dispatch_semaphore_signal(semaphore_);
    
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    
    dispatch_resume(timer);
    
    
    return name;
}

+ (NSString *)execTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    if (!target || !selector) return nil;
    
    return [self execTask:^{
        if ([target respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
        #pragma clang diagnostic pop
        }
    } start:start interval:interval repeats:repeats async:async];
}

+ (void)cancelTask:(NSString*)name {
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    if (name && name.length > 0 && timers_.count && [timers_.allKeys containsObject:name]) {
        dispatch_source_cancel(timers_[name]);
        [timers_ removeObjectForKey:name];
    }
    dispatch_semaphore_signal(semaphore_);
}

@end
