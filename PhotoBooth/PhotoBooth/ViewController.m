//
//  ViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/10/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "ViewController.h"
#import "AWCameraView.h"

@import Photos;

@interface ViewController () <AWCameraViewDelegate>

@property (weak, nonatomic) IBOutlet AWCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview3;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPreview4;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCounter;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController


#pragma mark - lifeCyles

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self startPhotoShoot];
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
            [self.cameraView takePicture];
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


#pragma mark - AWCameraViewDelegate methods

-(void)cameraView:(AWCameraView *)cameraView didCreateCaptureConnection:(AVCaptureConnection *)captureConnection withCaptureConnectionType:(AWCameraViewCaptureConnectionType)captureConnectionType {

    [self startCameraTimer];
}

- (void)cameraView:(AWCameraView *)cameraView didFinishTakingPicture:(UIImage *)image withInfo:(NSDictionary *)info {

    __weak typeof(self) weakSelf = self;

    static int counter = 0;

    void(^block)(void) = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [weakSelf.cameraView retakePicture];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [weakSelf startCameraTimer];
            });
        });
    };

    UIImage *rotatedImage = [self rotateImage:image];

    switch (counter) {
        case 0:
            self.imageViewPreview.image = rotatedImage;
            block();
            counter = 1;
            break;

        case 1:
            self.imageViewPreview2.image = rotatedImage;
            block();
            counter = 2;
            break;

        case 2:
            self.imageViewPreview3.image = rotatedImage;
            block();
            counter = 3;
            break;

        case 3:
            counter = 0;
            self.imageViewPreview4.image = rotatedImage;
            [self saveToCameraRoll:[self takeScreenshot:self.view]];
            break;

        default:
            break;
    }
}

- (void)cameraView:(AWCameraView *)cameraView didErrorOnTakePicture:(NSError *)error {

    if (error) {

    }
}




//- (void)fetchLastImageFromCameraRoll {
//    __weak typeof(self) weakSelf = self;
//
//    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
//    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
//    PHAsset *lastAsset = [fetchResult lastObject];
//    [[PHImageManager defaultManager] requestImageForAsset:lastAsset
//                                               targetSize:self.imageView2.bounds.size
//                                              contentMode:PHImageContentModeAspectFit
//                                                  options:PHImageRequestOptionsVersionCurrent
//                                            resultHandler:^(UIImage *result, NSDictionary *info) {
//
//                                                if (result.scale == 1.0f) {
//                                                    self.imageView2.image = result;
//                                                    //                                                    UIImage *image = [weakSelf combineImages:result];
//
//                                                    UIImage *newImage = [weakSelf imageByCombiningImage:self.imageView2.image withImage:weakSelf.imageView3.image];
//                                                    self.imageView.image = newImage;
//
//                                                    UIImageWriteToSavedPhotosAlbum(newImage,nil,nil,nil);
//                                                }
//
//
//
//                                                //                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                //
//                                                //                                                    //re: do something here
//                                                //                                                    [weakSelf combineImages:result];
//                                                //                                                });
//                                            }];
//    
//}


@end
