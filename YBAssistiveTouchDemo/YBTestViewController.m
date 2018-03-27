//
//  YBTestViewController.m
//  YBAssistiveTouchDemo
//
//  Created by 王迎博 on 2018/3/27.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import "YBTestViewController.h"

@interface YBTestViewController ()

@end

@implementation YBTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [self randomColor];
    
    
}


- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

@end
