//
//  SmartLabel.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/26/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextPropertyView.h"
#import "BaseViewController.h"

@interface SmartLabel : UILabel <UITextFieldDelegate>

- (id)initWithColor:(UIColor *)color font:(UIFont *)font fontStrokeColor:(UIColor *)sColor fontStrokeWidth:(float)sWidth string:(NSString *)string;

@property (strong, nonatomic) BaseViewController *parentViewController;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSNumber *strokeWidth;
@property (strong, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) BOOL isEditingTextProperty;

- (void)updateStrokeWidth:(float)value;
- (void)updateTextFillColor:(UIColor *)color;
- (void)updateTextStrokeColor:(UIColor *)color;
- (void)addGestureRecognizers;
- (void)updateLabel;
- (UIColor *)textFieldEditBackgroundColor;

@end
