//
//  SecViewController.m
//  iOSTimerDemo
//
//  Created by 谢跃聪 on 2020/5/7.
//  Copyright © 2020 yc. All rights reserved.
//

#import "SecViewController.h"
#import "TimerProxy.h"
#import "GCDTimer.h"

@interface SecViewController ()

@property (strong, nonatomic) NSTimer *timer;

@property (copy, nonatomic) NSString *taskName;

@end

@implementation SecViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // 解决循环引用方法1
//    __weak typeof(self) weakSelf = self;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf timerTest];
//    }];
    
    // 解决循环引用方法2
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[TimerProxy proxyWihtTarger:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    // 设计一个基于系统内核的准时定时器————CGD定时器
//    self.taskName = [GCDTimer execTask:^{
//        NSLog(@"_%@_111", [NSThread currentThread]);
//    } start:2.0 interval:1.0 repeats:YES async:NO];
    
    self.taskName = [GCDTimer execTask:self selector:@selector(doTest) start:2.0 interval:1.0 repeats:YES async:NO];
}

- (void)doTest {
    NSLog(@"%s", __func__);
}

- (void)timerTest {
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [_timer invalidate];
    [GCDTimer cancelTask:self.taskName];
}

@end
