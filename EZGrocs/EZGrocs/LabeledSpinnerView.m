//
//  LabeledSpinnerView.m
//  ShoppingLib
//
//  Created by Tim Hopmann on 10/2/13.
//  Copyright (c) 2013 EZLifeSoftware.com. All rights reserved.
//

#import "LabeledSpinnerView.h"
#import <QuartzCore/QuartzCore.h> // Apple's Quartz Core Foundation which supports image processing and video image manipulation.  Needed for rounding corners of spinner background.

@interface LabeledSpinnerView ()

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UILabel *spinnerLabel;

@end

@implementation LabeledSpinnerView

- (void) setSpinnerHidesWhenStopped:(BOOL)spinnerHidesWhenStopped {
    self.spinner.hidesWhenStopped = YES;
}

- (BOOL) spinnerHidesWhenStopped {
    return self.spinner.hidesWhenStopped;
}

- (void) setSpinnerText:(NSString *)spinnerText {
    self.spinnerLabel.text = spinnerText;
}

- (NSString *) spinnerText {
    return self.spinnerLabel.text;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
            }
    return self;
}

- (id) initWithStyle: (LabeledSpinnerStyles) style {
    
    CGPoint viewCenter;
    
        // Get screen dimensions
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBounds.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    switch (style) {
        case LabeledSpinnerBottom:
                // Place code for bottom style here
            break;
            
        case LabeledSpinnerCenter:
                // Initialize CGRect for Center style here
            viewCenter = CGPointMake(screenWidth/2, screenHeight/2);
            break;
            
        case LabeledSpinnerTop:
                // Initialize CGRect for Top style here
            
        default:
            break;
    }
    
    CGRect  viewRect = CGRectMake(0, 0, 150, 150);
    self = [super initWithFrame:viewRect];
    
    if (self) {
            // Center self on the screen
        self.center = viewCenter;

            // Format self with corner radius and color
    
            // Round the edges
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
            // Set color to black
        self.backgroundColor = [UIColor blackColor];
        
            // Now, put a UIActivityIndicatorView on top of self
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            // Position spinner just below center of background
        self.spinner.center = CGPointMake(self.frame.size.width / 2, 20 + self.frame.size.height / 2);
            // Add the spinner
        [self addSubview:self.spinner];
        
            // Now put a label above the UIActivityIndicatorView to tell the user what's happening
        viewRect = CGRectMake(0, 20, 150, 30);
        self.spinnerLabel = [[UILabel alloc] initWithFrame: viewRect];
        self.spinnerLabel.backgroundColor = [UIColor blackColor];
        self.spinnerLabel.textColor = [UIColor whiteColor];
        self.spinnerLabel.textAlignment = NSTextAlignmentCenter;
        self.spinnerLabel.text = self.spinnerText;
        [self addSubview:self.spinnerLabel];
    }
    return self;
  
}

- (void) start {
    [self.spinner startAnimating];
}

- (void) stop {
    [self.spinner stopAnimating];
}

@end
