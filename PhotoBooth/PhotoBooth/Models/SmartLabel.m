//
//  SmartLabel.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/26/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "SmartLabel.h"

@interface SmartLabel ()

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) UIButton *deleteButton;

@property (strong, nonatomic) NSAttributedString *attributedString;
@property (strong, nonatomic) NSNumber *strokeWidth;
@property (strong, nonatomic) UIColor *strokeColor;

@end


@implementation SmartLabel

- (id)initWithFrame:(CGRect)frame view:(UIView *)view color:(UIColor *)color font:(UIFont *)font string:(NSString *)string {
    self = [super initWithFrame:frame];

    if (self) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;

        self.textColor = color;
        self.font = font;
        self.text = string;
        [self updateStrokeWidth:0];
        [self setupTextField];
        [self layoutIfNeeded];
    }

    return self;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];

    if (touch.tapCount > 1) {
//        self.backgroundColor = [UIColor grayColor];
//        [self.textField becomeFirstResponder];

        self.tag = 1000;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    self.center = touchLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}


#pragma mark - Textfield delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    UIFont *titleFont = [self.font fontWithSize:self.font.pointSize];
    self.textField.font = titleFont;
    self.textField.textColor = self.textColor;
    self.text = @"";
    self.textField.hidden = NO;
}

- (void)textFieldChanged:(UITextField *)textField {
    [textField sizeToFit];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [self updateLabelStyle];
    self.textField.hidden = YES;

    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self updateLabelStyle];
    self.textField.hidden = YES;

    [self.textField resignFirstResponder];
    return NO;
}


#pragma mark - Label Properties

- (void)setupTextField {
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.textField.textAlignment = self.textAlignment;
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textField.hidden = YES;

    self.textField.text = self.text;

    [self addSubview:self.textField];
    self.textField.delegate = self;

}

- (NSAttributedString *)attributedString {
    if (!_attributedString) {
        _attributedString = [NSAttributedString new];
    }

    if (!self.strokeWidth) {
        self.strokeWidth = @0;
    }

    if (!self.strokeColor) {
        self.strokeColor = [UIColor blackColor];
    }

    NSDictionary *attributes = @{
                                 NSStrokeWidthAttributeName:self.strokeWidth,
                                 NSStrokeColorAttributeName:self.strokeColor,
                                 NSForegroundColorAttributeName:self.textColor
                                 };

    _attributedString = [_attributedString initWithString:self.textField.text attributes:attributes];
    return _attributedString;
}

- (void)setupButtons {
    self.doneButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    
}

#pragma mark - Helpers

- (void)updateLabelStyle {
    self.attributedText = self.attributedString;
    [self sizeToFit];
}

- (void)updateStrokeWidth:(float)value {
    self.strokeWidth = [NSNumber numberWithFloat:-value];
}

- (void)updateTextFillColor:(UIColor *)color {
    self.textColor = color;
}

- (void)updateTextStrokeColor:(UIColor *)color {
    self.strokeColor = color;
}

@end
