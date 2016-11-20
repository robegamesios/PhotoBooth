//
//  BaseViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 11/10/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "BaseViewController.h"
#import "DLPhotoPicker.h"
#import "YCSlideShowImageView.h"
#import "DRColorPicker.h"
#import "SmartLabel.h"
#import "TextPropertyView.h"
#import "SmartSlider.h"

@interface BaseViewController () <UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, DLPhotoPickerViewControllerDelegate>

@property (nonatomic, strong) DRColorPickerColor *textFillColor;
@property (nonatomic, strong) DRColorPickerColor *textStrokeColor;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;
@end


@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - setup

- (void)setupEditModeView {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditModeViewController" owner:self options:nil];

    self.emv = [EditModeView new];
    self.emv = (EditModeView *)nib.firstObject;
    float frameWidth = 350;

    self.emv.center = CGPointMake(self.view.frame.size.width - frameWidth/2, self.view.frame.size.height/3);
    self.emv.parentViewController = self;
    self.emv.hidden = YES;
    [self.view addSubview:self.emv];

}

- (void)setupTextPropertyView {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PropertyView" owner:self options:nil];

    self.tpv = [TextPropertyView new];
    self.tpv = (TextPropertyView *)nib.firstObject;
    float frameWidth = 320;
    float frameHeight = 200;
    self.tpv.frame = CGRectMake(self.view.frame.size.width - frameWidth, self.view.frame.size.height - frameHeight, frameWidth, frameHeight);
    self.tpv.parentViewController = self;
    self.tpv.hidden = YES;
    [self.view addSubview:self.tpv];
}

- (void)setupSmartLabel {
    SmartLabel *titleLabel = nil;

    if (self.tpv) {
        UIColor *fontColor = self.tpv.fontColorButton.backgroundColor;
        UIFont *font = [UIFont fontWithName:self.tpv.fontStyleButton.titleLabel.text size:60];
        UIColor *fontStrokeColor = self.tpv.fontStrokeColorButton.backgroundColor;
        float fontStrokeWidth = self.tpv.fontStrokeWidthSlider.value * -1;

        titleLabel = [[SmartLabel alloc]initWithColor:fontColor font:font fontStrokeColor:fontStrokeColor fontStrokeWidth:fontStrokeWidth string:@"Double tap me to edit"];

    } else {
        titleLabel = [[SmartLabel alloc]initWithColor:[UIColor blueColor] font:[UIFont systemFontOfSize:60] fontStrokeColor:[UIColor whiteColor] fontStrokeWidth:0 string:@"Double tap me to edit"];
        [self setupTextPropertyView];
    }

    titleLabel.parentViewController = self;
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(self.view.frame.size.width/2, 150);
    [titleLabel addGestureRecognizers];
}


#pragma mark - DLPhotoPicker

- (void)showPhotoPicker {
    DLPhotoPickerViewController *picker = [[DLPhotoPickerViewController alloc] init];
    picker.delegate = self;
    picker.pickerType = DLPhotoPickerTypePicker;
    picker.navigationTitle = NSLocalizedString(@"Albums", nil);

    [self presentViewController:picker animated:YES completion:nil];
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


#pragma mark - DLPhotoPicker delegates

-(void)pickerController:(DLPhotoPickerViewController *)picker didFinishPickingAssets:(NSArray *)assets
{
    //Overwrite method
}

- (void)pickerControllerDidCancel:(DLPhotoPickerViewController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Override methods

- (void)deleteBackgroundImages {
    //Overwrite
}

@end
