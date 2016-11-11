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

@interface IntroViewController ()

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet YCSlideShowImageView *imageView;
@property (copy, nonatomic) NSString *selectedString;


@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *array = [GlobalUtility retrieveAllImages:ScreenTypeIntro];

    if (array.count) {
        for (UIImage *image in array) {
            [self.imageView addImage:image];
        }
    }

    self.imageView.animationDelay = 10.0f;

    [self setupTextPropertyView];
    [self setupEditModeView];
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
    self.emv.hidden = NO;
}


#pragma mark - unwind segue
- (IBAction)unwindToIntroScreen:(UIStoryboardSegue *)segue {

}

- (void)deleteBackgroundImages {
    [self.imageView emptyImageArray];
    self.imageView.image = nil;
    [GlobalUtility deleteAllBackgroundImages:ScreenTypeIntro completionHandler:nil];
}

#pragma mark - DLPhotoPicker delegates

-(void)pickerController:(DLPhotoPickerViewController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self dismissViewControllerAnimated:YES completion:nil];

    NSArray *photoAssets = [NSArray arrayWithArray:assets];

    if (photoAssets.count) {
        [GlobalUtility deleteAllBackgroundImages:ScreenTypeIntro completionHandler:^{
            [self.imageView emptyImageArray];
            
            for (DLPhotoAsset *info in photoAssets) {
                [self.imageView addImage:info.originImage];
                [GlobalUtility saveImageToRealm:info.originImage screenType:ScreenTypeIntro];
            }
        }];
    }
}

@end
