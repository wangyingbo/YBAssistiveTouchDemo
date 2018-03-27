//
//  YBSuspensionView.h
//  YBSuspensionView
//
//  GitHub  
//  Created by wangyingbo on 16-02-25.
//  Copyright (c) 2016年 wangyingbo. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark ----------YBSuspensionContainer----------
@interface YBSuspensionContainer : UIWindow
@end

#pragma mark ----------YBSuspensionViewController----------
@interface YBSuspensionViewController : UIViewController
@end

#pragma mark ----------YBSuspensionViewDelegate----------
@class YBSuspensionView;
@protocol YBSuspensionViewDelegate <NSObject>
/** callback for click on the YBSuspensionView */
- (void)suspensionViewClick:(YBSuspensionView *)suspensionView;
@end


/**
 可移动的方向
 */
typedef NS_ENUM(NSUInteger, YBSuspensionViewLeanType) {
    /** Can only stay in the left and right */
    YBSuspensionViewLeanTypeHorizontal,
    /** Can stay in the upper, lower, left, right */
    YBSuspensionViewLeanTypeEachSide
};


@interface YBSuspensionView : UIButton

/** 是否取消移动 */
@property (nonatomic, assign, getter=isCancelMove) BOOL cancelMove;
@property (nonatomic, assign, getter=isAddedWindow) BOOL addedWindow;
@property (nonatomic, copy) NSArray *dataArray;


/** delegate */
@property (nonatomic, weak) id<YBSuspensionViewDelegate> delegate;
/** lean type, default is YBSuspensionViewLeanTypeHorizontal */
@property (nonatomic, assign) YBSuspensionViewLeanType leanType;
/** container window */
@property (nonatomic, readonly) YBSuspensionContainer *containerWindow;

/**
 Create a default susView

 @param delegate delegate for susView
 @return obj
 */
+ (instancetype)defaultSuspensionViewWithDelegate:(id<YBSuspensionViewDelegate>)delegate;

/** Get the suggest x with width */
+ (CGFloat)suggestXWithWidth:(CGFloat)width;

/**
 Create a susView

 @param frame frame
 @param color background color
 @param delegate delegate for susView
 @return obj
 */
- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color delegate:(id<YBSuspensionViewDelegate>)delegate;

/**
 *  Show
 */
- (void)show;

/**
 *  Remove and dealloc
 */
- (void)removeFromScreen;

- (void)hiddenFromScreen:(BOOL)hidden;

/**
 设置动画

 @param animation animation description
 */
- (void)setAnimation:(BOOL)animation;

@end


