//
//  TextPropertyView.h
//  PhotoBooth
//
//  Created by Rob Enriquez on 10/30/16.
//  Copyright © 2016 robert enriquez. All rights reserved.
//

#import "BaseView.h"

@interface TextPropertyView : BaseView

@property (weak, nonatomic) IBOutlet UIButton *fontStyleButton;
@property (weak, nonatomic) IBOutlet UIButton *fontColorButton;
@property (weak, nonatomic) IBOutlet UIButton *fontStrokeColorButton;


@end
