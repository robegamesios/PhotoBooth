//
//  SendPhotoViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/16/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "SendPhotoViewController.h"
#import <MessageUI/MessageUI.h>
#import "GlobalUtility.h"
@import Photos;

@interface SendPhotoViewController () <MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewThankYou;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (strong, nonatomic) UIImage *printImage;

@end

@implementation SendPhotoViewController

#pragma mark - Lifecycles

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.imageViewThankYou.image = self.photoImage;
}

// Lock orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskLandscapeRight;
}


#pragma mark - Email
- (void)showEmail:(UIImage*)emailImage {

    MFMailComposeViewController *emailDialog = [[MFMailComposeViewController alloc] init];

    emailDialog.mailComposeDelegate = self;

    NSString *htmlMsg = @"<html><body><p>Happy Thanksgiving! itms://itunes.apple.com/us/app/apple-store/id1178580289?mt=8 </p></body></html>";

    UIImage *rotatedImage = [GlobalUtility rotateImage:emailImage rotation:UIImageOrientationUp];
    NSData *jpegData = [NSData dataWithData:UIImageJPEGRepresentation(rotatedImage, 1.0)];

    NSString *fileName = @"photo";
    fileName = [fileName stringByAppendingPathExtension:@"jpeg"];

    if (jpegData) {
        [emailDialog addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
    }

    [emailDialog setSubject:@"Thanksgiving Party Photobooth pic"];
    [emailDialog setMessageBody:htmlMsg isHTML:YES];

    [self presentViewController:emailDialog animated:YES completion:nil];
}


#pragma mark - MFMailComposeViewControllerDelegate methods

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    NSString *message = nil;

    if (error) {
        message = @"Oops! Failed to send photo, please try again";

    } else {
        switch (result) {

            case MFMailComposeResultCancelled:
                NSLog(@"email canceled");
                message = @"Canceled sending photo, try again, it's fun!";
                break;

            case MFMailComposeResultSaved:
                NSLog(@"email saved");
                message = @"Photo saved, we will send your photobooth pic soon :)";
                break;

            case MFMailComposeResultSent:
                NSLog(@"email sent");
                message = @"Photo sent, thanks :)";

                break;
            case MFMailComposeResultFailed:
                NSLog(@"email sent failure: %@", [error localizedDescription]);
                message = @"Failed to send photo, we will send your photobooth pic soon :)";
                
                break;
                
            default:
                break;
        }
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - IBActions

- (IBAction)emailPhotosButtonTapped:(UIButton *)sender {
    [self showEmail:self.photoImage];
}

- (IBAction)printPhotosButtonTapped:(UIButton *)sender {
    //RE: TODO 7x5 for now
    UIImage *resizedImage = [GlobalUtility resizedImage:self.photoImage width:7 height:5];
    [self airprintInfo:resizedImage];
}

- (IBAction)shareButtonTapped:(UIButton *)sender {
    [self showShareSheet:self.photoImage];
}

- (IBAction)doneButtonTapped:(UIButton *)sender {

    __weak typeof(self) weakSelf = self;

    self.menuView.hidden = YES;

    //RE:TODO
    self.imageViewThankYou.image = [UIImage imageNamed:@"thankYou"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        weakSelf.imageViewThankYou.hidden = YES;
        [weakSelf performSegueWithIdentifier:@"unwindToIntroScreen" sender:weakSelf];
    });
}


#pragma mark - Helpers

- (void)airprintInfo:(UIImage *)info {

    __weak typeof(self) weakSelf = self;

    if ([UIPrintInteractionController isPrintingAvailable]) {

        UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];

        print.delegate = self;
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputPhoto;
        printInfo.jobName =@"PartyPhotoBoothPhoto";
        print.printInfo = printInfo;
        print.showsPageRange = NO;
        print.printingItem = info;

        void (^completionHandler)(UIPrintInteractionController *,BOOL, NSError *) = ^(UIPrintInteractionController *print,BOOL completed, NSError *error) {
            if (!completed && error) {
                [GlobalUtility showAlertFromViewController:weakSelf title:nil message:error.localizedDescription completionHandler:nil];
            }
        };

        [print presentAnimated:YES completionHandler:completionHandler];
    }
}

//- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray<UIPrintPaper *> *)paperList {
//
//    if (paperList.count) {
//        self.printImage = [GlobalUtility resizedImage:self.photoImage width:paperList.firstObject.paperSize.width height:paperList.firstObject.paperSize.height];
//    }
//
//    return paperList.firstObject;
//}

- (void)showShareSheet:(UIImage *)image {
    NSString *htmlMsg = @"";

    NSString *shareText = htmlMsg;
    NSArray *items = @[shareText];
    UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:@[items,image] applicationActivities:nil];

    vc.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypePrint];

    //ipad
    vc.popoverPresentationController.sourceView = self.view;
    vc.popoverPresentationController.sourceRect = self.menuView.frame;

    [self presentViewController:vc animated:YES completion:nil];
}

//
//- (void)fetchLastImageFromCameraRoll {
//
//    __weak typeof(self) weakSelf = self;
//
//    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
//    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
//    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
//    PHAsset *lastAsset = [fetchResult lastObject];
//    [[PHImageManager defaultManager] requestImageForAsset:lastAsset
//                                               targetSize:self.view.bounds.size
//                                              contentMode:PHImageContentModeAspectFit
//                                                  options:PHImageRequestOptionsVersionCurrent
//                                            resultHandler:^(UIImage *result, NSDictionary *info) {
//
//                                                if (result.scale == 1.0f) {
//                                                    [weakSelf showEmail:result];
//                                                }
//                                            }];
//}


@end
