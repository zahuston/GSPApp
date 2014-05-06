//
//  Gradient.m
//  GSPEvents
//
//  Created by Zach Huston on 12/24/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "Gradient.h"

#define NUM_COLOR_COMPONENTS 8
#define NUM_LOCATIONS 2

@implementation Gradient

/*
    Abstracts away c style arrays, allowing the caller to pass in objective c friendly NSArray
    The view passed is the view behind which the gradient should be drawn
    Should always use this constuctor
 */
-(id)initWithColors:(NSArray *)components Locations:(NSArray *)locations andView:(UIView *)view
{
    if (self = [super init])
    {
        if ([components count] != NUM_COLOR_COMPONENTS || [locations count] != NUM_LOCATIONS)
        {
            NSLog(@"Passed an incorrect number of components to create a gradient. Still not certain this needs to be static");
        }
        
        self.colors = malloc(sizeof(CGFloat) * NUM_COLOR_COMPONENTS);
        self.locations = malloc(sizeof(CGFloat) * NUM_LOCATIONS);
        
        for (int i = 0; i < NUM_COLOR_COMPONENTS; i++)
        {
            self.colors[i] = [(NSNumber *)components[i] floatValue] / 255;
        }
        
        for (int i = 0; i < NUM_LOCATIONS; i++)
        {
            self.locations[i] = [(NSNumber *)locations[i] floatValue];
        }
        
        self.associatedView = view;
        self.frame = view.frame;
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [self drawGradientInRect];
//    [self.associatedView addSubview:self];
}

-(void)drawGradientInRect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context); //Triggering context error in log. As of writing, known bug and apple is working on a fix
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (colorSpace,
     self.colors,
     self.locations,
     NUM_LOCATIONS);
    
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(CGRectGetMidX(self.associatedView.bounds), CGRectGetMinY(self.associatedView.bounds)),
                                CGPointMake(CGRectGetMidX(self.associatedView.bounds), CGRectGetMaxY(self.associatedView.bounds)),
                                0);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
    
}

//Makes sure to free the colors malloced earlier
-(void)dealloc
{
    free(self.colors);
    free(self.locations);
}

@end
