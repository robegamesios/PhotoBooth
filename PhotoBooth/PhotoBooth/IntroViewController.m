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
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL) shouldAutorotate {
    return NO;
}

- (IBAction)unWindToIntroScreen:(UIStoryboardSegue *)segue {

}

@end
