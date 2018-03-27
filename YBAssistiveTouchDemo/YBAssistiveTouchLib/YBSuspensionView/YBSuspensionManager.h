//
//  YBSuspensionManager.h
//  YBSuspensionView
//
//  GitHub  
//  Created by wangyingbo on 16/7/19.
//  Copyright © 2016年 wangyingbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YBSuspensionManager : NSObject

+ (instancetype)shared;

/**
 *  Get UIWindow based on key value
 *
 *  @param key key
 *
 *  @return window
 */
+ (UIWindow *)windowForKey:(NSString *)key;

/**
 *  Save a window and set the key
 *
 *  @param window window
 *  @param key    key
 */
+ (void)saveWindow:(UIWindow *)window forKey:(NSString *)key;

/**
 *  Destroy a window according to key
 *
 *  @param key       key
 */
+ (void)destroyWindowForKey:(NSString *)key;

/**
 *  Destroy all window
 */
+ (void)destroyAllWindow;

@end
