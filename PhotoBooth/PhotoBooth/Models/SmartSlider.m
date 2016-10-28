//
//  SmartSlider.m
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/27/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "SmartSlider.h"


@implementation SmartSlider

- (id)initWithFrame:(CGRect)frame minValue:(float)min maxValue:(float)max defaultValue:(float)value {

    self = [super initWithFrame:frame];

    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.minimumValue = min;
        self.maximumValue = max;
        self.continuous = YES;
        self.value = value;

        [self setupLabel];

        [self layoutIfNeeded];
    }
    
    return self;
}

- (void)setupLabel {
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(-50, -25, 50, 50)];
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = [NSString stringWithFormat:@"%0.f", self.value];

    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI_2);
    self.label.transform = trans;
    [self addSubview:self.label];
}

@end
