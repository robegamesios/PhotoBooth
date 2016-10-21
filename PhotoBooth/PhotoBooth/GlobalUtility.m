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

+ (BOOL)isConnected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
