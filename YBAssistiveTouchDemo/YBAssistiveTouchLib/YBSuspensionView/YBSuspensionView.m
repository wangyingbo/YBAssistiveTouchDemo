//
//  YBSuspensionView.m
//  YBSuspensionView
//
//  GitHub  
//  Created by wangyingbo on 16-02-25.
//  Copyright (c) 2016年 wangyingbo. All rights reserved.
//

#import "YBSuspensionView.h"
#import "NSObject+YBSuspensionView.h"
#import "YBSuspensionManager.h"

//#define kLeanProportion (-0.2)//(8/55.0)
//#define kVerticalMargin 0.//15.0

@implementation YBSuspensionContainer
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = 1000000;
        self.clipsToBounds = YES;
    }
    return self;
}
@end

@implementation YBSuspensionViewController
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
@end


@interface YBSuspensionView ()
{
    
}
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign, getter=isHaveAnimation) BOOL haveAnimation;
@end


@implementation YBSuspensionView

/**水平方向距边界的间隔倍率*/
CGFloat kLeanProportion = 0.;
/**竖直方向距边界的间隔*/
CGFloat kVerticalMargin = 0.;
CGFloat kBorderLineW = 0.;

CGFloat suspensionViewAlpha = 0.7;

+ (instancetype)defaultSuspensionViewWithDelegate:(id<YBSuspensionViewDelegate>)delegate
{
    YBSuspensionView *sus = [[YBSuspensionView alloc] initWithFrame:CGRectMake(-kLeanProportion * 55, 100, 55, 55)
                                                              color:[UIColor colorWithRed:0.21f green:0.45f blue:0.88f alpha:1.00f]
                                                           delegate:delegate];
    return sus;
}

+ (CGFloat)suggestXWithWidth:(CGFloat)width
{
    return - width * kLeanProportion;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                         color:[UIColor colorWithRed:0.21f green:0.45f blue:0.88f alpha:1.00f]
                      delegate:nil];
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color delegate:(id<YBSuspensionViewDelegate>)delegate
{
    if(self = [super initWithFrame:frame])
    {
        self.delegate = delegate;
        self.userInteractionEnabled = YES;
        self.backgroundColor = color;
        self.alpha = .1;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = kBorderLineW;
        //self.clipsToBounds = YES;
        self.originalCenter = CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
        self.addedWindow = YES;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        pan.delaysTouchesBegan = YES;
        [self addGestureRecognizer:pan];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - event response
- (void)handlePanGesture:(UIPanGestureRecognizer*)p
{
    
    UIWindow *appWindow = [UIApplication sharedApplication].delegate.window;
    CGPoint panPoint = [p locationInView:appWindow];
    
    if(p.state == UIGestureRecognizerStateBegan) {
        self.alpha = self.isCancelMove?suspensionViewAlpha:1.0;
        if (self.isHaveAnimation) {
            [self RemoveAniamtionLikeGameCenterBubble];
        }
    }else if(p.state == UIGestureRecognizerStateChanged) {
        if (self.isAddedWindow) {
            [YBSuspensionManager windowForKey:self.YB_md5Key].center = CGPointMake(panPoint.x, panPoint.y);
        }else {
            self.center = CGPointMake(panPoint.x, panPoint.y);
        }
        
    }else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        self.alpha = suspensionViewAlpha;
        
        CGFloat ballWidth = self.frame.size.width;
        CGFloat ballHeight = self.frame.size.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(screenWidth - left);
        CGFloat top = fabs(panPoint.y);
        CGFloat bottom = fabs(screenHeight - top);
        
        CGFloat minSpace = 0;
        if (self.leanType == YBSuspensionViewLeanTypeHorizontal) {
            minSpace = MIN(left, right);
        }else{
            minSpace = MIN(MIN(MIN(top, left), bottom), right);
        }
        CGPoint newCenter = CGPointZero;
        CGFloat targetY = 0;
        
        //Correcting Y
        if (panPoint.y < kVerticalMargin + ballHeight / 2.0) {
            targetY = kVerticalMargin + ballHeight / 2.0;
        }else if (panPoint.y > (screenHeight - ballHeight / 2.0 - kVerticalMargin)) {
            targetY = screenHeight - ballHeight / 2.0 - kVerticalMargin;
        }else{
            targetY = panPoint.y;
        }
        
        CGFloat centerXSpace = (0.5 - kLeanProportion) * ballWidth;
        CGFloat centerYSpace = (0.5 - kLeanProportion) * ballHeight;

        if (minSpace == left) {
            newCenter = CGPointMake(centerXSpace, targetY);
        }else if (minSpace == right) {
            newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
        }else if (minSpace == top) {
            newCenter = CGPointMake(panPoint.x, centerYSpace);
        }else {
            newCenter = CGPointMake(panPoint.x, screenHeight - centerYSpace);
        }
        
        [UIView animateWithDuration:.25 animations:^{
            if (self.isAddedWindow) {
                [YBSuspensionManager windowForKey:self.YB_md5Key].center = newCenter;
            }else {
                self.center = newCenter;
            }
            
        } completion:^(BOOL finished) {
            if (self.isHaveAnimation) {
                [self addAniamtionLikeGameCenterBubble];
            }
        }];
        
        
        if (self.isCancelMove) {
            self.alpha = 1;
            [UIView animateWithDuration:.25 animations:^{
                if (self.isAddedWindow) {
                    [YBSuspensionManager windowForKey:self.YB_md5Key].center = self.originalCenter;
                }else {
                    self.center = self.originalCenter;
                }
            } completion:^(BOOL finished) {
                if (self.isHaveAnimation) {
                    [self addAniamtionLikeGameCenterBubble];
                }
            }];
        }
        
        
    }else{
        NSLog(@"pan state : %zd", p.state);
    }
}

- (void)click
{
    if([self.delegate respondsToSelector:@selector(suspensionViewClick:)])
    {
        [self.delegate suspensionViewClick:self];
    }
}

#pragma mark - public methods
- (void)show
{
    if ([YBSuspensionManager windowForKey:self.YB_md5Key]) return;
    
    UIWindow *currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    YBSuspensionContainer *backWindow = [[YBSuspensionContainer alloc] initWithFrame:self.frame];
    backWindow.rootViewController = [[YBSuspensionViewController alloc] init];
    [backWindow makeKeyAndVisible];
    [YBSuspensionManager saveWindow:backWindow forKey:self.YB_md5Key];

    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.layer.cornerRadius = self.frame.size.width <= self.frame.size.height ? self.frame.size.width / 2.0 : self.frame.size.height / 2.0;
    [backWindow addSubview:self];
    
    if (self.isCancelMove) {
        self.alpha = 1.;
        self.originalCenter = backWindow.center;
    }
    // Keep the original keyWindow and avoid some unpredictable problems
    [currentKeyWindow makeKeyWindow];
}

- (void)removeFromScreen
{
    [YBSuspensionManager destroyWindowForKey:self.YB_md5Key];
}

- (void)hiddenFromScreen:(BOOL)hidden
{
    [YBSuspensionManager windowForKey:self.YB_md5Key].hidden = hidden;
}

- (void)showFromScreen
{
    [YBSuspensionManager windowForKey:self.YB_md5Key].hidden = NO;
}


- (void)setAnimation:(BOOL)animation
{
    if (animation) {
        [self addAniamtionLikeGameCenterBubble];
    }
    self.haveAnimation = animation;
}

//---- 类似GameCenter的气泡晃动动画 ------
-(void)addAniamtionLikeGameCenterBubble {
    
    YBSuspensionContainer *backWindow = (YBSuspensionContainer *)[YBSuspensionManager windowForKey:self.YB_md5Key];
    UIView *animationView = backWindow;
    animationView = self.isAddedWindow ? backWindow : self;
    
    if (animationView) {
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.repeatCount = INFINITY;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        pathAnimation.duration = 5.0;
        
        CGMutablePathRef curvedPath = CGPathCreateMutable();
        CGRect circleContainer = CGRectInset(animationView.frame, animationView.bounds.size.width / 2 - 3, animationView.bounds.size.width / 2 - 3);
        CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
        
        pathAnimation.path = curvedPath;
        CGPathRelease(curvedPath);
        [animationView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
        
        CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        scaleX.duration = 1;
        scaleX.values = @[@1.0, @1.1, @1.0];
        scaleX.keyTimes = @[@0.0, @0.5, @1.0];
        scaleX.repeatCount = INFINITY;
        scaleX.autoreverses = YES;
        
        scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animationView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
        
        
        CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
        scaleY.duration = 1.5;
        scaleY.values = @[@1.0, @1.1, @1.0];
        scaleY.keyTimes = @[@0.0, @0.5, @1.0];
        scaleY.repeatCount = INFINITY;
        scaleY.autoreverses = YES;
        scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animationView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
    }
    
}

-(void)RemoveAniamtionLikeGameCenterBubble {
    YBSuspensionContainer *backWindow = (YBSuspensionContainer *)[YBSuspensionManager windowForKey:self.YB_md5Key];
    UIView *animationView = self.isAddedWindow ? backWindow : self;
    
    if (animationView) {
        [animationView.layer removeAllAnimations];
    }
}

#pragma mark - getter
- (YBSuspensionContainer *)containerWindow
{
    return (YBSuspensionContainer *)[YBSuspensionManager windowForKey:self.YB_md5Key];
}

@end
