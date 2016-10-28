//
//  SmartSlider.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/27/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartSlider : UISlider

@property (strong, nonatomic) UILabel *label;

- (id)initWithFrame:(CGRect)frame minValue:(float)min maxValue:(float)max defaultValue:(float)value;
@end
