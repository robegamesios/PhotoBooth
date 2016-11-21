//
//  InfoViewController.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 11/21/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "InfoViewController.h"

NSString *const AppID = @"1178580289";
NSString *const SupportWebsite = @"http://robegamesios.wixsite.com/ethminingmonitor/support";//RE: TODO:
NSString *const RateAppAddressFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)rateAppButtonTapped:(UIButton *)sender {

    NSString *str = [NSString stringWithFormat:RateAppAddressFormat, AppID];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)feedbackButtonTapped:(UIButton *)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: SupportWebsite]];
}

- (IBAction)backButtonTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"unwindToIntroScreen" sender:self];
}

@end
