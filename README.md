# YBAssistiveTouchDemo

### 类似iOS原生小白点的功能模块

+ 可以直接加到view上，其生命周期受viewController的生命周期管理；

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



+ 可以使用我封装好的window层，使小白点可以全局展示，不受vc层级影响，一直显示在程序窗口；


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



![图片](https://raw.githubusercontent.com/wangyingbo/YBAssistiveTouchDemo/master/gif.gif)