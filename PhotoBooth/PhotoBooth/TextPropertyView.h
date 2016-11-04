//
//  TextPropertyView.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/30/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextPropertyView : UIView

@property (strong, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) NSString *fontNameString;

- (id)initWithFrame:(CGRect)frame;

@end
