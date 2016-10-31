//
//  IntroViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/17/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "IntroViewController.h"
#import "YCSlideShowImageView.h"
#import "DLPhotoPicker.h"
#import "GlobalUtility.h"
#import "SmartLabel.h"
#import "SmartSlider.h"
#import "DRColorPicker.h"

@interface IntroViewController () <UINavigationControllerDelegate, DLPhotoPickerViewControllerDelegate, UITextFieldDelegate,  UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet YCSlideShowImageView *imageView;
@property (strong, nonatomic) SmartLabel *titleLabel;

@property (strong, nonatomic) SmartSlider *textSizeSlider;
@property (strong, nonatomic) SmartSlider *textStrokeSlider;
@property (strong, nonatomic) SmartSlider *textRotationSlider;
@property (nonatomic, strong) DRColorPickerColor *textFillColor;
@property (nonatomic, strong) DRColorPickerColor *textStrokeColor;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *array = [GlobalUtility retrieveAllImages:ScreenTypeIntro];

    if (array.count) {
        for (UIImage *image in array) {
            [self.imageView addImage:image];
        }
    } else {
        [self showPhotoPicker];
    }

    self.imageView.animationDelay = 10.0f;

    [self setupSmartLabel];
    [self setupTextSizeSlider];
    [self setupTextStrokeSlider];
    [self setupTextRotationSlider];
    [self setupTextFillColorButton];
    [self setupTextStrokeColorButton];
}


#pragma mark - setup

- (void)setupSmartLabel {
    self.titleLabel = [[SmartLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 100) view:self.view color:[UIColor greenColor] font:[UIFont systemFontOfSize:90] string:@"TEST"];
    [self.view addSubview:self.titleLabel];
}

- (void)setupTextSizeSlider {
    self.textSizeSlider = [[SmartSlider alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, self.view.frame.size.height/2, 300, 10) minValue:20 maxValue:200 defaultValue:90];

    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI_2);
    self.textSizeSlider.transform = trans;

    [self.textSizeSlider addTarget:self action:@selector(textSizeSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.textSizeSlider];
}

- (void)setupTextStrokeSlider {
    self.textStrokeSlider = [[SmartSlider alloc]initWithFrame:CGRectMake(self.view.frame.size.width-260, self.view.frame.size.height/2, 300, 10) minValue:0 maxValue:10 defaultValue:0];

    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI_2);
    self.textStrokeSlider.transform = trans;

    [self.textStrokeSlider addTarget:self action:@selector(textStrokeSliderAction:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.textStrokeSlider];
}

- (void)setupTextRotationSlider {
    self.textRotationSlider = [[SmartSlider alloc]initWithFrame:CGRectMake(self.view.frame.size.width-320, self.view.frame.size.height/2, 300, 10) minValue:0 maxValue:360 defaultValue:0];

    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI_2);
    self.textRotationSlider.transform = trans;

    [self.textRotationSlider addTarget:self action:@selector(textRotationSliderAction:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.textRotationSlider];
}

- (void)setupTextFillColorButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-270, self.view.frame.size.height/2, 40, 40)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"TFC" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(textFillColorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)setupTextStrokeColorButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-220, self.view.frame.size.height/2, 40, 40)];
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"TSC" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(textStrokeColorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Lock orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskLandscapeRight;
}


#pragma mark - IBActions

- (IBAction)settingsButtonTapped:(UIButton *)sender {
    [self showPhotoPicker];
}


#pragma mark - unwind segue
- (IBAction)unwindToIntroScreen:(UIStoryboardSegue *)segue {

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
        [self dismissViewControllerAnimated:YES completion:nil];
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
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - DLPhotoPicker 

- (void)showPhotoPicker {
    DLPhotoPickerViewController *picker = [[DLPhotoPickerViewController alloc] init];
    picker.delegate = self;
    picker.pickerType = DLPhotoPickerTypePicker;
    picker.navigationTitle = NSLocalizedString(@"Albums", nil);

    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - DLPhotoPicker delegates

-(void)pickerController:(DLPhotoPickerViewController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self dismissViewControllerAnimated:YES completion:nil];

    NSArray *photoAssets = [NSArray arrayWithArray:assets];

    for (DLPhotoAsset *info in photoAssets) {
        [self.imageView addImage:info.originImage];
        [GlobalUtility saveImageToRealm:info.originImage screenType:ScreenTypeIntro];
    }
}

- (void)pickerControllerDidCancel:(DLPhotoPickerViewController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Actions

- (void)textSizeSliderAction:(SmartSlider *)sender {
    float value = sender.value;

    self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:value];
    [self.titleLabel sizeToFit];
    sender.label.text = [NSString stringWithFormat:@"%0.1f",value];

}

- (void)textStrokeSliderAction:(SmartSlider *)sender {
    float value = sender.value;

    [self.titleLabel updateStrokeWidth:value];
    [self.titleLabel updateLabelStyle];
    sender.label.text = [NSString stringWithFormat:@"%0.1f",value];
}

- (void)textRotationSliderAction:(SmartSlider *)sender {
    float value = sender.value;

    CGAffineTransform trans = CGAffineTransformMakeRotation(value * -M_PI/180);
    self.titleLabel.transform = trans;

    [self.titleLabel updateLabelStyle];
    sender.label.text = [NSString stringWithFormat:@"%0.1f",value];
}

- (void)textFillColorButtonTapped:(UIButton *)sender {

    __weak typeof(self)weakSelf = self;

    [self showColorPickerWithCompletionHanlder:^(UIColor* color) {
        [weakSelf.titleLabel updateTextFillColor:color];
        [weakSelf.titleLabel updateLabelStyle];

    }];
}

- (void)textStrokeColorButtonTapped:(UIButton *)sender {

    __weak typeof(self)weakSelf = self;

    [self showColorPickerWithCompletionHanlder:^(UIColor* color) {
        [weakSelf.titleLabel updateTextStrokeColor:color];
        [weakSelf.titleLabel updateLabelStyle];

    }];
}


@end
