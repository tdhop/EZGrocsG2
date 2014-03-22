//
//  ShoppingDetailView.m
//  EZGrocs
//
//  Created by Mark A Stewart on 3/9/14.
//  Copyright (c) 2014 EZLifeSoftware.com. All rights reserved.
//

#import "ShoppingDetailView.h"

@implementation ShoppingDetailView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"BV: initwframe");
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor lightGrayColor];
    }
    return self;
}

-(void)setUpView:(NSString *)itemName sectId:(NSNumber *)sectionId
{
    NSLog(@"detailview; itemname=%@, sectionId=%@",itemName,sectionId);
    
    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 320, 1)];
    separator.backgroundColor = [UIColor blackColor];
    [self addSubview:separator];
    
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,30,320,25)];
    itemLabel.text=itemName;
    [self addSubview:itemLabel];
    
    UIView * separator1 = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 1)];
    separator1.backgroundColor = [UIColor blackColor];
    [self addSubview:separator1];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,65,320,25)];
    sectionLabel.text=@"Section: Produce";
    [self addSubview:sectionLabel];
    
    UIView * separator2 = [[UIView alloc] initWithFrame:CGRectMake(0, 95, 320, 1)];
    separator2.backgroundColor = [UIColor blackColor];
    [self addSubview:separator2];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(10,250,100,25)];
    [button2 setTitle:@"Cancel" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor blueColor]];
    [button2 addTarget:self action:@selector(aCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
}

-(IBAction)aMethod:(id)sender
{
    NSLog(@"Show button tapped");
}

-(IBAction)aCancel:(id)sender
{
    NSLog(@"Cancel button tapped");
    [UIView beginAnimations:@"self" context:nil];
    [UIView setAnimationDuration:1.0];
    
    CGRect viewFrame = [self frame];
    viewFrame.origin.y -= 240;
    self.frame = viewFrame;
    
    [[self delegate] callBackFromSubView];
    
    [UIView animateWithDuration:1.0 delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{self.alpha = 0.0;}
                     completion:^(BOOL fin) {
                         if (fin) [self removeFromSuperview];
                     }];
}

@end
