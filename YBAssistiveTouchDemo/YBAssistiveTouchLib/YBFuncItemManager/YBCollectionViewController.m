//
//  YBCollectionViewController.m
//  ZYSuspensionViewDemo
//
//  Created by 王迎博 on 2018/3/7.
//  Copyright © 2018年 ripper. All rights reserved.
//

#import "YBCollectionViewController.h"
#import "YBSuspensionManager.h"
#import "YBFuncItemManager.h"

CGFloat perFuncItem_w = 70;

#pragma mark ----------YBFuncItemCollectionViewCell----------
@interface YBFuncItemCollectionViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YBFuncItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.layer.cornerRadius = perFuncItem_w/2;
        imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:imageView];
        //imageView.backgroundColor = [self randomColor];
        self.iconImageView = imageView;
        
        UILabel *titleLB = [[UILabel alloc]init];
        titleLB.font = [UIFont systemFontOfSize:14.5f];
        titleLB.textColor = [UIColor grayColor];
        titleLB.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLB];
        self.titleLabel = titleLB;
    }
    return self;
}

- (void)configCellWithData:(YBItemDataModel *)data
{
    if (data.iconImage) {
       self.iconImageView.image = data.iconImage;
    }else {
        self.iconImageView.backgroundColor = [self randomColor];
    }
    
    self.titleLabel.text = data.title;
}

- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(self.contentView.frame.size.width/2 - perFuncItem_w/2, 0, perFuncItem_w, perFuncItem_w);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.iconImageView.frame)+10, self.contentView.frame.size.width, self.frame.size.height - CGRectGetHeight(self.iconImageView.frame)-10);
}
@end


#pragma mark ----------YBCollectionViewController----------
@interface YBCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *cancelView;

@property (nonatomic, assign, getter=isCancelStatus) BOOL cancelStatus;

@end
@implementation YBCollectionViewController

CGFloat yb_FuncAnimationValue = 0.05;
static NSString *funcItemCollectionViewCellId = @"YBFuncItemCollectionViewCellId";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
    //毛玻璃
    UIBlurEffect *blurEffect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView=[[UIVisualEffectView alloc]initWithEffect:blurEffect];
    [visualEffectView setFrame:self.view.bounds];
    [self.view addSubview:visualEffectView];
    
    
    
    self.backView.hidden = NO;
    self.collectionView.hidden = NO;
    self.cancelView.hidden = NO;
    //[self.cancelButton d3_setRotate:180 duration:yb_FuncAnimationValue*self.dataArray.count+0.1 completion:nil];
}
#pragma mark - lazy

- (UIView *)backView
{
    if (!_backView) {
        //UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCollectionViewController)];
        UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
        backView.userInteractionEnabled = YES;
        //[backView addGestureRecognizer:tgr];
        [self.view addSubview:backView];
        _backView = backView;
    }
    return _backView;
}
- (UICollectionView *)collectionView
{
    if (_collectionView) {
        return _collectionView;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200.f);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:1. alpha:0.];
    // 解决CollectionView的内容小于它的高度不能滑动的问题
    collectionView.alwaysBounceVertical = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollEnabled = NO;
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    
    [collectionView registerClass:[YBFuncItemCollectionViewCell class] forCellWithReuseIdentifier:funcItemCollectionViewCellId];
    
    return _collectionView;
}

- (UIView *)cancelView
{
    if (_cancelView) {
        return _cancelView;
    }
    
    _cancelView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    [self.view addSubview:_cancelView];
    
    
    UIButton *cancelButton;
    cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0.5, self.view.frame.size.width, 44.5)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_cancelView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(closeTheCollectionViewControllerClick:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = cancelButton;
    
    return _backView;
}


#pragma mark - private methods
- (void)refresh
{
    [self setupData];
    
    [self.collectionView reloadData];
}

- (void)setupData
{
    if ([YBFuncItemManager shareInstance].dataArray) {
        self.dataArray = [YBFuncItemManager shareInstance].dataArray;
    }
}

- (void)closeTheCollectionViewControllerClick:(UIButton *)sender
{
    self.cancelStatus = YES;
    [self.collectionView reloadData];
    
    [self closeCollectionViewControllerWithCompletion:nil];

//    [sender d3_setRotate:180 duration:yb_FuncAnimationValue*self.dataArray.count+0.1 completion:^{
//    }];
    
}

- (void)closeCollectionViewController
{
    //[YBSuspensionManager destroyWindowForKey:kYBFuncItemCollectionViewControllerKey];
    [YBFuncItemManager closeCollectionViewController];
}

- (void)closeCollectionViewControllerWithCompletion:(void(^)())completion
{
    //[YBSuspensionManager destroyWindowForKey:kYBFuncItemCollectionViewControllerKey];
    [YBFuncItemManager closeCollectionViewControllerWithCompletion:^{
        if (completion) {
            completion();
        }
    }];
}

- (void)addAlertAnimation
{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.3;
    bounceAnimation.removedOnCompletion = NO;
    [self.collectionView.layer addAnimation:bounceAnimation forKey:nil];
}

- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return 5;
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBFuncItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:funcItemCollectionViewCellId forIndexPath:indexPath];
    
    YBItemDataModel *dataModel = self.dataArray[indexPath.row];
    [cell configCellWithData:dataModel];
    
    if (!self.isCancelStatus) {
        CGPoint center = cell.center;
        CGPoint startCenter = center;
        startCenter.y += CGRectGetMaxY(collectionView.frame);
        cell.center = startCenter;
        
        [UIView animateWithDuration: 0.5 delay: yb_FuncAnimationValue * indexPath.item usingSpringWithDamping: 0.65 initialSpringVelocity:1 options: UIViewAnimationOptionCurveLinear animations: ^{
            cell.center = center;
        } completion: nil];
    }else {
        CGPoint center = cell.center;
        
        [UIView animateWithDuration: 0.5 delay: yb_FuncAnimationValue*(self.dataArray.count - indexPath.item) usingSpringWithDamping: 0.65 initialSpringVelocity:1 options: UIViewAnimationOptionCurveLinear animations: ^{
            CGPoint startCenter = center;
            startCenter.y += CGRectGetMaxY(collectionView.frame);
            cell.center = startCenter;
        } completion: nil];
    }
    
    return cell;
    
}

# pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //YBFuncItemCollectionViewCell *cell = (YBFuncItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    YBItemDataModel *dataModel = self.dataArray[indexPath.row];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (dataModel.Handler) {
            dataModel.Handler(indexPath.row);
        }
    });
    
    [self closeCollectionViewControllerWithCompletion:^{
    }];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //YBFuncItemCollectionViewCell *newCell = (YBFuncItemCollectionViewCell *)cell;
    
}


# pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize gerneralSize;
    gerneralSize = CGSizeMake(([UIApplication sharedApplication].keyWindow.bounds.size.width - 44*2 - perFuncItem_w*3)/4 + perFuncItem_w, 100);
    return gerneralSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets;
    
    CGFloat left = 40 - ([UIApplication sharedApplication].keyWindow.bounds.size.width - 44*2 - perFuncItem_w*3)/4;//44
    insets = UIEdgeInsetsMake(200,left,0,left);
    
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 35;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

@end
