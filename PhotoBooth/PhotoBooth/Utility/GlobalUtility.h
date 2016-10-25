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

@interface GlobalUtility : NSObject

+ (void)showAlertFromNavigationController:(UINavigationController *)navigationController title:(NSString *)title message:(NSString *)message completionHandler:(VoidBlock)completionHandler;

+ (void)showConfirmAlertFromNavigationController:(UINavigationController *)navigationController title:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(VoidBlock)completionHandler;

+ (void)showAlertFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message completionHandler:(VoidBlock)completionHandler;

+ (void)showConfirmAlertFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(VoidBlock)completionHandler;

+ (UIImage *)rotateImage:(UIImage *)image rotation:(UIImageOrientation)orientation;

+ (UIImage *)rotateAndMirrorImage:(UIImage *)image rotation:(UIImageOrientation)orientation;

+(UIImage *)resizedImage:(UIImage *)image width:(int)width height:(int)height;

+ (UIImage *)takeScreenshot:(UIView *)wholeScreen;

+ (void)saveToCameraRoll:(UIImage *)screenShot;

+ (BOOL)isConnected;

+ (void)saveImageToRealm:(UIImage *)image screenType:(ScreenType)screenType;

+ (NSArray *)retrieveAllImages:(ScreenType)screenType;

@end
