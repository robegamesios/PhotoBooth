//
//  GlobalUtility.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/16/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "GlobalUtility.h"

@implementation GlobalUtility

#pragma mark - Alert Controller Messages

+ (void)showAlertFromNavigationController:(UINavigationController *)navigationController title:(NSString *)title message:(NSString *)message completionHandler:(VoidBlock)completionHandler {

    UIAlertController *alert=   [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             if (completionHandler) {
                                 completionHandler();
                             }

                         }];

    [alert addAction:ok];

    [navigationController presentViewController:alert animated:YES completion:nil];
}

+ (void)showConfirmAlertFromNavigationController:(UINavigationController *)navigationController title:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(VoidBlock)completionHandler {

    UIAlertController *alert=   [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:confirmButtonTitle
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if (completionHandler) {
                                 completionHandler();
                             }
                             [alert dismissViewControllerAnimated:YES completion:nil];

                         }];

    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:cancelButtonTitle
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];

                             }];

    [alert addAction:ok];
    [alert addAction:cancel];
    
    [navigationController presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message completionHandler:(VoidBlock)completionHandler {

    UIAlertController *alert=   [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];

                             if (completionHandler) {
                                 completionHandler();
                             }
                         }];

    [alert addAction:ok];

    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showConfirmAlertFromViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle completionHandler:(VoidBlock)completionHandler {

    UIAlertController *alert=   [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:confirmButtonTitle
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if (completionHandler) {
                                 completionHandler();
                             }
                             [alert dismissViewControllerAnimated:YES completion:nil];

                         }];

    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:cancelButtonTitle
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];

                             }];

    [alert addAction:ok];
    [alert addAction:cancel];

    [viewController presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Photo methods

+ (UIImage *)rotateImage:(UIImage *)image rotation:(UIImageOrientation)orientation {

    UIImage * newImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                                    scale: 1.0
                                              orientation: orientation];

    return newImage;
}

+ (UIImage *)rotateAndMirrorImage:(UIImage *)image rotation:(UIImageOrientation)orientation {

    UIImageOrientation mirroredOrientation = 0;

    switch (orientation) {
        case UIImageOrientationUp:
            mirroredOrientation = UIImageOrientationUpMirrored;
            break;

        case UIImageOrientationDown:
            mirroredOrientation = UIImageOrientationDownMirrored;
            break;

        case UIImageOrientationLeft:
            mirroredOrientation = UIImageOrientationLeftMirrored;
            break;

        case UIImageOrientationRight:
            mirroredOrientation = UIImageOrientationRightMirrored;
            break;

        default:
            break;
    }
    UIImage * newImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                                    scale: 1.0
                                              orientation: orientation];

    UIImage* flippedImage = [UIImage imageWithCGImage:newImage.CGImage
                                                scale:newImage.scale
                                          orientation:mirroredOrientation];
    
    return flippedImage;
}

+(UIImage *)resizedImage:(UIImage *)image width:(int)width height:(int)height {

    int newWidth = width * 72;
    int newHeight = height * 72;
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0,0,newWidth, newHeight)];
    UIImage *resizedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImg;
}

+ (UIImage *)takeScreenshot:(UIView *)wholeScreen {
    UIGraphicsBeginImageContextWithOptions(wholeScreen.bounds.size, wholeScreen.opaque, 0.0);
    [wholeScreen drawViewHierarchyInRect:wholeScreen.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return snapshotImage;
}

+ (void)saveToCameraRoll:(UIImage *)screenShot {
    // save screengrab to Camera Roll
    UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil);
}

+ (BOOL)isConnected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
