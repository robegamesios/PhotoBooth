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

@property (weak, nonatomic) IBOutlet UIButton *fontStyleButton;
@property (weak, nonatomic) IBOutlet UIButton *fontColorButton;
@property (weak, nonatomic) IBOutlet UIButton *fontStrokeColorButton;
@property (weak, nonatomic) IBOutlet UISlider *fontStrokeWidthSlider;
@property (weak, nonatomic) IBOutlet UILabel *fontStrokeWidthLabel;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (weak, nonatomic) IBOutlet UISlider *textRotationSlider;
@property (weak, nonatomic) IBOutlet UILabel *textRotationLabel;
@property (weak, nonatomic) IBOutlet UIButton *addLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteLabelButton;

@property (strong, nonatomic) UIView *parentView;
@property (strong, nonatomic) SmartLabel *smartLabel;
@property (strong, nonatomic) NSArray *parentSubviews;

@end


@implementation TextPropertyView

- (id)initWithFrame:(CGRect)frame view:(UIView *)view {
    self = [super initWithFrame:frame];

    if (self) {
        self.parentView = view;
        self.parentSubviews = [view subviews];
    }
    
    return self;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [[event allTouches] anyObject];
//
//    if (touch.tapCount > 1) {
//    }

    self.smartLabel = [self getSmartLabel];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.parentView];
    self.center = touchLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


#pragma mark - Actions

- (IBAction)fontStyleButtonTapped:(UIButton *)sender {

}

- (IBAction)fontColorButtonTapped:(UIButton *)sender {

}

- (IBAction)fontStrokeColorButtonTapped:(UIButton *)sender {

}

- (IBAction)fontStrokeWidthSliderAction:(UISlider *)sender {
    sender.minimumValue = 0;
    sender.maximumValue = 10;
    sender.continuous = YES;

    float value = sender.value;

    self.fontStrokeWidthLabel.text = [NSString stringWithFormat:@"%0.1f",value];

    self.smartLabel = [self getSmartLabel];

    [self.smartLabel updateStrokeWidth:value];
    [self.smartLabel updateLabelStyle];
}


#pragma mark - Helpers

- (SmartLabel *)getSmartLabel {

    // Get the subviews of the view
    NSArray *subviews = [self.parentView subviews];

//    // Return if there are no subviews
//    if ([subviews count] == 0) return; // COUNT CHECK LINE

    for (UIView *subview in self.parentSubviews) {

        // Do what you want to do with the subview
//        NSLog(@"%@", subview);

        // List the subviews of subview
//        [self listSubviewsOfView:subview];

        if ([subview isKindOfClass:[SmartLabel class]]) {
            if (subview.tag == 1000) {
//                self.smartLabel = (SmartLabel *)subview;
                return (SmartLabel *)subview;
            }
        }
    }

    return  nil;
}

@end
