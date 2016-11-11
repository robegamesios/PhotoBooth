//
//  BaseView.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 11/10/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseViewController;

@interface BaseView : UIView

@property (strong, nonatomic) UIViewController *parentViewController;

- (void)showFontSelectorWithCompletionHandler:(SuccessBlock)completionHandler;

- (void)showColorPickerWithCompletionHanlder:(SuccessBlock)successHandler;

@end
