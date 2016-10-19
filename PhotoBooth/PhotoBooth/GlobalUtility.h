//
//  GlobalUtility.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/16/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"
@import UIKit;

#pragma mark - Typedefs

typedef void(^VoidBlock)(void);
typedef void(^SuccessBlock)(id responseObject);
typedef void(^TwoResultBlock)(id obj1, id obj2);
typedef void(^TwoIntResultBlock)(int obj1, int obj2);
typedef void(^ErrorBlock)(NSString *errorString);

@interface GlobalUtility : NSObject

+ (void)showAlertFromViewController:(UINavigationController *)navigationController title:(NSString *)title message:(NSString *)message completionHandler:(VoidBlock)completionHandler;

+ (void)showConfirmAlertFromViewController:(UINavigationController *)navigationController title:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(VoidBlock)completionHandler;

+ (void)showAlert:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message completionHandler:(VoidBlock)completionHandler;

+ (BOOL)isConnected;

@end
