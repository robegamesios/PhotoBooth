//
//  IntroViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/17/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "IntroViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if(status == AVAuthorizationStatusAuthorized) { // authorized

    }
    else if(status == AVAuthorizationStatusDenied){ // denied

    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted


    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined

        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){ // Access has been granted ..do something

            } else { // Access denied ..do something
                
            }
        }];
    }
}

// Lock orientation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (IBAction)unwindToIntroScreen:(UIStoryboardSegue *)segue {

}

@end
