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

    [self setupEditModeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
}

// Lock orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskLandscapeRight;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];

    SmartLabel *label = [GlobalUtility findSmartLabelWithTag:KActiveTag parentViewController:self];

    if (label) {
        if (!label.isEditingTextProperty) {
            if (!CGRectContainsPoint(label.frame, touchLocation)) {
                label.tag = 0;
                label.layer.borderWidth = 0;
            }
        }
    }
}

#pragma mark - IBActions

- (IBAction)settingsButtonTapped:(UIButton *)sender {
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)addImageButtonTapped:(UIBarButtonItem *)sender {
    [self showPhotoPicker];
}

- (IBAction)clearImageButtonTapped:(UIBarButtonItem *)sender {
    [self deleteBackgroundImages];
}

- (IBAction)backgroundColorButtonTapped:(UIBarButtonItem *)sender {
    [self showColorPickerWithCompletionHanlder:^(UIColor *color) {
        self.view.backgroundColor = color;
    }];
}

- (IBAction)addTextButtonTapped:(UIBarButtonItem *)sender {
    [self setupSmartLabel];
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {
    self.navigationController.navigationBarHidden = YES;
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
