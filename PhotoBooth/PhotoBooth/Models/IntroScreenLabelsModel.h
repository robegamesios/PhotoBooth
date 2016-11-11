//
//  IntroScreenLabelsModel.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 11/8/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <Realm/Realm.h>

@interface IntroScreenLabelsModel : RLMObject

@property NSString *string;
@property float frameOriginX;
@property float frameOriginY;
@property float frameWidth;
@property float frameHeight;

@end
