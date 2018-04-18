# YBAssistiveTouchDemo

### 类似iOS原生小白点的功能模块

+ 可以直接加到view上，其生命周期受viewController的生命周期管理；


		/**
		 加到view上，受vc生命周期影响
		 */
		- (void)selector1
		{
		    __weak typeof(self)weakSelf = self;
		    YBItemDataModel *model1 = [YBItemDataModel createModelImage:[UIImage imageNamed:@"func_item_icon_新增"] title:@"新增" handler:^(NSInteger index) {
		        NSLog(@"点击了第%ld个",(long)index);
		        YBTestViewController *testViewController = [[YBTestViewController alloc] init];
		        [weakSelf.navigationController pushViewController:testViewController animated:YES];
		    }];
		    YBItemDataModel *model2 = [YBItemDataModel createModelImage:[UIImage imageNamed:@"func_item_icon_编辑"] title:@"编辑" handler:^(NSInteger index) {
		        NSLog(@"点击了第%ld个",(long)index);
		    }];
		    YBItemDataModel *model3 = [YBItemDataModel createModelImage:[UIImage imageNamed:@"func_item_icon_借用"] title:@"借用" handler:^(NSInteger index) {
		        NSLog(@"点击了第%ld个",(long)index);
		    }];
		    YBItemDataModel *model4 = [YBItemDataModel createModelImage:[UIImage imageNamed:@"func_item_icon_领用"] title:@"领用" handler:^(NSInteger index) {
		        NSLog(@"点击了第%ld个",(long)index);
		    }];
		    YBItemDataModel *model5 = [YBItemDataModel createModelImage:[UIImage imageNamed:@"func_item_icon_签字"] title:@"签字" handler:^(NSInteger index) {
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



![图片](https://raw.githubusercontent.com/wangyingbo/YBAssistiveTouchDemo/master/sources/gif.gif)


<!--![screenShot1](https://raw.githubusercontent.com/wangyingbo/YBAssistiveTouchDemo/master/sources/screen_shot_1.png)

![screenShot2](https://raw.githubusercontent.com/wangyingbo/YBAssistiveTouchDemo/master/sources/screen_shot_2.png)

![screenShot3](https://raw.githubusercontent.com/wangyingbo/YBAssistiveTouchDemo/master/sources/screen_shot_3.png)-->

<img src="https://raw.githubusercontent.com/wangyingbo/YBAssistiveTouchDemo/master/sources/screen_shot_1.png" width = "299" height = "517" alt="screenShot1" align=center />

<img src="https://raw.githubusercontent.com/wangyingbo/YBAssistiveTouchDemo/master/sources/screen_shot_2.png" width = "299" height = "517" alt="screenShot2" align=center />

<img src="https://raw.githubusercontent.com/wangyingbo/YBAssistiveTouchDemo/master/sources/screen_shot_3.png" width = "299" height = "517" alt="screenShot3" align=center />
