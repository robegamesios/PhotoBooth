//
//  EditModeView.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 11/9/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "EditModeView.h"
#import "BaseViewController.h"
#import "IntroViewController.h"

@interface EditModeView ()

@end


@implementation EditModeView

- (id)init {
    self = [super init];

    if (self) {

    }
    return self;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.parentViewController.view];

    self.center = touchLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


#pragma mark - IBActions

- (IBAction)addBackgroundImageButtonTapped:(UIButton *)sender {
    [(BaseViewController *)self.parentViewController showPhotoPicker];
}

- (IBAction)clearBackgroundImageButtonTapped:(UIButton *)sender {
    [(BaseViewController *)self.parentViewController deleteBackgroundImages];
}

- (IBAction)changeBackgroundColorButtonTapped:(UIButton *)sender {
    [(BaseViewController *)self.parentViewController showColorPickerWithCompletionHanlder:^(UIColor *color) {
        self.parentViewController.view.backgroundColor = color;
    }];
}

- (IBAction)addNewTextButtonTapped:(UIButton *)sender {
    [(BaseViewController *)self.parentViewController setupSmartLabel];
}

- (IBAction)exitButtonTapped:(UIButton *)sender {
    self.hidden = YES;
}

@end
