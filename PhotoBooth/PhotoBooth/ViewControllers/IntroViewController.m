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

@interface IntroViewController () <UINavigationControllerDelegate, DLPhotoPickerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet YCSlideShowImageView *imageView;

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

@end
