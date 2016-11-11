//
//  BaseViewController.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 11/10/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextPropertyView.h"
#import "EditModeView.h"
#import "SmartLabel.h"

@interface BaseViewController : UIViewController

@property (strong, nonatomic) TextPropertyView *tpv;
@property (strong, nonatomic) EditModeView *emv;

- (void)setupEditModeView;
- (void)setupTextPropertyView;
- (void)setupSmartLabel;
- (void)showPhotoPicker;
- (void)showColorPickerWithCompletionHanlder:(SuccessBlock)successHandler;
- (void)deleteBackgroundImages;

@end
