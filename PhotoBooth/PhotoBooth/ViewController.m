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
#import "GlobalUtility.h"

static int const StartTimerLimit = 5;
static int const SucceedingTimerLimit = 3;

@interface ViewController () <AWCameraViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBg;
@property (weak, nonatomic) IBOutlet AWCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview3;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview4;
@property (weak, nonatomic) IBOutlet UIView *flashView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLookHere;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel1;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel2;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel3;

@property (strong, nonatomic) UIImage *finalImage;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int timerLimit;

@end

@implementation ViewController


#pragma mark - lifeCyles

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
    self.placeholderLabel1.transform = CGAffineTransformMakeRotation(3.14f/2);
    self.placeholderLabel2.transform = CGAffineTransformMakeRotation(3.14f/2);
    self.placeholderLabel3.transform = CGAffineTransformMakeRotation(3.14f/2);

    self.timerLimit = StartTimerLimit;
}

- (void)hideElements:(BOOL)status {
    self.flashView.alpha = 0.0f;

    self.imageViewBg.hidden = status;
    self.cameraView.hidden = status;
    self.imageViewPreview.hidden = status;
    self.imageViewPreview2.hidden = status;
    self.imageViewPreview3.hidden = status;
    self.imageViewPreview4.hidden = status;
    self.placeholderLabel1.hidden = status;
    self.placeholderLabel2.hidden = status;
    self.placeholderLabel3.hidden = status;

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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(updateTimer)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateTimer {
    [self showLookHereArrow];

    [self showCountdownTimer:self.timerLimit];
    self.timerLimit--;

    if (self.timerLimit < 0) {
        self.imageViewLookHere.hidden = YES;
        self.countdownLabel.hidden = YES;

        [self takePhoto];
        [self.timer invalidate];
        self.timer = nil;
        self.timerLimit = SucceedingTimerLimit;
    }
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

    __weak typeof(self) weakSelf = self;

    self.countdownLabel.hidden = NO;
    self.countdownLabel.alpha = 1.0f;

    self.countdownLabel.text = [NSString stringWithFormat:@"%i", time];

    [UIView animateWithDuration: 1.0f
                     animations: ^{
                         weakSelf.countdownLabel.alpha = 0.0f;
                         [UIScreen mainScreen].brightness = 0.6f;
                     }
                     completion: ^(BOOL finished) {
                     }
     ];
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

    UIImage *rotatedImage = [GlobalUtility rotateAndMirrorImage:image rotation:UIImageOrientationLeft];

    switch (counter) {
        case 0:
            self.placeholderLabel1.hidden = YES;
            self.imageViewPreview.image = rotatedImage;
            [self takePhotoBlock];
            counter = 1;
            break;

        case 1:
            self.placeholderLabel2.hidden = YES;
            self.imageViewPreview2.image = rotatedImage;
            [self takePhotoBlock];
            counter = 2;
            break;

        case 2:
            self.placeholderLabel3.hidden = YES;
            self.imageViewPreview3.image = rotatedImage;
            [self takePhotoBlock];
            counter = 3;
            break;

        case 3: {
            self.cameraView.hidden = YES;
            self.imageViewPreview4.image = rotatedImage;
            counter = 0;

            [self savePhotoImage];
            break;
        }

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

- (void)savePhotoImage {
    __weak typeof(self) weakSelf = self;

    //RE: TODO check orientation chosen by user here
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIImage *image = [GlobalUtility takeScreenshot:weakSelf.view];
        UIImage *rotatedImage = [GlobalUtility rotateImage:image rotation:UIImageOrientationLeft];
        weakSelf.finalImage = rotatedImage;
        [GlobalUtility saveToCameraRoll:rotatedImage];

        //Segue to SendPhotoViewController
        [weakSelf performSegueWithIdentifier:@"SegueToSendPhotosViewController" sender:weakSelf];
    });
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[SendPhotoViewController class]]) {
        SendPhotoViewController *vc = [segue destinationViewController];
        vc.photoImage = self.finalImage;
    }
}

@end
