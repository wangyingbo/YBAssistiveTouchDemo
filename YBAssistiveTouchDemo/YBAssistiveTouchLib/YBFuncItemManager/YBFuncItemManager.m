//
//  YBFuncItemManager.m
//  ZYSuspensionViewDemo
//
//  Created by 王迎博 on 2018/3/7.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "YBFuncItemManager.h"
#import "YBSuspensionView.h"
#import "YBSuspensionManager.h"
#import "YBCollectionViewController.h"


#pragma mark ----------YBItemDataModel----------
@implementation YBItemDataModel

+ (YBItemDataModel *)createModelImage:(UIImage *)iconImage title:(NSString *)title handler:(void (^)(NSInteger))handler
{
    YBItemDataModel *dataModel = [[YBItemDataModel alloc]init];
    dataModel.iconImage = iconImage;
    dataModel.title = title;
    dataModel.Handler = handler;
    
    return dataModel;
}

@end

#pragma mark ----------YBFuncItemViewModel----------

@interface YBFuncItemViewModel ()<YBSuspensionViewDelegate>

@property (nonatomic, weak) YBSuspensionView *susView;
@end
@implementation YBFuncItemViewModel

CGFloat suspensionView_w_h = 50;
extern CGFloat suspensionViewAlpha;

//pragma mark - 不加到window上，加到containerView上
- (void)yb_showSuspensionViewToView:(UIView *)containerView
{
    CGFloat margin = 30;
    //origin.x可用[YBSuspensionView suggestXWithWidth:100]方法
    YBSuspensionView *susView = [[YBSuspensionView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - margin/2 - suspensionView_w_h, [UIScreen mainScreen].bounds.size.height - margin - suspensionView_w_h, suspensionView_w_h, suspensionView_w_h) color:[UIColor clearColor] delegate:self];
    susView.leanType = YBSuspensionViewLeanTypeEachSide;
    susView.cancelMove = YES;
    susView.layer.cornerRadius = suspensionView_w_h/2;
    susView.alpha = 1.;
    [susView setBackgroundImage:[UIImage imageNamed:@"multiselect_confirm_button_icon"] forState:UIControlStateNormal];
    susView.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 3.5, 0);
    [susView setTitle:@"ADD" forState:UIControlStateNormal];
    susView.addedWindow = NO;
    [containerView addSubview:susView];
    [susView setAnimation:YES];
    self.susView = susView;
    
}

- (void)suspensionViewClick:(YBSuspensionView *)suspensionView
{
    if ([YBSuspensionManager windowForKey:kYBFuncItemCollectionViewControllerKey]) {
        [YBSuspensionManager destroyWindowForKey:kYBFuncItemCollectionViewControllerKey];
    }else{
        UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
        YBCollectionViewController *collectionViewVC = [[YBCollectionViewController alloc] init];
        YBSuspensionContainer *window = [[YBSuspensionContainer alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.rootViewController = collectionViewVC;
        window.windowLevel -= 1;
        [window makeKeyAndVisible];
        [YBSuspensionManager saveWindow:window forKey:kYBFuncItemCollectionViewControllerKey];
        [currentKeyWindow makeKeyWindow];
        
        collectionViewVC.dataArray = self.dataArray;
        
    }
    
    
}

- (void)yb_showSuspensionViewWithDataArray:(NSArray *)dataArray toView:(UIView *)containerView
{
    [self yb_showSuspensionViewToView:containerView];
    
    self.dataArray = dataArray;
}

- (void)yb_removeSuspensionView
{
}

- (YBSuspensionView *)yb_getSuspensionView
{
    return self.susView;
}

- (void)yb_refreshDataArray:(NSArray *)dataArray
{
    self.dataArray = dataArray;
}

@end


#pragma mark ----------YBFuncItemManager----------
@interface YBFuncItemManager ()<YBSuspensionViewDelegate>

@property (nonatomic, weak) YBSuspensionView *susView;
@property (nonatomic, weak, nullable) UIViewController *collectionViewController;

@end

@implementation YBFuncItemManager

static YBFuncItemManager *_instance;

+ (instancetype)shareInstance
{
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[YBFuncItemManager alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


#pragma mark - API

+ (void)showSuspensionView
{
    if ([YBFuncItemManager shareInstance].susView) {
        [[YBFuncItemManager shareInstance].susView removeFromScreen];
    }
    
    CGFloat margin = 30;
    //origin.x可用[YBSuspensionView suggestXWithWidth:100]方法
    YBSuspensionView *susView = [[YBSuspensionView alloc] initWithFrame:CGRectMake( [YBSuspensionView suggestXWithWidth:margin], margin*1.5, suspensionView_w_h, suspensionView_w_h) color:[UIColor colorWithRed:0.97 green:0.30 blue:0.30 alpha:1.00] delegate:[YBFuncItemManager shareInstance]];
    susView.leanType = YBSuspensionViewLeanTypeEachSide;
    susView.cancelMove = NO;
    susView.alpha = suspensionViewAlpha;
    susView.addedWindow = YES;
    //[susView setImage:[UIImage imageNamed:@"assistive_bg_image"] forState:UIControlStateNormal];
    [susView setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [susView setTitle:@"全局" forState:UIControlStateNormal];
    [susView show];
    [susView setAnimation:YES];
    [YBFuncItemManager shareInstance].susView = susView;
    
}

+ (void)showSuspensionViewWithDataArray:(NSArray *)dataArray
{
    [self showSuspensionView];
    
    [self setupItemDataArray:dataArray];
}

+ (YBSuspensionView *)getSuspensionView
{
    return [YBFuncItemManager shareInstance].susView;
}

+ (void)removeSuspensionView
{
    [[YBFuncItemManager shareInstance].susView removeFromScreen];
    [YBFuncItemManager shareInstance].susView = nil;
}

+ (void)hiddenSuspensionView:(BOOL)hidden
{
    [[YBFuncItemManager shareInstance].susView hiddenFromScreen:hidden];
}

+ (void)setupItemDataArray:(NSArray *)array
{
    [YBFuncItemManager shareInstance].dataArray = array;
    
}

+ (void)closeCollectionViewController
{
    [YBSuspensionManager destroyWindowForKey:kYBFuncItemCollectionViewControllerKey];
    [YBFuncItemManager shareInstance].collectionViewController = nil;
    
    //功能collectionViewController消失时，重新变为可用
    [YBFuncItemManager shareInstance].susView.enabled = YES;
    if ([YBFuncItemManager shareInstance].susView.isAddedWindow) {
        [YBFuncItemManager shareInstance].susView.alpha = suspensionViewAlpha;
    }else {
        [YBFuncItemManager shareInstance].susView.alpha = 1.;
    }
    
}

+ (void)closeCollectionViewControllerWithCompletion:(void(^)())completion
{
    UIWindow *win = [YBSuspensionManager windowForKey:kYBFuncItemCollectionViewControllerKey];
    CGRect rect = win.frame;
    rect.origin.y = [UIApplication sharedApplication].keyWindow.bounds.size.height;
    [UIView animateWithDuration:.1 animations:^{
        win.frame = rect;
    } completion:^(BOOL finished) {
        [YBSuspensionManager destroyWindowForKey:kYBFuncItemCollectionViewControllerKey];
        [YBFuncItemManager shareInstance].collectionViewController = nil;
        //功能collectionViewController消失时，重新变为可用
        [YBFuncItemManager shareInstance].susView.enabled = YES;
        if ([YBFuncItemManager shareInstance].susView.isAddedWindow) {
            [YBFuncItemManager shareInstance].susView.alpha = suspensionViewAlpha;
        }else {
            [YBFuncItemManager shareInstance].susView.alpha = 1.;
        }
        if (completion) {
            completion();
        }
    }];
}



#pragma mark - YBSuspensionViewDelegate
- (void)suspensionViewClick:(YBSuspensionView *)suspensionView
{
    if ([YBSuspensionManager windowForKey:kYBFuncItemCollectionViewControllerKey]) {
        [YBSuspensionManager destroyWindowForKey:kYBFuncItemCollectionViewControllerKey];
        [YBFuncItemManager shareInstance].collectionViewController = nil;
    }else{
        UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
        YBCollectionViewController *collectionViewVC = [[YBCollectionViewController alloc] init];
        YBSuspensionContainer *window = [[YBSuspensionContainer alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.rootViewController = collectionViewVC;
        window.windowLevel -= 1;
        [window makeKeyAndVisible];
        [YBSuspensionManager saveWindow:window forKey:kYBFuncItemCollectionViewControllerKey];
        [currentKeyWindow makeKeyWindow];
        [YBFuncItemManager shareInstance].collectionViewController = collectionViewVC;
        
        if ([YBFuncItemManager shareInstance].susView && ![YBFuncItemManager shareInstance].susView.isAddedWindow) {
            collectionViewVC.dataArray = [YBFuncItemManager shareInstance].susView.dataArray;
        }else {
            [collectionViewVC refresh];
        }
        
    }
    
    //功能collectionViewController弹出时，变为不可用
    [YBFuncItemManager shareInstance].susView.enabled = NO;
    if ([[[YBFuncItemManager shareInstance].susView.superview class] isKindOfClass:[YBSuspensionContainer class]]) {
        [YBFuncItemManager shareInstance].susView.alpha = suspensionViewAlpha;
    }else {
        [YBFuncItemManager shareInstance].susView.alpha = 1;
    }
    
}

@end
