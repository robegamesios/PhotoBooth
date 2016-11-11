//
//  SmartLabel.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/26/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextPropertyView.h"

@interface SmartLabel : UILabel <UITextFieldDelegate>

- (id)initWithFrame:(CGRect)frame color:(UIColor *)color font:(UIFont *)font string:(NSString *)string;

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) TextPropertyView *tpv;

- (void)updateLabelStyle;
- (void)updateStrokeWidth:(float)value;
- (void)updateTextFillColor:(UIColor *)color;
- (void)updateTextStrokeColor:(UIColor *)color;

@end
