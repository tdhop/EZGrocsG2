//
//  ShoppingDetailView.h
//  EZGrocs
//
//  Created by Mark A Stewart on 3/9/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnToMainView <NSObject>
@required
-(void) callBackFromSubView;
@end

@interface ShoppingDetailView : UIView
{
    id <ReturnToMainView> delegate;
}

-(void) setUpView: (NSString *)itemName sectId:(NSNumber *)sectionId;

@property (retain) id delegate;

@end
