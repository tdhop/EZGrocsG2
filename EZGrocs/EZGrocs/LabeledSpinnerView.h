//
//  LabeledSpinnerView.h
//  ShoppingLib
//
//  Created by Tim Hopmann on 10/2/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LabeledSpinnerCenter,
    LabeledSpinnerTop,
    LabeledSpinnerBottom
    } LabeledSpinnerStyles;

@interface LabeledSpinnerView : UIView

@property (strong, nonatomic) NSString *spinnerText; // Text that shows above the spinner
@property BOOL spinnerHidesWhenStopped;

- (id) initWithStyle: (LabeledSpinnerStyles) style;

- (void) start; // Starts the spinner animation

- (void) stop; // Stops the spinner animation

@end
