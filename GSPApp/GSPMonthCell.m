//
//  GSPMonthCell.m
//  GSPEvents
//
//  Created by Zach Huston on 9/22/13.
//  Copyright (c) 2013 Zach Huston. All rights reserved.
//

#import "GSPMonthCell.h"
#import "CircleView.h"
#import "NSDate+LastAndFirst.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexString.h"


@interface GSPMonthCell()

@property bool initialized;

@end

@implementation GSPMonthCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.contentView.layer setBorderWidth:1.0f];
        self.eventsCount = 0;
        self.backgroundColor = [UIColor colorFromHexString:@"497da8"];
    }
    return self;
}


//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    CGContextSaveGState(context);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient = CGGradientCreateWithColorComponents
//    (colorSpace,
//    (const CGFloat[8]){.99f, .99f, .99f, 1.0f, .9f, .9f, .9f, 1.0f},
//    (const CGFloat[2]){0.0f,1.0f},
//    2);
//
//    CGContextDrawLinearGradient(context,
//    gradient,
//    CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)),
//    CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
//    0);
//
//    CGColorSpaceRelease(colorSpace);
//    CGContextRestoreGState(context);
//    self.initialized = true;
//}

-(void)initializeCellContentsFor:(NSInteger)dayOfMonth andWith:(NSInteger)numberOfEvents
{
    self.dayOfMonth = dayOfMonth;
    if (dayOfMonth > 0)
    {
        // Make certain not to draw over old views
        [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // Draw the day number
        NSString *dayString = [NSString stringWithFormat:@"%i", dayOfMonth];
        UILabel *daylabel = [[UILabel alloc] initWithFrame:CGRectMake(2, -4, 20, 20)];
        daylabel.text = dayString;
        daylabel.font = [UIFont fontWithName:@"Helvetica" size:10.0f];
        daylabel.backgroundColor = [UIColor clearColor];
        daylabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:daylabel];
        
        // Draw incons indicating events are occuring on a date, max of 4 currently
        self.eventsCount = numberOfEvents;
        [self drawEvents];

    }
    else { // Grey out
        self.contentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.2];
    }
}

-(void)drawEvents
{
    CGFloat startPoint = self.contentView.frame.size.width / 2 + 4;
    startPoint -= (EVENT_INDICATOR_SIZE / 2) + (EVENT_INDICATOR_SPACING + EVENT_INDICATOR_SIZE) * self.eventsCount / 2;
    
    for (int i = 0; i < MIN(4, self.eventsCount); i++)
    {
        CGRect circleFrame = CGRectMake(startPoint, self.contentView.frame.size.height - 12, EVENT_INDICATOR_SIZE, EVENT_INDICATOR_SIZE);
        NSLog(@"Circle frame: %@", NSStringFromCGRect(circleFrame));
        CircleView *eventSquare = [[CircleView alloc] initWithFrame:CGRectMake(startPoint, self.contentView.frame.size.height - 12, EVENT_INDICATOR_SIZE, EVENT_INDICATOR_SIZE) andColor:[UIColor whiteColor]];
//        eventSquare.clipsToBounds = YES;
//        eventSquare.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
//        eventSquare.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:eventSquare];
        startPoint += EVENT_INDICATOR_SIZE + EVENT_INDICATOR_SPACING;
    }
    
    if (self.eventsCount > 0) {
        [self setNeedsDisplay]; [self.contentView setNeedsDisplay];
    }

}

@end
