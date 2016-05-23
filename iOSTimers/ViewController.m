//
//  ViewController.m
//  iOSTimers
//
//  Created by colin ge on 16/5/19.
//  Copyright © 2016年 gatsby xia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
//NStimer
@property (nonatomic, strong)NSTimer *scheduledTimer;
@property (nonatomic, strong)NSTimer *withTimer;
//CADisplayLink
@property (nonatomic, strong)CADisplayLink *displayLink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //这种创建方式会延迟一秒执行，且默认加入到runloop中
//    _scheduledTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    //必须要加入到runloop中
//    _withTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:_withTimer forMode:NSDefaultRunLoopMode];
    
//    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
//    _displayLink.frameInterval = 60;
//    NSLog(@"%.2f",_displayLink.duration);
//    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self startOnece];
    [self startRepet];
    
}

- (void)startOnece{
     //执行一次
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
         NSLog(@"4\n%s\n",__func__);
    });
}

- (void)startRepet{
    
    NSLog(@"%@",[NSDate date]);
      __block int count = 0;
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    __block dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚1秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"------------%@", [NSThread currentThread]);
        count++;
        if (count == 4) {
            // 取消定时器
            dispatch_cancel(timer);
            timer = nil;
        }
    });
    //启动定时器
    dispatch_resume(timer);
    
    
}

- (void)action:(id)object{
    NSLog(@"1\n%s\n%@\n",__func__,NSStringFromClass([object class]));
}

- (void)timerAction{
    NSLog(@"2\n%s\n",__func__);
}

- (void)handleDisplayLink:(id)object{
    NSLog(@"3\n%s\n%@",__func__,NSStringFromClass([object class]));
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_scheduledTimer invalidate];
    [_withTimer invalidate];
    
    [_displayLink invalidate];
    _displayLink = nil;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
