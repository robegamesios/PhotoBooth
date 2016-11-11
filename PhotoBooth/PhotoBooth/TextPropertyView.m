//
//  TextPropertyView.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/30/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "TextPropertyView.h"
#import "SmartLabel.h"

@interface TextPropertyView ()

@property (weak, nonatomic) IBOutlet UISlider *fontStrokeWidthSlider;
@property (weak, nonatomic) IBOutlet UILabel *fontStrokeWidthLabel;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet UISlider *textRotationSlider;
@property (weak, nonatomic) IBOutlet UILabel *textRotationLabel;
@property (weak, nonatomic) IBOutlet UIButton *addLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteLabelButton;

@property (strong, nonatomic) SmartLabel *smartLabel;

@end


@implementation TextPropertyView

- (id)init {
    self = [super init];

    if (self) {

    }
    return self;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [[event allTouches] anyObject];
//
//    if (touch.tapCount > 1) {
//    }

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.parentViewController.view];

    self.center = touchLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


#pragma mark - Actions

- (IBAction)fontStyleButtonTapped:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;

    [self showFontSelectorWithCompletionHandler:^(NSString *responseObject) {
        weakSelf.smartLabel.font = [UIFont fontWithName:responseObject size:self.smartLabel.font.pointSize];
        [weakSelf.fontStyleButton setTitle:responseObject forState:UIControlStateNormal];
        [weakSelf.smartLabel updateLabelStyle];

    }];
}

- (IBAction)fontColorButtonTapped:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;

    [self showColorPickerWithCompletionHanlder:^(UIColor* color) {
        [weakSelf.smartLabel updateTextFillColor:color];
        [weakSelf.smartLabel updateLabelStyle];
        weakSelf.fontColorButton.backgroundColor = color;
    }];
}

- (IBAction)fontStrokeColorButtonTapped:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;

    [self showColorPickerWithCompletionHanlder:^(UIColor* color) {
        [weakSelf.smartLabel updateTextStrokeColor:color];
        [weakSelf.smartLabel updateLabelStyle];
        weakSelf.fontStrokeColorButton.backgroundColor = color;
    }];
}

- (IBAction)fontStrokeWidthSliderAction:(UISlider *)sender {
    sender.minimumValue = 0;
    sender.maximumValue = 10;
    sender.continuous = YES;

    float value = sender.value;

    self.fontStrokeWidthLabel.text = [NSString stringWithFormat:@"%0.1f",value];

    [self.smartLabel updateStrokeWidth:value];
    [self.smartLabel updateLabelStyle];
}

- (IBAction)fontSizeSliderAction:(UISlider *)sender {
    sender.minimumValue = 20;
    sender.maximumValue = 300;
    sender.continuous = YES;

    float value = sender.value;

    self.fontSizeLabel.text = [NSString stringWithFormat:@"%0.1f",value];

    self.smartLabel.font = [UIFont fontWithName:self.smartLabel.font.fontName size:value];
    [self.smartLabel sizeToFit];
}

- (IBAction)textRotationSliderAction:(UISlider *)sender {
    sender.minimumValue = 0;
    sender.maximumValue = 360;
    sender.continuous = YES;

    float value = sender.value;

    self.textRotationLabel.text = [NSString stringWithFormat:@"%0.1f",value];

    CGAffineTransform trans = CGAffineTransformMakeRotation(value * -M_PI/180);

    self.smartLabel.transform = trans;
    [self.smartLabel updateLabelStyle];
}

- (IBAction)editTextButtonTapped:(UIButton *)sender {
    [self.smartLabel.textField becomeFirstResponder];
}

- (IBAction)doneButtonTapped:(UIButton *)sender {
    self.smartLabel.tag = 0;
    self.hidden = YES;
}


#pragma mark - Helpers

- (SmartLabel *)smartLabel {
    NSArray *subviews = [self.parentViewController.view subviews];

    for (UIView *subview in subviews) {

        if ([subview isKindOfClass:[SmartLabel class]]) {
            if (subview.tag == 1000) {
                return (SmartLabel *)subview;
            }
        }
    }
    return  nil;
}

@end
