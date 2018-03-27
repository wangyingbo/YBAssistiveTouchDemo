//
//  YBCollectionViewController.h
//  ZYSuspensionViewDemo
//
//  Created by 王迎博 on 2018/3/7.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBFuncItemManager.h"



#pragma mark ----------YBFuncItemCollectionViewCell----------
@interface YBFuncItemCollectionViewCell : UICollectionViewCell

- (void)configCellWithData:(YBItemDataModel *)data;

@end



#pragma mark ----------YBCollectionViewController----------
static NSString *const kYBFuncItemCollectionViewControllerKey = @"kYBFuncItemCollectionViewControllerKey";

@interface YBCollectionViewController : UIViewController
@property (nonatomic, strong) NSArray *dataArray;
- (void)refresh;
@end
