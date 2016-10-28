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

@interface IntroViewController () <UINavigationControllerDelegate, DLPhotoPickerViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet YCSlideShowImageView *imageView;
@property (strong, nonatomic) SmartLabel *titleLabel;

@property (strong, nonatomic) SmartSlider *textSizeSlider;
@property (strong, nonatomic) SmartSlider *textStrokeSlider;

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
}


#pragma mark - setup

- (void)setupSmartLabel {
    self.titleLabel = [[SmartLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 100) view:self.view color:[UIColor greenColor] font:[UIFont systemFontOfSize:90] string:@"TEST"];
    [self.view addSubview:self.titleLabel];
}

- (void)setupTextSizeSlider {
    self.textSizeSlider = [[SmartSlider alloc]initWithFrame:CGRectMake(self.view.frame.size.width-200, self.view.frame.size.height-250, 300, 10) minValue:20 maxValue:200 defaultValue:90];

    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI_2);
    self.textSizeSlider.transform = trans;

    [self.textSizeSlider addTarget:self action:@selector(textSizeSliderAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.textSizeSlider];
}

- (void)setupTextStrokeSlider {
    self.textStrokeSlider = [[SmartSlider alloc]initWithFrame:CGRectMake(self.view.frame.size.width-250, self.view.frame.size.height-250, 300, 10) minValue:0 maxValue:10 defaultValue:3];

    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI_2);
    self.textStrokeSlider.transform = trans;

    [self.textStrokeSlider addTarget:self action:@selector(textStrokeSliderAction:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.textStrokeSlider];
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
    sender.label.text = [NSString stringWithFormat:@"%0.f",value];

}

- (void)textStrokeSliderAction:(SmartSlider *)sender {
    float value = sender.value;

    [self.titleLabel updateStrokeWidth:value];
    [self.titleLabel updateLabelStyle];
    sender.label.text = [NSString stringWithFormat:@"%0.f",value];
}


@end
