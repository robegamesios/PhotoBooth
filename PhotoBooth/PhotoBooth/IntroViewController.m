//
//  IntroViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/17/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
