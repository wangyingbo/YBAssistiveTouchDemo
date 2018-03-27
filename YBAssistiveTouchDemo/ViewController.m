//
//  ViewController.m
//  YBAssistiveTouchDemo
//
//  Created by 王迎博 on 2018/3/27.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import "ViewController.h"
#import "YBFuncItemManager.h"
#import "YBTestViewController.h"


@interface ViewController ()
@property (nonatomic, strong) YBFuncItemViewModel *itemTool;
@end

@implementation ViewController

- (YBFuncItemViewModel *)itemTool
{
    if (_itemTool) {
        return _itemTool;
    }
    _itemTool = [[YBFuncItemViewModel alloc]init];
    return _itemTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self selector1];
    
    [self selector2];
}

/**
 加到view上，受vc生命周期影响
 */
- (void)selector1
{
    __weak typeof(self)weakSelf = self;
    YBItemDataModel *model1 = [YBItemDataModel createModelImage:[UIImage imageNamed:@"180_180"] title:@"item1" handler:^(NSInteger index) {
        NSLog(@"点击了第%ld个",(long)index);
        YBTestViewController *testViewController = [[YBTestViewController alloc] init];
        [weakSelf.navigationController pushViewController:testViewController animated:YES];
    }];
    YBItemDataModel *model2 = [YBItemDataModel createModelImage:nil title:@"item2" handler:^(NSInteger index) {
        NSLog(@"点击了第%ld个",(long)index);
    }];
    YBItemDataModel *model3 = [YBItemDataModel createModelImage:nil title:@"item2" handler:^(NSInteger index) {
        NSLog(@"点击了第%ld个",(long)index);
    }];
    YBItemDataModel *model4 = [YBItemDataModel createModelImage:nil title:@"item2" handler:^(NSInteger index) {
        NSLog(@"点击了第%ld个",(long)index);
    }];
    YBItemDataModel *model5 = [YBItemDataModel createModelImage:nil title:@"item2" handler:^(NSInteger index) {
        NSLog(@"点击了第%ld个",(long)index);
    }];
    
    [self.itemTool yb_showSuspensionViewWithDataArray:@[model1,model2,model3,model4,model5] toView:self.view];
}


/**
 加到自定义的window上，始终显示，不受vc影响
 */
- (void)selector2
{
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:5.];
    for (int i = 0; i<5; i++) {
        __weak typeof(self)weakSelf = self;
        YBItemDataModel *model = [YBItemDataModel createModelImage:nil title:[NSString stringWithFormat:@"func%d",i] handler:^(NSInteger index) {
            NSLog(@"点击了第%ld个",(long)index);
            YBTestViewController *testViewController = [[YBTestViewController alloc] init];
            [weakSelf.navigationController pushViewController:testViewController animated:YES];
        }];
        [mutArr addObject:model];
    }
    
    [YBFuncItemManager showSuspensionViewWithDataArray:mutArr.copy];
}

@end
