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

@interface SendPhotoViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewThankYou;

@end

@implementation SendPhotoViewController

#pragma mark - Lifecycles

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.imageViewThankYou.hidden = YES;

    [self showEmail:self.imageToSend];
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

    NSString *htmlMsg = @"<html><body><p>Baby Micko had an amazing time at his first birthday!<br>Thank you for making his day wonderful with your warm presence, thoughtful gift, and kind words.<br><br>Sincerely,<br>Rob & Joy</p></body></html>";

    NSData *jpegData = [NSData dataWithData:UIImageJPEGRepresentation(emailImage, 1.0)];

    NSString *fileName = @"photo";
    fileName = [fileName stringByAppendingPathExtension:@"jpeg"];

    if (jpegData) {
        [emailDialog addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
    }

    [emailDialog setSubject:@"Micko's 1st Birthday Party Photobooth pic"];
    [emailDialog setMessageBody:htmlMsg isHTML:YES];

    [self presentViewController:emailDialog animated:YES completion:nil];
}


#pragma mark - MFMailComposeViewControllerDelegate methods

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    __weak typeof(self) weakSelf = self;

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
                message = @"Photo sent, thanks for attending the party! :)";

                break;
            case MFMailComposeResultFailed:
                NSLog(@"email sent failure: %@", [error localizedDescription]);
                message = @"Failed to send photo, we will send your photobooth pic soon :)";
                
                break;
                
            default:
                break;
        }
    }

    self.imageViewThankYou.hidden = NO;

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];

    [GlobalUtility showAlert:self title:nil message:message completionHandler:^{
        [weakSelf performSegueWithIdentifier:@"unwindToIntroScreen" sender:self];
    }];
}


#pragma mark - Helpers
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
