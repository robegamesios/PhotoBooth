//
//  TextPropertyView.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/30/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "TextPropertyView.h"
#import "SmartLabel.h"
#import "MMPickerView.h"
#import "DRColorPicker.h"

@interface TextPropertyView () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

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

@property (strong, nonatomic) SmartLabel *smartLabel;
@property (copy, nonatomic) NSString *selectedString;
@property (nonatomic, strong) DRColorPickerColor *textFillColor;
@property (nonatomic, strong) DRColorPickerColor *textStrokeColor;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;

@end


@implementation TextPropertyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

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

    self.smartLabel = [self getSmartLabel];

    [self.smartLabel updateStrokeWidth:value];
    [self.smartLabel updateLabelStyle];
}

- (IBAction)fontSizeSliderAction:(UISlider *)sender {
    sender.minimumValue = 20;
    sender.maximumValue = 200;
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


#pragma mark - Helpers

- (SmartLabel *)getSmartLabel {
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


- (void)showFontSelectorWithCompletionHandler:(SuccessBlock)completionHandler {

    NSArray *sortByStrings = [UIFont familyNames];

    if (!self.selectedString) {
        self.selectedString = sortByStrings.firstObject;
    }

    [MMPickerView showPickerViewInView:self.parentViewController.view withStrings:sortByStrings withOptions:@{MMselectedObject:_selectedString} completion:^(NSString *selectedString) {

        self.selectedString = selectedString;

        if (completionHandler) {
            completionHandler(selectedString);
        }
    }];
}


#pragma mark - DRColorPicker

- (void)showColorPickerWithCompletionHanlder:(SuccessBlock)successHandler {

    // Setup the color picker - this only has to be done once, but can be called again and again if the values need to change while the app runs
    //    DRColorPickerThumbnailSizeInPointsPhone = 44.0f; // default is 42
    //    DRColorPickerThumbnailSizeInPointsPad = 44.0f; // default is 54

    // REQUIRED SETUP....................
    // background color of each view
    DRColorPickerBackgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];

    // border color of the color thumbnails
    DRColorPickerBorderColor = [UIColor blackColor];

    // font for any labels in the color picker
    DRColorPickerFont = [UIFont systemFontOfSize:16.0f];

    // font color for labels in the color picker
    DRColorPickerLabelColor = [UIColor blackColor];
    // END REQUIRED SETUP

    // OPTIONAL SETUP....................
    // max number of colors in the recent and favorites - default is 200
    DRColorPickerStoreMaxColors = 200;

    // show a saturation bar in the color wheel view - default is NO
    DRColorPickerShowSaturationBar = YES;

    // highlight the last hue in the hue view - default is NO
    DRColorPickerHighlightLastHue = YES;

    // use JPEG2000, not PNG which is the default
    // *** WARNING - NEVER CHANGE THIS ONCE YOU RELEASE YOUR APP!!! ***
    DRColorPickerUsePNG = NO;

    // JPEG2000 quality default is 0.9, which really reduces the file size but still keeps a nice looking image
    // *** WARNING - NEVER CHANGE THIS ONCE YOU RELEASE YOUR APP!!! ***
    DRColorPickerJPEG2000Quality = 0.9f;

    // set to your shared app group to use the same color picker settings with multiple apps and extensions
    DRColorPickerSharedAppGroup = nil;
    // END OPTIONAL SETUP

    // create the color picker
    DRColorPickerViewController* vc = [DRColorPickerViewController newColorPickerWithColor:self.textFillColor];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.rootViewController.showAlphaSlider = YES; // default is YES, set to NO to hide the alpha slider

    NSInteger theme = 2; // 0 = default, 1 = dark, 2 = light

    // in addition to the default images, you can set the images for a light or dark navigation bar / toolbar theme, these are built-in to the color picker bundle
    if (theme == 0)
    {
        // setting these to nil (the default) tells it to use the built-in default images
        vc.rootViewController.addToFavoritesImage = nil;
        vc.rootViewController.favoritesImage = nil;
        vc.rootViewController.hueImage = nil;
        vc.rootViewController.wheelImage = nil;
        vc.rootViewController.importImage = nil;
    }
    else if (theme == 1)
    {
        vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/dark/drcolorpicker-addtofavorites-dark.png");
        vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/dark/drcolorpicker-favorites-dark.png");
        vc.rootViewController.hueImage = DRColorPickerImage(@"images/dark/drcolorpicker-hue-v3-dark.png");
        vc.rootViewController.wheelImage = DRColorPickerImage(@"images/dark/drcolorpicker-wheel-dark.png");
        vc.rootViewController.importImage = DRColorPickerImage(@"images/dark/drcolorpicker-import-dark.png");
    }
    else if (theme == 2)
    {
        vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-addtofavorites-light.png");
        vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-favorites-light.png");
        vc.rootViewController.hueImage = DRColorPickerImage(@"images/light/drcolorpicker-hue-v3-light.png");
        vc.rootViewController.wheelImage = DRColorPickerImage(@"images/light/drcolorpicker-wheel-light.png");
        vc.rootViewController.importImage = DRColorPickerImage(@"images/light/drcolorpicker-import-light.png");
    }

    // assign a weak reference to the color picker, need this for UIImagePickerController delegate
    self.colorPickerVC = vc;

    // make an import block, this allows using images as colors, this import block uses the UIImagePickerController,
    // but in You Doodle for iOS, I have a more complex import that allows importing from many different sources
    // *** Leave this as nil to not allowing import of textures ***
    vc.rootViewController.importBlock = ^(UINavigationController* navVC, DRColorPickerHomeViewController* rootVC, NSString* title)
    {
        UIImagePickerController* p = [[UIImagePickerController alloc] init];
        p.delegate = self;
        p.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.colorPickerVC presentViewController:p animated:YES completion:nil];
    };

    // dismiss the color picker
    vc.rootViewController.dismissBlock = ^(BOOL cancel)
    {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    };

    // a color was selected, do something with it, but do NOT dismiss the color picker, that happens in the dismissBlock
    vc.rootViewController.colorSelectedBlock = ^(DRColorPickerColor* color, DRColorPickerBaseViewController* vc)
    {
        self.textFillColor = color;
        if (color.rgbColor == nil) {
            if (successHandler) {
                successHandler([UIColor colorWithPatternImage:color.image]);
            }

        } else {
            if (successHandler) {
                successHandler(color.rgbColor);
            }
        }
    };

    // finally, present the color picker
    [self.parentViewController presentViewController:vc animated:YES completion:nil];
}

@end
