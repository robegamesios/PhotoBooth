//
//  SmartSlider.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/27/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "SmartSlider.h"


@implementation SmartSlider

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, 0, -20);
    return CGRectContainsPoint(bounds, point);
}

@end
