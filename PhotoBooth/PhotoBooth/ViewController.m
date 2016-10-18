//
//  ViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/10/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "ViewController.h"
#import "AWCameraView.h"
#import "SendPhotoViewController.h"

@interface ViewController () <AWCameraViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBg;
@property (weak, nonatomic) IBOutlet AWCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview3;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview4;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCounter;
@property (weak, nonatomic) IBOutlet UIButton *retakePhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *emailPhotosButton;
@property (weak, nonatomic) IBOutlet UIView *flashView;

@property (strong, nonatomic) UIImage *finalImage;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController


#pragma mark - lifeCyles

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self hideButtons:YES];
    [self hideElements:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf hideElements:NO];
        [weakSelf startPhotoShoot];
    });
}

// Lock orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Helpers

- (void)hideElements:(BOOL)status {
    self.flashView.alpha = 0.0f;

    self.imageViewBg.hidden = status;
    self.cameraView.hidden = status;
    self.imageViewPreview.hidden = status;
    self.imageViewPreview2.hidden = status;
    self.imageViewPreview3.hidden = status;
    self.imageViewPreview4.hidden = status;
    self.imageViewCounter.hidden = status;
}

- (void)hideButtons:(BOOL)status {
    self.retakePhotosButton.hidden = status;
    self.emailPhotosButton.hidden = status;
}

- (void)takePhotoBlock {
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf.cameraView retakePicture];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf startCameraTimer];
        });
    });
}


#pragma mark - Timers

- (void)startCameraTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateTimer)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateTimer {

    static int time = 0;

    switch (time) {
        case 0:
            self.imageViewCounter.image = [UIImage imageNamed: @"counter3"];
            time = 1;
            break;

        case 1:
            self.imageViewCounter.image = [UIImage imageNamed: @"counter2"];
            time = 2;
            break;

        case 2:
            self.imageViewCounter.image = [UIImage imageNamed: @"counter1"];
            time = 3;
            break;

        case 3:
            self.imageViewCounter.image = nil;

            [self takePhoto];
            [self.timer invalidate];
            self.timer = nil;
            time = 0;
            break;

        default:
            break;
    }
}


#pragma mark - Photo methods

- (UIImage *)rotateImage:(UIImage *)image {
    UIImage * landscapeImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                                          scale: 1.0
                                                    orientation: UIImageOrientationLeft];

    UIImage* flippedImage = [UIImage imageWithCGImage:landscapeImage.CGImage
                                                scale:landscapeImage.scale
                                          orientation:UIImageOrientationLeftMirrored];

    return flippedImage;
}

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

- (void)startPhotoShoot {
    self.finalImage = nil;

    self.cameraView.delegate = self;
    self.cameraView.position = AWCameraViewPositionFront;
    
//    /// Enable tap-on-focus for camera-view; no need to call 'focusOnPoint'
//    self.cameraView.enableFocusOnTap = YES;
//
//    /// (Manually) focus on top-left point of camera-view
//    [cameraView focusOnPoint:CGPointMake(0, 0)];
//
//    /// (Manually) focus on bottom-right point of camera-view
//    [cameraView focusOnPoint:CGPointMake(1, 1)];
}

- (void)takePhoto {
    [UIScreen mainScreen].brightness = 0.5f;
    self.flashView.alpha = 1.0f;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIScreen mainScreen].brightness = 1.0f;

        [self.cameraView takePicture];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration: 0.5f
                             animations: ^{
                                 self.flashView.alpha = 0.0f;
                                 [UIScreen mainScreen].brightness = 0.6f;

                             }
                             completion: ^(BOOL finished) {
                             }
             ];
        });
    });
}

#pragma mark - AWCameraViewDelegate methods

-(void)cameraView:(AWCameraView *)cameraView didCreateCaptureConnection:(AVCaptureConnection *)captureConnection withCaptureConnectionType:(AWCameraViewCaptureConnectionType)captureConnectionType {

    [self startCameraTimer];
}

- (void)cameraView:(AWCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info {

    static int counter = 0;

    UIImage *rotatedImage = [self rotateImage:image];

    switch (counter) {
        case 0:
            self.imageViewPreview.image = rotatedImage;
            [self takePhotoBlock];
            counter = 1;
            break;

        case 1:
            self.imageViewPreview2.image = rotatedImage;
            [self takePhotoBlock];
            counter = 2;
            break;

        case 2:
            self.imageViewPreview3.image = rotatedImage;
            [self takePhotoBlock];
            counter = 3;
            break;

        case 3:
            self.cameraView.hidden = YES;
            self.imageViewPreview4.image = rotatedImage;

            [self hideButtons:NO];
            counter = 0;

            break;

        default:
            break;
    }
}

- (void)cameraView:(AWCameraView *)cameraView didErrorOnTakePicture:(NSError *)error {

    if (error) {

    }
}


#pragma mark - IBActions

- (IBAction)retakePhotosButtonTapped:(UIButton *)sender {

    [self hideButtons:YES];
    self.cameraView.hidden = NO;

    self.imageViewPreview.image = [UIImage imageNamed:@"placeholder1"];
    self.imageViewPreview2.image = [UIImage imageNamed:@"placeholder2"];
    self.imageViewPreview3.image = [UIImage imageNamed:@"placeholder3"];
    self.imageViewPreview4.image = [UIImage imageNamed:@"placeholder"];

    [self takePhotoBlock];
}

- (IBAction)emailPhotosButtonTapped:(UIButton *)sender {
    self.cameraView.hidden = YES;

    [self hideButtons:YES];

    self.finalImage = [self takeScreenshot:self.view];
    [self saveToCameraRoll:[self takeScreenshot:self.view]];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    SendPhotoViewController *vc = [segue destinationViewController];
    vc.imageToSend = self.finalImage;

}

@end
