//
//  YBFuncItemManager.h
//  ZYSuspensionViewDemo
//
//  Created by 王迎博 on 2018/3/7.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class YBSuspensionView;


#pragma mark ----------YBItemDataModel----------
@interface YBItemDataModel : NSObject

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^Handler)(NSInteger index);

+ (YBItemDataModel *)createModelImage:(UIImage *)iconImage title:(NSString *)title handler:(void(^)(NSInteger index))handler;

@end


#pragma mark ----------YBFuncItemViewModel----------
@interface YBFuncItemViewModel : NSObject

/***/
@property (nonatomic, copy) NSArray *dataArray;

#pragma mark - 不加到window上，加到containerView上
- (void)yb_showSuspensionViewToView:(UIView *)containerView;

- (void)yb_showSuspensionViewWithDataArray:(NSArray *)dataArray toView:(UIView *)containerView;

- (void)yb_removeSuspensionView;

- (YBSuspensionView *)yb_getSuspensionView;

- (void)yb_refreshDataArray:(NSArray *)dataArray;


@end

#pragma mark ----------YBFuncItemManager----------
@interface YBFuncItemManager : NSObject
/***/
@property (nonatomic, copy) NSArray *dataArray;
/** Controller for displaying test items */
@property (nonatomic, weak, readonly) UIViewController *collectionViewController;

/**
 Get single object
 
 @return single object
 */
+ (instancetype)shareInstance;

/**
 Display test suspensionView (release mode won't show)
 */
+ (void)showSuspensionView;

+ (void)showSuspensionViewWithDataArray:(NSArray *)dataArray;

/**
 Remove test suspensionView
 */
+ (void)removeSuspensionView;

+ (YBSuspensionView *)getSuspensionView;

+ (void)hiddenSuspensionView:(BOOL)hidden;

/**
 设置数据源

 @param array array description
 */
+ (void)setupItemDataArray:(NSArray *)array;

/**
 Close test list
 */
+ (void)closeCollectionViewController;
+ (void)closeCollectionViewControllerWithCompletion:(void(^)())completion;


@end
