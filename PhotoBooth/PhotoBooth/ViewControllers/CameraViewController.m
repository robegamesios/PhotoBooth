//
//  CameraViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/21/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "CameraViewController.h"
#import "AWCameraView.h"
#import "LayoutsViewController.h"
#import "GlobalUtility.h"

static int const StartTimerLimit = 5;
static int const SucceedingTimerLimit = 3;

@interface CameraViewController ()  <AWCameraViewDelegate>
@property (weak, nonatomic) IBOutlet AWCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIView *flashView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLookHere;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *imageViewPreview;
@property (strong, nonatomic) UIImageView *imageViewPreview2;
@property (strong, nonatomic) UIImageView *imageViewPreview3;
@property (strong, nonatomic) UIImageView *imageViewPreview4;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupLabels];
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

- (void)setupLabels {
    //Rotate countdownLabel 90 degress
    self.countdownLabel.transform = CGAffineTransformMakeRotation(3.14f/2);
}

- (void)hideElements:(BOOL)status {
    self.flashView.alpha = 0.0f;
    self.cameraView.hidden = status;
}

- (void)takePhotoBlock {
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf.cameraView retakePicture];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf startCameraTimer];
        });
    });
}


#pragma mark - Timers

- (void)startCameraTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(updateTimer)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateTimer {
    [self showLookHereArrow];

    static int time = StartTimerLimit;
    [self showCountdownTimer:time];
    time--;

    if (time < 0) {
        self.imageViewLookHere.hidden = YES;
        self.countdownLabel.hidden = YES;

        [self takePhoto];
        [self.timer invalidate];
        self.timer = nil;
        time = SucceedingTimerLimit;
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

- (void)showLookHereArrow {
    __weak typeof(self) weakSelf = self;

    self.imageViewLookHere.hidden = NO;

    [UIView animateWithDuration:1.0f
                          delay:0
         usingSpringWithDamping:0.25f
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            //Animations
                            weakSelf.imageViewLookHere.frame = CGRectMake(weakSelf.imageViewLookHere.frame.origin.x, weakSelf.imageViewLookHere.frame.origin.y - 50, weakSelf.imageViewLookHere.frame.size.width, weakSelf.imageViewLookHere.frame.size.height);
                        }
                     completion:^(BOOL finished) {
                     }];
}

- (void)showCountdownTimer:(int)time {

    self.countdownLabel.hidden = NO;
    self.countdownLabel.alpha = 1.0f;

    self.countdownLabel.text = [NSString stringWithFormat:@"%i", time];


    [UIView animateWithDuration: 1.0f
                     animations: ^{
                         self.countdownLabel.alpha = 0.0f;
                         [UIScreen mainScreen].brightness = 0.6f;
                     }
                     completion: ^(BOOL finished) {
                     }
     ];

}

- (void)startPhotoShoot {

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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
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
            self.imageViewPreview4.image = rotatedImage;
            counter = 0;
            [self performSegueWithIdentifier:@"SegueToLayoutsViewController" sender:self];

            break;

        default:
            break;
    }
}

- (void)cameraView:(AWCameraView *)cameraView didErrorOnTakePicture:(NSError *)error {

    if (error) {
        NSString *message = @"Oops! Unable to take your pic. Please try again";
        [GlobalUtility showAlertFromViewController:self title:nil message:message completionHandler:nil];
    }
}


#pragma mark - Setters

- (UIImageView *)imageViewPreview {
    if (!_imageViewPreview) {
        _imageViewPreview = [UIImageView new];
    }

    return _imageViewPreview;
}

- (UIImageView *)imageViewPreview2 {
    if (!_imageViewPreview2) {
        _imageViewPreview2 = [UIImageView new];
    }

    return _imageViewPreview2;
}

- (UIImageView *)imageViewPreview3 {
    if (!_imageViewPreview3) {
        _imageViewPreview3 = [UIImageView new];
    }

    return _imageViewPreview3;
}

- (UIImageView *)imageViewPreview4 {
    if (!_imageViewPreview4) {
        _imageViewPreview4 = [UIImageView new];
    }

    return _imageViewPreview4;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[LayoutsViewController class]]) {
        LayoutsViewController *vc = [segue destinationViewController];
        vc.image1 = self.imageViewPreview.image;
        vc.image2 = self.imageViewPreview2.image;
        vc.image3 = self.imageViewPreview3.image;
        vc.image4 = self.imageViewPreview4.image;
    }
}
@end
