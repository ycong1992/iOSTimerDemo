//
//  GCDTimer.h
//  iOSTimerDemo
//
//  Created by 谢跃聪 on 2020/5/7.
//  Copyright © 2020 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDTimer : NSObject

+ (NSString *)execTask:(void(^)(void))task
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

+ (NSString *)execTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

+ (void)cancelTask:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
