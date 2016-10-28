//
//  SmartLabel.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/26/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartLabel : UILabel <UITextFieldDelegate>

- (id)initWithFrame:(CGRect)frame view:(UIView *)view color:(UIColor *)color font:(UIFont *)font string:(NSString *)string;


- (void)updateLabelStyle;
- (void)updateStrokeWidth:(float)value;

@end
