//
//  GlobalConstants.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/25/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ScreenType) {
    ScreenTypeIntro,
    ScreenTypeLayout,
    ScreenTypeSendPhoto
};


#pragma mark - Typedefs

typedef void(^VoidBlock)(void);
typedef void(^SuccessBlock)(id responseObject);
typedef void(^TwoResultBlock)(id obj1, id obj2);
typedef void(^TwoIntResultBlock)(int obj1, int obj2);
typedef void(^ErrorBlock)(NSString *errorString);
