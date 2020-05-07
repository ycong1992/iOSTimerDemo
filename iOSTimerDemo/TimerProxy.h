//
//  TimerProxy.h
//  iOSTimerDemo
//
//  Created by 谢跃聪 on 2020/5/7.
//  Copyright © 2020 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerProxy : NSProxy

+ (instancetype)proxyWihtTarger:(id)target;

@end

NS_ASSUME_NONNULL_END
