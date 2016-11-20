//
//  SmartLabel.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/26/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "SmartLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "MMPickerView.h"
#import "SmartSlider.h"

@interface SmartLabel () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSAttributedString *attributedString;
@property (assign, nonatomic) BOOL didAddGestureRecognizers;

@property (strong, nonatomic) TextPropertyView *tpv;

@end


@implementation SmartLabel

- (id)initWithColor:(UIColor *)color font:(UIFont *)font fontStrokeColor:(UIColor *)sColor fontStrokeWidth:(float)sWidth string:(NSString *)string {
    self = [super init];

    if (self) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;

        self.textColor = color;
        self.font = font;
        self.strokeColor = sColor;
        self.strokeWidth = [NSNumber numberWithFloat:sWidth];
        self.text = string;
        [self setupTextField];
        [self updateLabel];
        [self layoutIfNeeded];
    }

    return self;
}


#pragma mark - Setup

- (void)setupTextField {
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.textField.textAlignment = self.textAlignment;
    [self.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textField.hidden = YES;
    self.textField.text = self.text;
    self.textField.delegate = self;

    [self addSubview:self.textField];
}


#pragma mark - Accessors

- (BOOL)isEditingTextProperty {
    BOOL isFontSelectorShown = [self.parentViewController.view.subviews.lastObject isKindOfClass:[MMPickerView class]];
    return isFontSelectorShown;
}

- (UIColor *)strokeColor {
    if (!_strokeColor) {
        _strokeColor = [UIColor blackColor];
    }
    return _strokeColor;
}

- (NSNumber *)strokeWidth {
    if (!_strokeWidth) {
        _strokeWidth = @0;
    }
    return _strokeWidth;
}

- (TextPropertyView *)tpv {
    return self.parentViewController.tpv;
}

- (NSAttributedString *)attributedString {
    if (!_attributedString) {
        _attributedString = [NSAttributedString new];
    }

    NSDictionary *attributes = @{
                                 NSStrokeWidthAttributeName:self.strokeWidth,
                                 NSStrokeColorAttributeName:self.strokeColor,
                                 NSForegroundColorAttributeName:self.textColor,
                                 NSFontAttributeName:self.font
                                 };

    _attributedString = [_attributedString initWithString:self.textField.text attributes:attributes];
    return _attributedString;
}


#pragma mark - Textfield delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    UIFont *titleFont = [self.font fontWithSize:self.font.pointSize];
    textField.font = titleFont;
    textField.textColor = self.textColor;
    textField.text = self.text;
    [textField sizeToFit];
    self.text = @"";
    textField.hidden = NO;
}

- (void)textFieldChanged:(UITextField *)textField {
    [textField sizeToFit];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateLabel];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self updateLabel];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    textField.backgroundColor = [self textFieldEditBackgroundColor];
    self.layer.borderWidth = 0;
    return YES;
}


#pragma mark - Gesture recognizers

- (void)addGestureRecognizers {
    if (!self.didAddGestureRecognizers) {

        __weak typeof(self) weakSelf = self;

        [self resetAllTags:^{
            weakSelf.tag = KActiveTag;
            [weakSelf showLabelBorder];
            [weakSelf updateTpv];
        }];

        self.didAddGestureRecognizers = YES;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        [self.parentViewController.view addGestureRecognizer:panRecognizer];

        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
        [self.parentViewController.view addGestureRecognizer:pinchRecognizer];

        UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)];
        [self.parentViewController.view addGestureRecognizer:rotationRecognizer];

        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRecognizer];

        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapDetected:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapRecognizer];

        panRecognizer.delegate = self;
        pinchRecognizer.delegate = self;
        rotationRecognizer.delegate = self;
    }
}


#pragma mark - Gesture recognizer delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.isEditingTextProperty) {
        return NO;
    }

    return YES;
}

#pragma mark - Gesture recognizer actions

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer {
    if (self.tag != KActiveTag) return;

    CGPoint translation = [panRecognizer translationInView:self.parentViewController.view];
    CGPoint imageViewPosition = self.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;

    self.center = imageViewPosition;
    [panRecognizer setTranslation:CGPointZero inView:self.parentViewController.view];
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer {
    if (self.tag != KActiveTag) return;

    CGFloat scale = pinchRecognizer.scale;
    self.transform = CGAffineTransformScale(self.transform, scale, scale);
    pinchRecognizer.scale = 1.f;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer {
    if (self.tag != KActiveTag) return;

    CGFloat angle = rotationRecognizer.rotation;
    self.transform = CGAffineTransformRotate(self.transform, angle);
    rotationRecognizer.rotation = 0.f;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer {
    __weak typeof(self) weakSelf = self;

    [self resetAllTags:^{
        weakSelf.tag = KActiveTag;
        [weakSelf showLabelBorder];

        if (!weakSelf.tpv.isHidden) {
            [weakSelf updateTpv];
        }
    }];
}

- (void)doubleTapDetected:(UITapGestureRecognizer *)tapRecognizer {
    if (self.tag != KActiveTag) return;

    self.tpv.hidden = NO;
    [self updateTpv];
}


#pragma mark - Helpers

- (void)showLabelBorder {
    self.layer.borderWidth = KBorderWidth;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (UIColor *)textFieldEditBackgroundColor {
    return [UIColor lightGrayColor];
}

- (void)updateLabel {
    self.attributedText = self.attributedString;
    [self sizeToFit];

    self.textField.hidden = YES;
    [self showLabelBorder];

    [self.textField resignFirstResponder];
}

- (void)updateStrokeWidth:(float)value {
    self.strokeWidth = [NSNumber numberWithFloat:-value];
    [self updateLabel];
}

- (void)updateTextFillColor:(UIColor *)color {
    self.textColor = color;
}

- (void)updateTextStrokeColor:(UIColor *)color {
    self.strokeColor = color;
    [self updateLabel];
}

- (void)updateTpv {
    self.tpv.smartLabel = self;
    [self.tpv.fontStyleButton setTitle:self.font.fontName forState:UIControlStateNormal];
    self.tpv.fontColorButton.backgroundColor = self.textColor;
    self.tpv.fontStrokeColorButton.backgroundColor = self.strokeColor;
    float strokeWidth = self.strokeWidth.floatValue * -1;
    self.tpv.fontStrokeWidthSlider.value = strokeWidth;
    self.tpv.fontStrokeWidthLabel.text = [NSString stringWithFormat:@"%.1f", strokeWidth];
}

- (void)resetAllTags:(VoidBlock)completionHandler {
    NSArray *subviews = [self.parentViewController.view subviews];

    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:[self class]]) {

            SmartLabel *view = (SmartLabel *)subview;

            view.backgroundColor = [UIColor clearColor];
            if (view.textField.isFirstResponder) {
                [view.textField resignFirstResponder];
            }
            view.layer.borderWidth = 0;
            view.tag = 0;
            view.isEditingTextProperty = NO;
        }
    }

    if (completionHandler) {
        completionHandler();
    }
}

@end
