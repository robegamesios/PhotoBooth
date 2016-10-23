//
//  LayoutsViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/10/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "LayoutsViewController.h"
#import "AWCameraView.h"
#import "SendPhotoViewController.h"
#import "GlobalUtility.h"


@interface LayoutsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBg;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview3;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview4;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *emailPhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *printPhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *retakePhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *discardPhotosButton;

@property (strong, nonatomic) UIImage *finalImage;

@end

@implementation LayoutsViewController


#pragma mark - lifeCyles

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupView];
    self.menuView.hidden = YES;
//    [self hideElements:YES];
}

- (void)viewDidLayoutSubviews {
    self.imageViewBg.frame = CGRectMake(0, 0, self.view.frame.size.width *0.6f, self.view.frame.size.height *0.6f);
    NSLog(@"bg size = %g,  %g", self.imageBg.size.width, self.imageBg.size.height);

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf hideElements:NO];
    });
}

// Lock orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)setupView {
    self.imageViewPreview.image = self.image1;
    self.imageViewPreview2.image = self.image2;
    self.imageViewPreview3.image = self.image3;
    self.imageViewPreview4.image = self.image4;
}

#pragma mark - Helpers

- (void)hideElements:(BOOL)status {
    self.imageViewBg.hidden = status;
    self.imageViewPreview.hidden = status;
    self.imageViewPreview2.hidden = status;
    self.imageViewPreview3.hidden = status;
    self.imageViewPreview4.hidden = status;
}


#pragma mark - Photo methods

- (UIImage *)takeScreenshot:(UIView *)wholeScreen {
    UIGraphicsBeginImageContextWithOptions(wholeScreen.bounds.size, wholeScreen.opaque, 0.0);
    [wholeScreen drawViewHierarchyInRect:wholeScreen.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return snapshotImage;
}

- (void)saveToCameraRoll:(UIImage *)screenShot {
    // save screengrab to Camera Roll
    UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil);
}


#pragma mark - IBActions

- (IBAction)emailPhotosButtonTapped:(UIButton *)sender {
    self.menuView.hidden = YES;

    self.finalImage = [self takeScreenshot:self.view];
    [self saveToCameraRoll:[self takeScreenshot:self.view]];
}

- (IBAction)printPhotosButtonTapped:(UIButton *)sender {
    //RE: TODO
}

- (IBAction)retakePhotosButtonTapped:(UIButton *)sender {

    self.menuView.hidden = YES;
    self.imageViewPreview.image = [UIImage imageNamed:@"placeholder"];
    self.imageViewPreview2.image = [UIImage imageNamed:@"placeholder"];
    self.imageViewPreview3.image = [UIImage imageNamed:@"placeholder"];
    self.imageViewPreview4.image = [UIImage imageNamed:@"placeholder"];
}

- (IBAction)discardButtonTapped:(UIButton *)sender {

    __weak typeof(self) weakSelf = self;

    [GlobalUtility showConfirmAlertFromViewController:self title:nil message:@"Discard photos?" confirmButtonTitle:@"Discard" cancelButtonTitle:@"Cancel" completionHandler:^{
        [weakSelf performSegueWithIdentifier:@"unwindToIntroScreen" sender:weakSelf];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[SendPhotoViewController class]]) {
        SendPhotoViewController *vc = [segue destinationViewController];
        vc.imageToSend = self.finalImage;
    }
}

@end
