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

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
    });
}

+ (NSString *)execTask:(void(^)(void))task
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async {
    
    if (!task) return nil;
    
    NSString *name = [NSString stringWithFormat:@"%zd", timers_.count];
    
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, start * NSEC_PER_SEC, interval * NSEC_PER_SEC);
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    
    dispatch_resume(timer);
    
    timers_[name] = timer;
    
    return name;
}

+ (void)cancelTask:(NSString*)name {
    if (timers_.count && [timers_.allKeys containsObject:name]) {
        dispatch_source_cancel(timers_[name]);
        [timers_ removeObjectForKey:name];
    }
}

@end
