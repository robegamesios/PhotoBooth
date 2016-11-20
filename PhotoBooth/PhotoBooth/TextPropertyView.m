//
//  TextPropertyView.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/30/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "TextPropertyView.h"
#import "SmartLabel.h"

@interface TextPropertyView () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *deleteLabelButton;
@property (assign, nonatomic) BOOL didAddGestureRecognizers;

@end


@implementation TextPropertyView

- (id)init {
    self = [super init];

    if (self) {

    }
    return self;
}


#pragma mark - Actions

- (IBAction)fontStyleButtonTapped:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;

    [self showFontSelectorWithCompletionHandler:^(NSString *responseObject) {
        weakSelf.smartLabel.font = [UIFont fontWithName:responseObject size:self.smartLabel.font.pointSize];
        [weakSelf.fontStyleButton setTitle:responseObject forState:UIControlStateNormal];
        [weakSelf.smartLabel updateLabel];
    }];
}

- (IBAction)fontColorButtonTapped:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;

    [self showColorPickerWithCompletionHanlder:^(UIColor* color) {
        [weakSelf.smartLabel updateTextFillColor:color];
        weakSelf.fontColorButton.backgroundColor = color;
    }];
}

- (IBAction)fontStrokeColorButtonTapped:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;

    [self showColorPickerWithCompletionHanlder:^(UIColor* color) {
        [weakSelf.smartLabel updateTextStrokeColor:color];
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
}

- (IBAction)deleteButtonTapped:(UIButton *)sender {
    [self.smartLabel removeFromSuperview];
    //RE: TODO: delete from realm

}

- (IBAction)editButtonTapped:(UIButton *)sender {
    self.smartLabel.textField.backgroundColor = [self.smartLabel textFieldEditBackgroundColor];
    self.smartLabel.layer.borderWidth = 0;
    [self.smartLabel.textField becomeFirstResponder];
}

- (IBAction)doneButtonTapped:(UIButton *)sender {
    self.smartLabel.isEditingTextProperty = NO;
    self.hidden = YES;
}

#pragma mark - Helpers

- (SmartLabel *)smartLabel {
    NSArray *subviews = [self.parentViewController.view subviews];

    for (UIView *subview in subviews) {

        if ([subview isKindOfClass:[SmartLabel class]]) {
            if (subview.tag == 1000) {
                SmartLabel *view = (SmartLabel *)subview;
                return view;
            }
        }
    }
    return  nil;
}

@end
